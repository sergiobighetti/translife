CLOSE DATABASES all
CLOSE TABLES all
CLEAR 
OPEN DATABASE bdtransp EXCLUSIVE

nTot = adbobjects( aTab, "Table")
cDir = 'C:\Documents and Settings\DFOX\Desktop\TEMP\'

FOR i = 1 TO nTot
   ? aTab[i]
   IF FILE( cDir+aTab[i]+[.DBF] )
      USE (aTab[i]) EXCLUSIVE
      ZAP 
      APPEND FROM (cDir+aTab[i])
   ENDIF
   
ENDFOR   