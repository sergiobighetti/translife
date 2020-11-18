CLOSE DATABASES all
CLOSE TABLES all
USE PCONTA
SCAN FOR !EMPTY(de)

   nQtdDE  = ALINES( aDE, ALLTRIM(PCONTA.de),1, '/' )
   nIDPara = idCta

   FOR i = 1 TO nQtdDE
      nID_DE = INT( VAL( aDE[i] ) )
      UPDATE ARECEBER SET codigo_subconta= nIDPara WHERE codigo_subconta= nID_DE
   NEXT 
   

   SELECT PCONTA   
ENDSCAN 