oX = fi_GertProtocolo( 5282 )

SET STEP ON 
? oX

FUNCTION fi_GertProtocolo( nProt )
LOCAL cUrl, lResult, oRet, lcLocalFile 

cUrl = "http://ias2.epharmatecnologia.com.br/sa/sec/XML_OMT_BUSCA_PROT?p_protocolo="+ Transform(nProt)

Declare Integer URLDownloadToFile In urlmon Integer, String, String, Integer, Integer
Declare Integer DeleteUrlCacheEntry In Wininet String

lcLocalFile = Lower(Addbs(Sys(2023))+Sys(2015)) && file to save the returned text
DeleteUrlCacheEntry(cUrl)                        && nuke the cached version

lResult = ( URLDownloadToFile(0, cUrl, lcLocalFile, 0x80000000 ,0) = 0 )
Clear Dlls "URLDownloadToFile", "DeleteUrlCacheEntry"

oRet = CREATEOBJECT( 'Empty' )
ADDPROPERTY( oRet, 'mensagem',        '' )
ADDPROPERTY( oRet, 'numero',          '' )
ADDPROPERTY( oRet, 'empresa',         '' )
ADDPROPERTY( oRet, 'datasolicitacao', '' ) && 2009-08-03 15:42:28
ADDPROPERTY( oRet, 'telefoneorigem',  '' )
ADDPROPERTY( oRet, 'solicitante',     '' )
ADDPROPERTY( oRet, 'codigoplano',     '' )
ADDPROPERTY( oRet, 'servico',         '' )
ADDPROPERTY( oRet, 'identificador',   '' )
ADDPROPERTY( oRet, 'nome',            '' )
ADDPROPERTY( oRet, 'sexo',            '' )
ADDPROPERTY( oRet, 'datanascimento',  '' ) && 1977-07-10
ADDPROPERTY( oRet, 'telefone1',       '' )
ADDPROPERTY( oRet, 'telefone2',       '' )
ADDPROPERTY( oRet, 'codigodaqueixa',  '' )

IF lResult 
   cXml = Filetostr(lcLocalFile)
   oRet.mensagem        = STREXTRACT( cXml, '<mensagem>',        '</mensagem>') 
   oRet.numero          = STREXTRACT( cXml, '<numero>',          '</numero>') 
   oRet.empresa         = STREXTRACT( cXml, '<empresa>',         '</empresa>') 
   oRet.datasolicitacao = STREXTRACT( cXml, '<datasolicitacao>', '</datasolicitacao>') 
   oRet.telefoneorigem  = STREXTRACT( cXml, '<telefoneorigem>',  '</telefoneorigem>') 
   oRet.solicitante     = STREXTRACT( cXml, '<solicitante>',     '</solicitante>') 
   oRet.codigoplano     = STREXTRACT( cXml, '<codigoplano>',     '</codigoplano>') 
   oRet.servico         = STREXTRACT( cXml, '<servico>',         '</servico>') 
   oRet.identificador   = STREXTRACT( cXml, '<identificador>',   '</identificador>') 
   oRet.nome            = STREXTRACT( cXml, '<nome>',            '</nome>') 
   oRet.sexo            = STREXTRACT( cXml, '<sexo>',            '</sexo>') 
   oRet.datanascimento  = STREXTRACT( cXml, '<datanascimento>',  '</datanascimento>') 
   oRet.telefone1       = STREXTRACT( cXml, '<telefone1>',       '</telefone1>') 
   oRet.telefone2       = STREXTRACT( cXml, '<telefone2>',       '</telefone2>') 
   oRet.codigodaqueixa  = STREXTRACT( cXml, '<codigodaqueixa>',  '</codigodaqueixa>')
ENDIF 

RETURN oRet


** http://ias2.epharmatecnologia.com.br/sa/sec/XML_OMT_RETORNA_PROT?p_protocolo=5279&p_conduta=teste&p_queixa=Teste de Queixa&p_cid=23222
clear
oX = fi_PutProtocolo( '5282', 'QX_DOR DE CABEÇA', 'ANALGESICO', '12121' )
SET STEP ON 
? oX.mensagem
? oX.numero


FUNCTION fi_PutProtocolo
LPARAMETERS cProt, cQueixa, cConduta, cCid
LOCAL cUrl


cProt    = IIF( varTYPE('cProt')    ='C', cProt,    '' )
cQueixa  = IIF( varTYPE('cQueixa')  ='C', cQueixa,  '' )
cConduta = IIF( varTYPE('cConduta') ='C', cConduta, '' )
cCid     = IIF( varTYPE('cCid')     ='C', cCid,     '' )

SET TEXTMERGE TO MEMVAR cUrl NOSHOW
SET TEXTMERGE ON
\\http://ias2.epharmatecnologia.com.br/sa/sec/XML_OMT_RETORNA_PROT?p_protocolo=<<cProt>>
\\&p_queixa=<<cQueixa>>
\\&p_conduta=<<cConduta>>
\\&p_cid=<<cCid>>
SET TEXTMERGE OFF
SET TEXTMERGE TO

SET STEP ON 
Declare Integer URLDownloadToFile In urlmon Integer, String, String, Integer, Integer
Declare Integer DeleteUrlCacheEntry In Wininet String
lcLocalFile = Lower(Addbs(Sys(2023))+Sys(2015)) && file to save the returned text
DeleteUrlCacheEntry(cUrl)                        && nuke the cached version
lResult = ( URLDownloadToFile(0, cUrl, lcLocalFile, 0x80000000 ,0) = 0 )
Clear Dlls "URLDownloadToFile", "DeleteUrlCacheEntry"

oRet = CREATEOBJECT( 'Empty' )
ADDPROPERTY( oRet, 'mensagem', '' )
ADDPROPERTY( oRet, 'numero',   '' )

IF lResult 
   cXml = Filetostr(lcLocalFile)
   oRet.mensagem = STREXTRACT( cXml , '<mensagem>', '</mensagem>' ) 
   oRet.numero   = STREXTRACT( cXml , '<numero>',   '</numero>'   ) 
ENDIF    

RETURN oRet


