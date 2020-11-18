FUNCTION fi_HARDFING
LPARAMETERS cArea, cCampoChave, _Chave

LOCAL nSel, i, cGFS
LOCAL cAntes, cCampo, cDepois, nQtdCAMPO
nSel = SELECT()


SELECT (cArea)

IF FILE('HARDFING.DBF')

   IF CURSORGETPROP("Buffering",cArea) >= 3
   
      cGFS = GETFLDSTATE(-1)

      IF OCCURS('2',cGFS) > 0

         TRY
            USE HARDFING IN 0 SHARED
         CATCH
         ENDTRY


         IF USED( 'HARDFING' )


            SELECT (cArea)
            nQtdCAMPO = FCOUNT(cArea)
            FOR i=1 TO nQtdCAMPO

               cCampo = FIELD(i,cArea)
               IF GETFLDSTATE(cCampo ,cArea) = 2

                  cAntes  = TRANSFORM(  OLDVAL( cCampo ,cArea ))
                  cDepois = TRANSFORM( EVALUATE( cArea+'.'+cCampo  ) )
 
                  SELECT HARDFING 
                  APPEND BLANK
                  replace HARDFING.arquivo  WITH cArea                   
                  replace HARDFING.campochv WITH cCampoChave   
                  replace HARDFING.chave    WITH TRANSFORM(_Chave)
                  replace HARDFING.campoalt WITH cCampo 
                  replace HARDFING.antes    WITH cAntes 
                  replace HARDFING.depois   WITH cDepois 
                  replace HARDFING.datahora WITH DATETIME()
                  replace HARDFING.usuario  WITH m.drvnomeusuario
                  SELECT (nSel)

               ENDIF
            NEXT

            USE IN (SELECT('HARDFING'))

         ENDIF
      ENDIF
   ENDIF
ENDIF
SELECT (nSel)
RETURN .T.
 