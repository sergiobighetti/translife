* LIMPA TODOS REGISTROS ANTES DE 2011

dRefAREC = {^2011-01-01}

dRefDelASSOC = goMOnth(date(),-24)
dRefDelASSOC = date( year(dRefDelASSOC), 1, 1 )

dRefAP       = goMOnth(date(),(12*5)*-1) &&-- ultimos 5 anos
dRefAP       = date( year(dRefAP), 1, 1 )

Close Databases All
Close Tables All

Use NFISCAL      In 0
Use IFISCAL      In 0
Use ARECEBER     In 0
Use ARECEBER_CMS In 0
Use BXAREC       In 0
Use BANCO        In 0
Use EXTRATO      In 0
USE ASSOCIADO    in 0
USE CONTRATO     in 0



scan for !empty(data_baixa) and data_baixa <= dRefAP and situacao='LQ'

    nCtr  = APAGAR.controle
    nIDBX = APAGAR.idBaixa
    
    delete from APAGAR_PC where controle=nCtr
    
    *-- desligar a SP
    *-- delete from EXTRATO where controle=nIDBX

    select APAGAR
endscan


** Associados que nunca tiveram algum atendimento e se encontram cancelados mais de 2 anos, bem como histórico gerados por estes associados;
select ASSOCIADO
SCAN ASSOCIADO.situacao='CANCELADO' and ASSOCIADO.dataExc <= dRefDelASSOC

       nId  = ASSOCIADO.idAssoc
       cCod = ALLT(ASSOCIADO.codigo)
       nCtr = ASSOCIADO.idContrato

       *-- apaga informações secundarias
       delete from ASSOCIADO_ACLINICO where idAssoc=nId
       delete from ASSOCIADO_HOSPITAL where idAssoc=nId
       delete from ASSOCIADO_PLANO    where idAssoc=nId
       delete from ASSOCIADO_PSAUDE   where idAssoc=nId

       *-- verifica se o contrato teve antendimento
       SELECT count(*) FROM ATENDIMENTO where paccodigo=cCod and ctrNumero=nCtr UNION ALL ;
       SELECT count(*) FROM HSTATEND    where paccodigo=cCod and ctrNumero=nCtr INTO CURSOR LV_VER_ATD
       
       select ASSOCIADO
       if reccount( 'LV_VER_ATD' ) > 0
           loop
       endif 
        
       delete 
    
ENDSCAN 


select CONTRATO
scan for situacao='CANCELADO' and dataExc <= dRefDelASSOC

    nID = CONTRATO.idContrato
    
    SELECT count(*) FROM ATENDIMENTO where ctrNumero=nId UNION ALL ;
    SELECT count(*) FROM HSTATEND    where ctrNumero=nId INTO CURSOR LV_VER_ATD

    select CONTRATO
    if reccount('LV_VER_ATD') > 0
        loop
    endif 
    
    delete 

    select CONTRATO
endscan




Select NFISCAL
Set Order To CONTROLE

*-- limpeza do contas a receber
Select ARECEBER
Scan All
   nID = ARECEBER.CONTROLE

   Clear

   @ 10, 10 Say "ARECEBER----> "+ Transform(Recno())+' / '+Transform(Reccount())

   *-- pula o que estiver em aberto
   If ARECEBER.situacao='ABERTO'
      Loop
   Endif

   *-- pula o que estiver com vencimento maior/igual a referencia
   If ARECEBER.data_vencimento >= dRefAREC
      Loop
   Endif

   *-- apaga os lancamentos de comissao
   Delete From ARECEBER_CMS Where CONTROLE=nID
   @ 11,10 Say "ARECEBER_CMS: "+ Transform( _Tally )

   *-- apagar os lancamentos de BAIXA
   Delete From BXAREC       Where CONTROLE=nID
   @ 12,10 Say "      BXAREC: " + Transform( _Tally )


   If ARECEBER.idNF > 0

      Select NFISCAL
      If Seek( ARECEBER.idNF, 'NFISCAL', 'CONTROLE' )
         IF !EMPTY(NFISCAL.dataEmissao)
            Delete From IFISCAL Where IFISCAL.CONTROLE = ARECEBER.idNF
            @ 13,10 Say 'IFISCAL: '+Transform(_Tally)
            Delete In NFISCAL
         ENDIF 
      Endif
   Endif

   Select ARECEBER

   *-- apaga o registro
   Delete In ARECEBER

Endscan



Select NFISCAL
Scan For !Empty(dataemissao) And dataemissao < dRefAREC

   @ 10, 10 Say "NFISCAL-----> "+ Transform(Recno())+' / '+Transform(Reccount())
   nID = NFISCAL.CONTROLE
   Delete From IFISCAL Where IFISCAL.CONTROLE = nID
   @ 11,10 Say 'IFISCAL: '+Transform(_Tally)

Endscan
