Close Databases All
Close Tables All
Set Exclusive Off
CLEAR

USE \\dcrpo\bdmdc$\CONTRATO_NFSe IN 0

cArqXLS   = Getfile('XLS','PLANILHA','Abrir',0,'Informa a planilha')

If Empty(cArqXLS) Or Empty(cArqXLS)
   Return
Endif

oXls = Createobject( 'Excel.Application' )
oXls.Workbooks.Open( cArqXLS )
oXls.DisplayAlerts = .F.
oXls.Visible = .F.

For i=2 To 650000

   If Empty(oXls.Cells(i,1).Text)
      Exit
   Endif

   nIdC = Int(oXls.Cells(i,2).Value)

   If Not Seek( nIdC, 'CONTRATO_NFSe', 'IDCONTRATO' )
      ?? [i]
      Select CONTRATO_NFSe
      Append Blank
      Replace idcontrato With nIdC
   Else
      ?? [.]
   Endif

   Replace email        With ALLTRIM(oXls.Cells(i,11).text)
   Replace End          With CHRTRAN(ALLTRIM(oXls.Cells(i,4).text),',',' ')
   Replace nro          With oXls.Cells(i,5).text
   Replace complemento  With oXls.Cells(i,6).text
   Replace bairro       With oXls.Cells(i,7).text
   Replace cid          With oXls.Cells(i,8).text
   Replace uf           With oXls.Cells(i,9).text
   Replace cep          With oXls.Cells(i,10).text
   Replace fone         With oXls.Cells(i,12).text


Endfor

oXls.Quit
oXls = Null
