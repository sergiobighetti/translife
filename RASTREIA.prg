LOCAL cAlsDIF, cAlsOLD, cArqDIF, cArqLOG, cArqOLD, cData, dDataAnt, nSel, tDate, cSAFETY

cArqLOG = '\\192.168.0.200\bdmem\RASTREIA.LOG'

cArqOLD = '\\192.168.0.200\bdmem\CTR_O_L_D'
* cArqOLD = 'c:\tmp\CTR_O_L_D.DBF'
cAlsOLD = 'CTR_O_L_D'

cArqDIF = '\\192.168.0.200\bdmem\CTR_D_I_F'
* cArqDIF = 'c:\tmp\CTR_D_I_F.DBF'
cAlsDIF = 'CTR_D_I_F'
cLog    = SYS(2015)

IF FILE(cArqLOG)
  
   cData = ALLTRIM(FILETOSTR( LOCFILE(cArqLOG) ))

   IF !EMPTY(cData)

      cSAFETY  = fi_SET( 'SAFETY', 'OFF' )

      nSel     = SELECT()
      dDataAnt = EVALUATE( '{^'+TRANSFORM(cData,'@R 9999-99-99' ) +'}' )

      IF (DATE() - dDataAnt) > 0
         SELECT idContrato AS ID, nome_responsavel AS razao, auditoria FROM CONTRATO ORDER BY idContrato INTO TABLE (cArqOLD)
         =STRTOFILE( DTOS(DATE()),cArqLOG, 0 )
      ENDIF
      tDate = DATETIME()

      SELECT        aa.idContrato        AS ID         ;
                  , aa.nome_responsavel  AS nome_NEW   ;
                  , bb.razao             AS nome_OLD   ;
                  , aa.auditoria                       ;
                  , tDate                AS dataHora   ;
      FROM        CONTRATO aa                          ;
      LEFT JOIN   (cArqOLD) bb ON aa.idContrato==bb.ID ;
      WHERE        NOT aa.nome_responsavel == bb.razao ;
      INTO CURSOR (cLog)

      IF _TALLY > 0
         IF FILE(cArqDIF)
            TRY
               USE (cArqDIF) IN 0 ALIAS (cAlsDIF)
               IF USED(cAlsDIF)
                  SELECT (cAlsDIF)
                  APPEND FROM DBF(cLog)
                  GO TOP 
               ENDIF
            CATCH
            ENDTRY
         ENDIF
      ENDIF

      =fi_SET( 'SAFETY', cSAFETY  )

      USE IN (SELECT(cLog     ))
      USE IN (SELECT(cAlsDIF  ))
      USE IN (SELECT(cAlsOLD  ))
      SELECT (nSel)
   ENDIF
ENDIF


 