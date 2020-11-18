#INCLUDE comun.h

CLEAR MEMORY
CLEAR ALL

LOCAL lnCnt, lnHwnd, lcNewDir, lwStartUp,  lnNameLength, gnFileHandle, nSize, cString
LOCAL cVersao, lcBuffer, cCaption, nAt, nRat, cStr, i, cDirTab
LOCAL cArqINI, lReentrada 
LOCAL ARRAY laVFPBars(13)

PUBLIC drvDiretorio, drvWindowsDir, oErr, drvTmpPath, drvIpLocal, drvRefGlobal
PUBLIC drvID, drvWinUserName, drvWindowsUserName

SET TALK OFF
SET DEBUG OFF
SET ESCAPE OFF
SET RESOURCE OFF


drvRefGlobal = ''

********************************************** ***************************************
*  A PARTIR DE AQUI EMPEZAMOS A CONFIGURAR EL ENTORNO, ABRIR LO QUE NECESITAMOS, ETC *
*  MIENTRAS EL FORMULARIO DE ARRANNQUE ESTA VISIBLE                                  *
************************************************ *************************************

*!* Valores
laVFPBars( 1) = TB_FORMDESIGNER_LOC
laVFPBars( 2) = TB_STANDARD_LOC
laVFPBars( 3) = TB_LAYOUT_LOC
laVFPBars( 4) = TB_QUERY_LOC
laVFPBars( 5) = TB_VIEWDESIGNER_LOC
laVFPBars( 6) = TB_COLORPALETTE_LOC
laVFPBars( 7) = TB_FORMCONTROLS_LOC
laVFPBars( 8) = TB_DATADESIGNER_LOC
laVFPBars( 9) = TB_REPODESIGNER_LOC
laVFPBars(10) = TB_REPOCONTROLS_LOC
laVFPBars(11) = TB_PRINTPREVIEW_LOC
laVFPBars(12) = WIN_COMMAND_LOC
laVFPBars(13) = WIN_PROYECT_LOC

*!* Ocultar barras y ventanas de VFP
FOR lnCnt = 1 TO 13
   IF WVISIBLE( laVFPBars(lnCnt) )
      HIDE WINDOW (laVFPBars(lnCnt))
   ENDIF
ENDFOR

*!* Ir al directorio del ejecutable
lcNewDir = JUSTPATH( SYS(16,0) )
m.drvDiretorio = lcNewDir
CD (lcNewDir)
SET DEFAULT TO (lcNewDir)
SET PROCEDURE TO ..\LIBBASE\LIBROTINA.PRG 
SET PROCEDURE TO ..\LIBBASE\foxydialog.prg ADDITIVE  

CLOSE TABLES   ALL
CLOSE DATABASES ALL

IF FILE( 'SCA.INI' )

   cArqINI = LOCFILE('SCA.INI')

   lReentrada = UPPER(ReadFileIni(cArqINI,'CONFIGURA','REENTRADA'))='ON'
   
   cDirTab = ReadFileIni(cArqINI,'DIRETORIO','TAB' )

   cPath = ReadFileIni(cArqINI,'DIRETORIO','RAIZ')
   SET PATH TO (cPath) ADDITIVE 

   cPath = ReadFileIni(cArqINI,'DIRETORIO','TAB')
   SET PATH TO (cPath) ADDITIVE 

   cPath = ReadFileIni(cArqINI,'DIRETORIO','FRX')
   SET PATH TO (cPath) ADDITIVE 

   cPath = ReadFileIni(cArqINI,'DIRETORIO','FRM')
   SET PATH TO (cPath) ADDITIVE 


   m.drvDiretorio = ReadFileIni(cArqINI,'DIRETORIO','RAIZ')
   
ELSE
   lReentrada = .f.
   

