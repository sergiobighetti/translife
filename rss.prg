#Define MAILITEM         0
#Define IMPORTANCELOW    0
#Define IMPORTANCENORMAL 1
#Define IMPORTANCEHIGH   2

*LPARAMETERS cArqCT, cCT

LOCAL oOutLook, oEmailItem, cMsg, cArqBL, cArqIV 

cArqCT = 'C:\Desenv\Win\vfp9\maintemp.ini'
cArqBL = 'C:\Desenv\Win\vfp9\xxx.DBF'
cArqIV = 'C:\Desenv\Win\vfp9\slf_help.hlp'
SET STEP ON     
oOutLook   = Createobject("Outlook.Application")
oEmailItem = oOutLook.CreateItem(MAILITEM)
oEmailItem.Display()


With oEmailItem

   .to         = 'para@quevai.com.br'
   .cc         = 'com@copia.com.br'
   .Subject    = "Permissão para emissão do CT Nº "+'cCT'
   .Importance = IMPORTANCENORMAL
   
   TEXT TO cCorpo TEXTMERGE NOSHOW
INVICE Nº: <<'Thisform.txtINVOICE_Numero.Value'>>
<<'Thisform.edtConteudo.Value'>>

B.L. Nº: <<'Thisform.txtBL_Numero.Value'>> de <<'Thisform.txtBL_Data.Value'>>
   ENDTEXT 
   .Body       = cCorpo 
   
   .Attachments.Add( ALLTRIM(cArqIV  ) ) && adiciona o INVOICE
   .Attachments.Add( ALLTRIM( cArqBL ) ) && adiciona o BL
   .Attachments.Add( ALLTRIM( cArqCT ) ) && adiciona o BL
   
   
   && .Send
Endwith

Release oEmailItem
Release oOutLook
