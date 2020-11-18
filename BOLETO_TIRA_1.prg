*-- 16/07/2013: Ajuste dos valores de boletos conforme conversa telefonica com Marcio
*   Retirar o valor de 1 real do boleto de todos os cancelados
*   Dos ativos AP retira o valor do boleto e agrega ao valor do contrato
*   Dos CO,FA retira o valor do boleto e agrega ao 1o titular 

CLEAR
SET ESCAPE ON 

CLOSE DATABASES all
CLOSE TABLES all

USE ASSOCIADO        IN 0
USE ASSOCIADO_PLANO  IN 0


*INICIO------------------------------------------------- tira taxa de boleto dos CANCELADOS
SELECT SUBSTR(bb.codigo,3,2) Tipo, aa.idContrato ;
FROM   RCONTRAT aa ;
JOIN   CONTRATO bb ON aa.idContrato=bb.idContrato ;
WHERE  aa.taxa_bol > 0 AND bb.situacao='CANC'  ;
INTO CURSOR XCANC 

? ALIAS()

SELECT XCANC
SCAN all
   nID = XCANC.idContrato

   SELECT RCONTRAT
   SET ORDER TO IDCONTRATO   && IDCONTRATO
   IF SEEK(nId)
      replace taxa_bol WITH 0 while idContrato==nId AND !EOF()
      ?? [.]
   ENDIF 

   SELECT XCANC
ENDSCAN    
*FIM------------------------------------------------- tira taxa de boleto dos CANCELADOS




*INICIO------------------------------------------------- tira taxa de boleto dos CANCELADOS
SELECT SUBSTR(bb.codigo,3,2) Tipo, aa.idContrato, aa.taxa_bol ;
FROM   RCONTRAT aa ;
JOIN   CONTRATO bb ON aa.idContrato=bb.idContrato ;
WHERE  aa.taxa_bol > 0 AND bb.situacao='ATIVO' AND SUBSTR(bb.codigo,3,2) in ('AP', 'CO', 'FA' ) ;
ORDER BY bb.tipo_contrato, aa.idContrato ;
INTO CURSOR XCANC 


Select XCANC
Scan All

   nID = XCANC.idContrato

   If XCANC.tipo='AP'
      Select contrato
      If Seek( nID, 'CONTRATO', 'I_D' )
         Replace valor With valor+XCANC.taxa_bol
         ?? [a]
      Endif
   Else
      Select associado
      Set Order To idContrato
      If Seek( nID, 'ASSOCIADO' )
         lOk = .T.
         Scan While idContrato=nID And lOk And !Eof()

            *   TITULAR                      COM VALOR                ATIVO                        
            If SUBSTR(codigo,11,2)='00' AND associado.valor > 0 And associado.situacao='ATIVO' 

               nIdAssoc = associado.idAssoc

               Select Top 1 idAssoc, idplano, valor, idvend, parcela, dtinc, ultfat, valor_ant, regra_cod  ;
                  FROM ASSOCIADO_PLANO ;
                  WHERE idAssoc=nIdAssoc ;
                  ORDER By valor Desc, idplano Into Cursor XAP

               If _Tally > 0

                  Select ASSOCIADO_PLANO
                  Set Order To idAssoc
                  If Seek( nIdAssoc, 'ASSOCIADO_PLANO' )
                  
                     Scan While idAssoc=nIdAssoc
                        If     idplano=XAP.idplano And valor=XAP.valor   And idvend=XAP.idvend ;
                           AND parcela=XAP.parcela And ultfat=XAP.ultfat And valor_ant=XAP.valor_ant ;
                           AND regra_cod=XAP.regra_cod
                           
                           Replace valor_ant  With valor
                           Replace valor      With valor +XCANC.taxa_bol 
                           lOk = .F.
                           ?? [.]
                           exit
                           
                        Endif
                     Endscan
                  Endif
               Endif

            Endif

            Select associado
         Endscan
      Endif
   Endif



   SELECT RCONTRAT
   SET ORDER TO IDCONTRATO   && IDCONTRATO
   IF SEEK(nId)
      replace taxa_bol WITH 0 while idContrato==nId AND !EOF()
      ?? [.]
   ENDIF    
   
   Select XCANC
Endscan