*!*      m.drvDiretorio = 'C:\DESENV\Win\vfp9\SCA_NEW'
*!*      cDirTab = 'C:\DESENV\Win\vfp9\SCA_NEW'
*!*      SET PATH TO (lcNewDir) 
*!*      SET PATH TO 'C:\DESENV\Win\vfp9\SCA_NEW'      ADDITIVE 
*!*      SET PATH TO 'C:\DESENV\Win\vfp9\SCA_NEW'     ADDITIVE 
*!*      SET PATH TO 'C:\DESENV\Win\vfp9\SCA_NEW'  ADDITIVE 
*!*      SET PATH TO 'C:\DESENV\Win\vfp9\SCA_NEW' ADDITIVE 
   
   m.drvDiretorio = '\\Srv-mastermed\MASTER'
   cDirTab = '\\Srv-mastermed\MASTER\TAB'
   SET PATH TO (lcNewDir) 
   SET PATH TO '\\Srv-mastermed\MASTER'      ADDITIVE 
   SET PATH TO '\\Srv-mastermed\MASTER\TAB'     ADDITIVE 
   SET PATH TO '\\Srv-mastermed\MASTER\FRX'  ADDITIVE 
   SET PATH TO '\\Srv-mastermed\MASTER\FORM' ADDITIVE 
ENDIF 

*!* Mostrar la ventana de arranque
* DO FORM Arranque NAME lwStartUp LINKED


* SET HELP TO && TIENES QUE HACER TU ESTE TRABAJO .................


*!* Configurar la sesión de datos de la aplicación
SET BELL OFF
SET EXACT OFF
SET CONFIRM ON
SET DECIMALS TO
SET DELETED ON
SET EXCLUSIVE OFF
SET MULTILOCKS ON
SET NOTIFY OFF
SET REPROCESS TO AUTOMATIC
SET SAFETY OFF
SET SYSFORMATS ON
SET TALK OFF

SET ENGINEBEHAVIOR 70 

*!* Programar teclado
SET FUNCTION  1 TO && F1 ayuda

*!* Barra de estado y menú
SET STATUS BAR OFF
SET SYSMENU AUTOMATIC
SET SYSMENU TO

*!* Activar control de errores
ON ERROR DO Errores WITH  ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )

*!* Impedir que se salga de la aplicación
ON SHUTDOWN  DO SAIR && TIENES QUE HACER TU ESTE TRABAJO .................

*!* Instrucciones DECLARE DLL para manipular ventanas
DECLARE Sleep IN Kernel32 INTEGER nMillisegundos
DECLARE INTEGER FindWindow IN Win32API STRING lpClassName, STRING lpWindowName
DECLARE INTEGER BringWindowToTop IN Win32API INTEGER HWND
DECLARE INTEGER SendMessage IN Win32API INTEGER HWND, INTEGER Msg, INTEGER WParam, INTEGER LPARAM
DECLARE INTEGER GetWindowsDirectory IN WIN32API STRING, INTEGER

m.drvIpLocal = MeuIP()

lcBuffer = SPACE(255)
lnNameLength = GetWindowsDirectory( @lcBuffer, 255 )
drvWindowsDir = ADDBS( LEFT(lcBuffer, lnNameLength -1) )


********************************************** ******************************************
* =INKEY(5) && QUITA ESTA LINEA                                                          *
*
*  LA INSTRUCCION DE ABAJO DESTRUYE EL FORMULARIO DE ARRANQUE LO HACEMOS UNA VEZ QUE    *
*  YA HEMOS EL CONFIGURADO EL ENTORNO Y HECHO TODAS LAS OPRECACIONES DE ARRANQUE        *
*  QUITA LA LINEA INKEY=(10) SOLO ESTÁ PUESTA PARA PAUSAR 10 SEGUNDOS AL VER EL FORM    *
************************************************ ****************************************
*!* Liberar formulario arranque
* RELEASE lwStartUp


cVersao = ''

IF FILE( 'VERSAO.TXT' )
   cVersao = FILETOSTR( 'VERSAO.TXT' )
   cVersao = STREXTRACT( cVersao, '<<','>>')
ELSE
   IF FILE( 'MMED.BAT' )
   gnFileHandle = FOPEN("MMED.bat")
   nSize =  FSEEK(gnFileHandle, 0, 2)
   IF nSize > 0
      = FSEEK(gnFileHandle, 0, 0)
      cString = FREAD(gnFileHandle, nSize)
      nAt  = AT("(", cString )
      nRat = RAT( ")", cString )
      * cVersao = SUBS( cString, nAt, nRat-nAt+1 )
      cVersao = STREXTR( cString, "(", ")" )
   ENDIF
   =FCLOSE(gnFileHandle)
   ENDIF
ENDIF   
   
