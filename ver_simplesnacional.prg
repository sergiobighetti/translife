FUNCTION ver_SIMPLESNACIONAL( cCnpj )
LOCAL oInf AS 'EMPTY'
LOCAL srvXMLHttp AS "MSXML2.ServerXMLHTTP.4.0"
LOCAL cPass, cRet, cUrl, cUsr, cXML

cCnpj = ALLTRIM(CHRTRAN(cCnpj, '.,;:~^[]{}-_)(*&¨%$#@!"/\| ', '' ))

IF LEN(cCnpj) <> 14
   cRet = 'CNPJ inválido'

ELSE

   cUsr  = 'diegoraphael'
   cPass = 'medicar1q2w3e'

   oInf = CREATEOBJECT('EMPTY')
   ADDPROPERTY( oInf, 'CodErro',              '' )
   ADDPROPERTY( oInf, 'MensagemErro',         '' )
   ADDPROPERTY( oInf, 'Cnpj',                 '' )
   ADDPROPERTY( oInf, 'NomeEmpresarial',      '' )
   ADDPROPERTY( oInf, 'OpcaoSimplesNacional', '' )
   ADDPROPERTY( oInf, 'OpcaoSIMEI',           '' )

   TEXT TO cUrl TEXTMERGE NOSHOW
http://ws.fontededados.com.br/consulta.asmx/SimplesNacional?login=<<cUsr>>&senha=<<cPass>>&cnpj=<<cCnpj>>
   ENDTEXT


   TRY

      WAIT WINDOW 'Verificando '+ cCnpj +' ... aguarde ' NOWAIT NOCLEAR
      srvXMLHttp = CREATEOBJECT("MSXML2.ServerXMLHTTP.4.0")
      srvXMLHttp.OPEN("GET",cUrl ,.F.)

      srvXMLHttp.SEND()
      cXML = srvXMLHttp.responseText

   CATCH
      cXML= '<CodErro>-900</CodErro><MensagemErro>Falha na verificação da consulta ... aguarde alguns minutos e tente novamente</MensagemErro>'
   ENDTRY

   srvXMLHttp = NULL
   WAIT CLEAR

   oInf.CodErro  =STREXTRACT( cXML, '<CodErro>',              '</CodErro>' )

   IF oInf.CodErro='0' && OCCURS( 'RetornoSimplesNacional', cXML ) > 0

      oInf.Cnpj                 =STREXTRACT( cXML, '<Cnpj>',                 '</Cnpj>' )
      oInf.NomeEmpresarial      =STREXTRACT( cXML, '<NomeEmpresarial>',      '</NomeEmpresarial>' )
      oInf.OpcaoSimplesNacional =STREXTRACT( cXML, '<OpcaoSimplesNacional>', '</OpcaoSimplesNacional>' )
      oInf.OpcaoSIMEI           =STREXTRACT( cXML, '<OpcaoSIMEI>',           '</OpcaoSIMEI>' )

      TEXT TO cRet TEXTMERGE NOSHOW
CNPJ...: <<oInf.Cnpj>> Nome: <<oInf.NomeEmpresarial>>
Simples: <<oInf.OpcaoSimplesNacional>>
SIMEI..: <<oInf.OpcaoSIMEI>>
      ENDTEXT


   ELSE
      oInf.MensagemErro  =STREXTRACT( cXML, '<MensagemErro>',         '</MensagemErro>' )
      TEXT TO cRet TEXTMERGE NOSHOW
CodErro: <<oInf.CodErro>>
Descr..: <<ALLTRIM(oInf.MensagemErro)>>
      ENDTEXT
   ENDIF

ENDIF

RETURN cRet
