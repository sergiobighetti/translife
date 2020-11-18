CLOSE DATABASES all
CLOSE TABLES all
USE CCUSTO
SCAN FOR !EMPTY(de)

   nQtdDE  = ALINES( aDE, ALLTRIM(CCUSTO.de),1, '/' )
   nIDPara = ccu_id

   FOR i = 1 TO nQtdDE
      nID_DE = INT( VAL( aDE[i] ) )
      UPDATE APAGAR_PC SET idcta= nIDPara WHERE idcta= nID_DE
   NEXT 
   

   SELECT CCUSTO
ENDSCAN 