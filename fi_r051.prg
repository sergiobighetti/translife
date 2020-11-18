* Funcao utilizada no releatorio R051.FRX
FUNCTION fi_R051
LPARAMETERS nKey, cCampo
LOCAL nSele, cRtn

nSele = SELECT()
cRtn  = '' 

TRY 

   SELECT CLV_51_RSM
   LOCATE FOR idVend == nKey

   IF FOUND()
      cRtn = &cCampo
   ENDIF 

CATCH
ENDTRY

SELECT (nSele)

RETURN cRtn