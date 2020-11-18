CLOSE DATABASES all
CLOSE TABLES all
SET ESCAPE ON
SET EXCLUSIVE OFF
SET DATE BRITISH
CLEAR 
OPEN DATABASE C:\tmp\bdd\ajusta
nTot = adbobjects( aTab, "Table")
cDir = 'C:\DESENV\WIN\VFP9\MMED\'

FOR i = 1 TO nTot
   ? aTab[i]
   IF FILE( 'C:\tmp\bdd\'+ aTab[i] +[.DBF] )
      USE ( 'C:\tmp\bdd\'+ aTab[i]         ) 
      COPY TO 'C:\DESENV\WIN\VFP9\MMED\'+ ALIAS() DATABASE (cDir+'BDMDC') WITH CDX
      USE 
   ENDIF
ENDFOR   