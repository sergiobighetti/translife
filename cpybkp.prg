CLOSE DATABASES all
CLOSE TABLES all
SET ESCAPE ON
SET EXCLUSIVE OFF
SET DATE BRITISH

CLEAR 
OPEN DATABASE bdmdc 

nTot = adbobjects( aTab, "Table")
cDir = 'F:\MASTER\TAB\BKP\'

FOR i = 1 TO nTot
   ? aTab[i]
   IF FILE( 'F:\MASTER\TAB\'+aTab[i]+[.DBF] )
      USE ('F:\MASTER\TAB\'+aTab[i]) 
      COPY TO 'F:\MASTER\TAB\BKP\'+ALIAS() DATABASE (cDir+'AJUSTA') WITH CDX
      USE 
   ENDIF
   
ENDFOR   