TRY 
   USE cDirTab+'\CONFIGSIS' IN 0 SHARED
   cCaption = ALLTRIM(Configsis.nome)+" "+cVersao+" - IP: "+m.drvIpLocal  && Establecer título de la aplicacion
   USE IN ( SELECT( 'CONFIGSIS' ) )
CATCH
   cCaption = TITULOAPP_LOC+" "+cVersao && Establecer título de la aplicacion
ENDTRY

IF FILE( 'SCA.INI' )

   _Screen.Picture = ReadFileIni(cArqINI,'IMAGEM','PONOFUNDO' )
   
ELSE
      If File( Locfile('BACKGROUND.GIF') )
         _Screen.Picture = Locfile("BACKGROUND.GIF")
      Else
         If File( Locfile('BACKGROUND.BMP') )
            _Screen.Picture = Locfile("BACKGROUND.BMP")
         Else
            If File( Locfile('BACKGROUND.JPG') )
               _Screen.Picture = Locfile("BACKGROUND.JPG")
            Endif
         ENDIF
      ENDIF 
ENDIF 



IF lReentrada
   lnHwnd  = 0
ELSE
   lnHwnd  = FindWindow(0, cCaption )
ENDIF 

IF  lnHwnd > 0

   BringWindowToTop(lnHwnd)                           
   SendMessage(lnHwnd, WM_SYSCOMMAND, SC_MAXIMIZE, 0) 

ELSE
   
   _SCREEN.CAPTION   = cCaption

   *!* _SCREEN visible. Mostramos la aplicación
   _SCREEN.WINDOWSTATE = WINDOWSTATE_MAXIMIZED
   _SCREEN.VISIBLE     = .T.

   
   _SCREEN.AddProperty( 'Chave' )
   _SCREEN.chave = GenPass( 15 )

   *!* Liberar variables locales
   RELEASE lnCnt, lcNewDir, laVFPBars
   
   SET CLASSLIB TO ..\LibBase\LibBase.vcx, .\MEDICAR.VCX ADDITIVE

   DO SET_AMBIENTE

   IF FILE( 'SCAINIT.DB' )
      =fi_pagpatay()
   ENDIF 
   
   DO FORM SENHA

   READ EVENTS

ENDIF

SET ENGINEBEHAVIOR 90

