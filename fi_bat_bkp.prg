Local cBAT, cArq, cArqBAT, cNewBAT

*!*   cArqBAT = "D:\SCRIPT.BAT"
*!*   cNewBAT = 'D:\xSCRIPT.BAT'

*If File( cArqBAT )

   *!*      IF FILE(cNewBAT)
   *!*         Delete File (cNewBAT)
   *!*      ENDIF
   *!*      cArq    = Dtos(Date())
   *!*      cBAT    = Filetostr( cArqBAT )
   *!*      cBAT    = Strtran( cBAT, '<<DIADOBKP>>', cArq )

   If File('\\dcrpo\BDMDC$\ATEND_AVISO.DBF')
      Try
         Use \\dcrpo\BDMDC$\ATEND_AVISO Exclusive
         Select ATEND_AVISO
         Delete For sit='*'
         Pack
         Use
      Catch
      Endtry
   Endif

*!*   *!*   *!*   *!*      cArq = Dtos(Date())
*!*   *!*   *!*   *!*      Try
*!*   *!*   *!*   *!*         Md ("\\info4\public\"+cArq)
*!*   *!*   *!*   *!*      Catch
*!*   *!*   *!*   *!*      Endtry

*!*   *!*   *!*   *!*      If Directory("\\info4\public\"+cArq)
*!*   *!*   *!*   *!*         fso = Createobject('Scripting.FileSystemObject')
*!*   *!*   *!*   *!*         fso.CopyFolder( "\\dcrpo\bdmem",  "\\info4\\public\" +cArq+ "\bdmem", .T.)
*!*   *!*   *!*   *!*         fso.CopyFolder( "\\dcrpo\bdbdc$", "\\info4\\public\" +cArq+ "\bdbdc", .T.)
*!*   *!*   *!*   *!*         Release fso
*!*   *!*   *!*   *!*      Endif

   *!*      =Strtofile( cBAT, cNewBAT )
   *!*      Declare Integer ShellExecute In SHELL32.Dll ;
   *!*         INTEGER nWinHandle,;
   *!*         STRING cOperation,;
   *!*         STRING cFileName,;
   *!*         STRING cParameters,;
   *!*         STRING cDirectory,;
   *!*         INTEGER nShowWindow
   *!*      =ShellExecute(0, "Open", cNewBAT, "", "", 1)

*Endif
