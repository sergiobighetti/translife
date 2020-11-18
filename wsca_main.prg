_Screen.Visible = .F.
Set Talk Off

Declare Integer ShellExecute ;
   IN SHELL32.Dll ;
   INTEGER nWinHandle,;
   STRING cOperation,;
   STRING cFileName,;
   STRING cParameters,;
   STRING cDirectory,;
   INTEGER nShowWindow


Local aExe[1], aDirExe[1]
Local i, cMsg, cPath

cPath = Justpath( Fullpath('') )

nQtd = Adir(aDirExe,'S*.EXE')

If nQtd > 0

   For i = 1 To nQtd
      Dimension aExe[i]
      aExe[i] = aDirExe[i,1]
   Endfor

   Asort(aExe)
   cMsg = ''

   ShellExecute( 0, "Open", aExe[nQtd], "", cPath, 1)
   Read Events

Endif

Clear All
Clear Memory
Release All
Exit
Quit


*!*   Function enumerateProcess
*!*   lcComputer = '.'
*!*   loWMIService = Getobject('winmgmts:'  + '{impersonationLevel=impersonate}!\\' + lcComputer + '\root\cimv2')
*!*   colProcessList = loWMIService.ExecQuery('Select * from Win32_Process')
*!*   Create Cursor Process (Name c(20),Id i,Thread i,pagefile i,pagefault i,workingset c(20))
*!*   Index On Name Tag Name
*!*   For Each loProcess In colProcessList
*!*      Insert Into Process (Name,Id,Thread,pagefile,pagefault,workingset);
*!*         VALUES (Upper(loProcess.Name),loProcess.ProcessID,loProcess.ThreadCount,loProcess.PageFileUsage,;
*!*         loProcess.pagefaults,loProcess.WorkingSetSize)
*!*   Next
*!*   Browse Normal