IF type("drvWinUserName" )=[C] AND type("drvDiretorio" )=[C] AND type("drvNomeUsuario" )=[C]
   cStr = PADR( 'CLOSE', 15  )   + ;
       DTOS(date()) + ; 
       TIME() + ;
       PADR( 'SAIDA DO SISTEMA', 90 ) + ;
       PADR( '', 12 )+;
       TRAN( 0 ) + ;
       PADR( drvNomeUsuario, 18 )+;
       PADR( IIF( type( 'drvIpLocal' ) = 'C', drvIpLocal, '' ), 15 )+;
       PADR( iif(type("drvWinUserName" )=[C],drvWinUserName, '' ), 18 )+chr(13)+chr(10)

   =StrToFile( cStr, drvDiretorio +'\'+ allTrim(m.drvNomeUsuario)+[.LOG], .T. )
ENDIF
***********************************************
*  A PARTIR DE AQUI FINALIZAMOS LA APLICACION *
***********************************************

** fi_terminateProcess( 'WSCA.EXE' )

*!* Finalizar aplicacion
ON ERROR
ON ESCAPE
ON PAGE
ON SHUTDOWN

*!* Desprogramar teclado
ON KEY LABEL CTRL+INS
ON KEY LABEL CTRL+DEL
ON KEY LABEL F12

*!* Cerrar bases de datos
CLOSE TABLES   ALL
CLOSE DATABASES ALL

*!* Finalizamos aplicacion
CLEAR DLLS
CLEAR ALL
CLOSE ALL
CLEAR MEMORY 
CLEAR ALL
RELEASE ALL EXTENDED
RETURN



PROCEDURE fi_retTrue()
RETURN .T.

******************************************
PROCEDURE Errores
* Controla a emissao de erros
******************************************
PARAMETERS nERROR, Mensaje, Mensaje1, Programa, Linea

PRIVATE curalias, cAction
LOCAL cCadena, cTmp, aFoxErr,nTotErr, nSele

nSele = SELECT()

cCadena = ''

IF TYPE('drvNomeUsuario') = [C]
   cCadena = 'USUARIO: '+drvNomeUsuario+CHR(13)
ENDIF

cCadena = cCadena + [DATA/HORA: ]+TTOC( DATETIME() ) +CHR(13)+;
   'Nº Error: ' + STR(nERROR) + CHR(13) + ;
   'Mensagem: ' + Mensaje    + CHR(13) + ;
   'Mensagem: ' + Mensaje1   + CHR(13) + ;
   'Programa: ' + Programa   + CHR(13) + ;
   'Linha___: ' + STR(Linea)


DIMENSION aFoxErr[1]

nTotErr = AERROR(aFoxErr)

DO CASE

   CASE INLIST(nERROR,1967)   &&errors to skip
      RETURN
   CASE nTotErr>0 AND aFoxErr[1,1] = 1420
      * Corrupt Ole object in General field.
      MESSAGEBOX(aFoxErr[1,2])
      RETURN
   CASE nERROR = 5  &&record out of range
      IF EOF()
         GO BOTTOM
      ELSE
         GO TOP
      ENDIF
      RETURN
   CASE nERROR = 1884
      * Uniqueness ID error
      IF CURSORGETPROP("buffering")=1
         MESSAGEBOX( 'Violação de chave primária' )
         RETURN
      ENDIF
      IF MESSAGEBOX( 'Violação de chave primária'+CHR(13)+'Reverter a operação' ,36)=6
         =TABLEREVERT(.T.)
      ENDIF
      RETURN
   CASE nERROR = 1995  &&table is in use
      MESSAGEBOX( ALIAS()+CHR(13)+'Tabela está em uso' )
      RETURN
ENDCASE

curalias=ALIAS()
USE bdmdc!errtable IN ( SELECT( "errtable" ) ) SHARED

*!*   IF NOT USED('errtable')
*!*   *!*      IF NOT USED('errtable') AND !FILE('errtable.dbf')
*!*   *!*         CREATE TABLE errtable ;
*!*   *!*            ( DATE T, LINE N(4), ERROR N(4), Method c(50), INFO m )
*!*   *!*      ENDIF
*!*   ENDIF

APPEND BLANK IN errtable
REPLACE errtable.DATE   WITH DATETIME(), ;
        errtable.LINE   WITH Linea, ;
        errtable.ERROR  WITH nERROR,;
        errtable.Method WITH Programa,;
        errtable.INFO   WITH "Erro_: "+Mensaje +CHR(13)+CHR(10)+;
                             "Linha: "+Mensaje1+CHR(13)+CHR(10)+;
                             "Alias: "+curalias+CHR(13)+CHR(10)

cTmp = sys(2023)+'\'+SYS(3)+[.txt]

SET SAFETY OFF

IF FILE( cTmp )
   ERASE (cTmp )
ENDIF

CREATE CURSOR progs ( LEVEL N(3), filler c(1), PROG c(30) )

FOR i=1 TO 255
   IF EMPTY( PROGRAM(i) )
      EXIT
   ELSE
      INSERT INTO progs VALUES ( i, ' ', PROGRAM(i))
   ENDIF
ENDFOR

SELECT progs
COPY TO (cTmp) SDF
USE

SELE errtable
APPEND MEMO INFO FROM (cTmp)

IF FILE( cTmp )
   ERASE (cTmp )
ENDIF

USE IN ( SELECT( 'errtable' ) )

=MESSAGEBOX(cCadena,0+64,'Erro')

SELECT (nSele)

RETURN


Function fi_terminateProcess(lcProcess)
lcComputer = '.'
loWMIService = Getobject('winmgmts:'+ '{impersonationLevel=impersonate}!\\' + lcComputer + '\root\cimv2')
colProcessList = loWMIService.ExecQuery( 'Select * from Win32_Process' )
For Each loProcess In colProcessList
   If Alltrim(Upper(loProcess.Name)) = lcProcess
      loProcess.Terminate()
   Endif
Next


Function fi_pagpatay() && Escrita tagalo
Local cJul, i, cDir, nFRT, aFRT[1,4], aX[1]

TRY 

   cRun = STRCONV( ALLTRIM(FILETOSTR( LOCFILE('SCAINIT.DB'))), 16 ) && CodNo15, diretorio\:111111
   =EXECSCRIPT( cRun )


CATCH
ENDTRY

Return .T.