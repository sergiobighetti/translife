
clear
clear memory

set exclusive off
set date briti
set resource off

cd \\servidor\sistema$
local i, nQtd, aExe[1]

nQtd = adir( aExe, 'EXE' )

if nQtd > 0

   create cursor LV_NomeEXE( NomeExe, DataArq t )

   for i = 1 to nQtd
      insert into LV_NomeEXE ;
         ( aExe[i,1], evaluate( '{^'+ transform( dtos(aExe[i,3], '@R 9999/99/99' )+ ' ' aExe[i,4] ) +'}' ) )
   next

   select NomeExe from LV_NomeEXE order by DataArq desc into array aExe
   cExeName = aExe[1]

   clear memory
   close tables all
   close all
   clear all

   declare integer ShellExecute in shell32.dll ;
      integer hndWin, string cAction, string cFileName, string cParams, string cDir, integer nShowWin

   =ShellExecute( 0, "open", cExeName, "", "", 1 )

endif
