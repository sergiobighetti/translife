***************************************************************************************************************
* Regra de valorização de produtos para o contrato da 49 PROTESTE
* O ponto de equilibro é 25.000 vidas ao custo de 1,76 = R$ 44.000,00
* apos 25.000 vidas até 29.000 - cobrar as vidas excedente a R$ 1,56
* apos 29.001 vidas até 33.000 - cobrar as vidas excedentes a R$ 1,36
***************************************************************************************************************
Lparameters nCtr, dRef
LOCAL nIdA, nIdP, nVlr, cTmp, nSel, oTerm, nTotal, nPerc, nRec, lAlerta

nSel = SELECT()
cTmp = SYS(2015)


WAIT WINDOW tran(nCtr) + ') ACERTO DE VALORES. Selecionando... aguarde' NOWAIT NOCLEAR

set dele ON

Select      ;
            aa.idAssoc ;
           ,aa.idPlano ;
           ,aa.valor   ;
FROM        ASSOCIADO_PLANO aa ;
JOIN        ASSOCIADO bb On aa.idAssoc=bb.idAssoc ;
WHERE       bb.idContrato=nCtr And bb.situacao='ATIVO' AND aa.idPlano=18;
ORDER By    aa.idAssoc ;
INTO Cursor (cTmp)

WAIT CLEAR 

oTerm = Newobject("_thermometer","_therm","","Procedendo acerto de valores")
oTerm.Show()

lAlerta = .f.

nTotal = Reccount( cTmp )
SET STEP ON 
Scan All

   nPerc = ( ( recno(cTmp) / nTotal ) * 100 )
   oTerm.Update( nPerc, "Registro "+TRAN(recno(cTmp))+"/"+TRAN(nTotal))

   nIdA = &cTmp..idAssoc
   nidP = &cTmp..idPlano
   nRec = RECNO(cTmp)

   Select ASSOCIADO_PLANO
   SET ORDER TO IDASSOC
   If Seek( nIdA, 'ASSOCIADO_PLANO', 'IDASSOC' )
      Scan While idAssoc=nIdA And !Eof()
         If ASSOCIADO_PLANO.idPlano = nidP
            Replace ASSOCIADO_PLANO.valor_ant With valor
            Do Case
               Case ( nRec >= 00000 AND nRec <= 25000 )   && 25.000 vidas ao custo de 1,76
                  nVlr = 1.76
               Case ( nRec >= 25001 AND nRec <= 29000 )   && 25.001 vidas até 29.000 - cobrar as vidas excedente a R$ 1,56
                  nVlr = 1.56
               Case ( nRec >= 29001 AND nRec <= 33000 )   && 29.001 vidas até 33.000 - cobrar as vidas excedentes a R$ 1,36
                  nVlr = 1.36
               Case nRec >= 33001  && R$ 0,14 POR BENEFICIÁRIO/TITULAR PARA ACIMA DE 100.001 BENEFICIÁRIOS
                  nVlr = 1.36
				  lAlerta = .t.
            Endcase
            Replace ASSOCIADO_PLANO.valor With nVlr
         Endif
      Endscan
   Endif

   Select (cTmp)
Endscan

oTerm.Complete()


USE IN (SELECT(cTmp))

IF lAlerta
	MESSAGEBOX( 'O contrato excedeu a 33.000 vidas e deve ser renegociado', 64, 'Atenção' )
ENDIF 

SELECT (nSel)

Return Tableupdate( 2, .T., 'ASSOCIADO_PLANO' )