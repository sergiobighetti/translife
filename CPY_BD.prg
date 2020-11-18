Close Databases All
Close Tables All

SET ESCAPE ON
SET SAFETY OFF

cBdNome = 'bdmdc'
cDir = 'C:\Desenv\Win\vfp9\SCA_NEW\'
cBd = cDir+ cBdNome


clear

Copy File (cDir+ cBdNome+ '.*') To ('C:\Desenv\Win\vfp9\SCA_NEW\CPY\'+cBdNome+'.*')
Open Database (cBd) Shared

nTot = Adbobjects( aTab, "Table")

Close Databases All
Close Tables All

For nLoop = 1 To nTot
   cArq = Alltrim( aTab[nLoop] )
   ? 'Compiando ... '+ TRANSFORM(nLoop)+ ' .... '+ cArq
   Copy File (cDir+ aTab[nLoop]+'.*') To ('C:\Desenv\Win\vfp9\SCA_NEW\CPY\'+aTab[nLoop]+'.*')
Next
