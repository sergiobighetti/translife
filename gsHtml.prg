
*=gsHtml()  

&& or  =gsHtml("cHtmlFileName")
**********************************************************
** Form to display HTML files.
**********************************************************
** Author      : Ramani (Subramanian.G)
**               FoxAcc Software / Winners Software
** Type        : Freeware with reservation to Copyrights
** Warranty    : Nothing implied or explicit
**********************************************************
PARAMETERS tFile

PUBLIC oform1

oform1=NEWOBJECT("form1")

IF VARTYPE(cFile) # "U"
   oForm1.cmdFile.Visible = .f.   
   oForm1.cmdExit.Visible = .f.   
   oForm1.oleControl1.Top = 12
   oForm1.oleControl1.LoadDocument([&cFile])
ENDIF

oform1.Show
RETURN
**********************************************************
DEFINE CLASS form1 AS form

   DoCreate = .T.
   Caption = "HtmlForm"
   Name = "Form1"

   ADD OBJECT cmdfile AS commandbutton WITH ;
      Top = 12, ;
      Left = 12, ;
      Height = 27, ;
      Width = 144, ;
      Caption = "Select File", ;
      Name = "cmdFile"

   ADD OBJECT cmdexit AS commandbutton WITH ;
      Top = 12, ;
      Left = 168, ;
      Height = 27, ;
      Width = 84, ;
      Caption = "E\<xit", ;
      Name = "cmdExit"

   ADD OBJECT olecontrol1 AS olecontrol WITH ;
      OLEClass = "DHTMLEdit.DHTMLEdit.1", ;
      Top = 48, ;
      Left = 12, ;
      Height = 192, ;
      Width = 348, ;
      Name = "Olecontrol1"

   PROCEDURE Init
      ThisForm.ReSize()
   ENDPROC

   PROCEDURE Resize
      ThisForm.Olecontrol1.Height = ThisForm.Height - 60
      ThisForm.Olecontrol1.Width = ThisForm.Width - 24
      ThisForm.Olecontrol1.Refresh()
   ENDPROC

   PROCEDURE cmdfile.Click
      LOCAL cFile
      cFile = GETFILE([HTM*])
      IF !EMPTY(cFile)
         THISFORM.oleControl1.LoadDocument([&cFile])
      ENDIF
   ENDPROC

   PROCEDURE cmdexit.Click
      ThisForm.Release()
   ENDPROC

ENDDEFINE
**********************************************************
** EOF
**********************************************************