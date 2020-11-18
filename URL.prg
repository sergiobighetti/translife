Declare Long URLDownloadToFile In URLMON.Dll Long, String, String, Long, Long

nProt = 5107

cUrl = "http://ias2.epharmatecnologia.com.br/sa/sec/XML_OMT_BUSCA_PROT?p_protocolo="+ Transform(nProt)
oIE.Navigate(cUrl)


lcFile = 'C:\temp\teste.xml'
lnResult = URLDownloadToFile(0, lcURL, lcFile, 0, 0)
If lnResult <> 0
   Messagebox('Failed')
Endif
