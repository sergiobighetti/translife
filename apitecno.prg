*!*   CLEAR
*!*   ? DATETIME()
*!*   cToken = apiMdc_Tocken()
*!*   cRetR = apiMdc_ConsultaDadosFatura (cToken  ,'0'  )
*!*   _ClipText = cRetR 
*!*   SET STEP ON 

*!*   cConcl = UPPER(STREXTRACT( cRetR, 'FlConcluido":',','))
*!*   IF cConcl = 'TRUE'
*!*      =STRTOFILE( cRetR,'CTR.json')
*!*      ? 'Ctr.OK'
*!*      cJas  = Filetostr('C:\TEMP\JSON_PAC_1.json')
*!*      cRetR = apiMdc_RegistrarPacientes( cToken ,cJas  )
*!*      cConcl = UPPER(STREXTRACT( cRetR, 'FlConcluido":',','))
*!*       IF cConcl = 'TRUE'
*!*         ? 'Pac.OK'
*!*         =STRTOFILE( cRetR,'PAC.json')
*!*      ELSE
*!*         _ClipText = cRetR
*!*         SET STEP ON 
*!*         ? 'Pac.Erro'
*!*      ENDIF 
*!*   ELSE
*!*      _ClipText = cRetR
*!*      SET STEP ON 
*!*      ? 'Ctr.Erro'
*!*   ENDIF 
*!*   ? DATETIME()






Function apiMdc_ConsultarStatusIntegracaoContrato( cToken, cStrJSON, cPorta )
* Exemplo: ? apiMdc_ConsultarStatusIntegracaoContrato( '{codjson}' )  codjson é o retorno de apiMdc_RegistrarContratos()
Local HTTPRequest As WinHttp.WinHttpRequest
Local cToken, lcData, cJRet, cUrl

cPorta = IIF( TYPE('cPorta') = 'C', cPorta, '4443' )
cUrl   = "https://medicar.irisemergencia.com:"+cPorta+"/api/Integracao/ConsultarStatusIntegracaoContrato?semCompressao=true"

cJRet  = ''
If Type('cToken') <> 'C'
   cToken = apiMdc_Tocken( cPorta )
   _Cliptext = cToken
Endif

m.HTTPRequest = Createobject("WinHttp.WinHttpRequest.5.1")
m.HTTPRequest.Open("POST", cUrl, .F.)
m.HTTPRequest.SetRequestHeader("content-type",    "application/json" )
m.HTTPRequest.SetRequestHeader('Authorization',   "Bearer " +cToken )
m.HTTPRequest.SetRequestHeader('Accept-Encoding', 'gzip, deflate')
m.HTTPRequest.SetRequestHeader('Connection', 'keep-alive')
m.HTTPRequest.SetTimeouts(300000, 300000, 300000, 300000)


lcData ='{"GuidUsuarioIntegracao":"50e03086-22fc-4fba-bf1e-6be039e07256","Contratos":'+ cStrJSON +'}'

Try
   m.HTTPRequest.Send(lcData )
   lOk    = .T.
   cRetWS = Transform( m.HTTPRequest.Status )
Catch To oErr
   lOk    = .F.
   cRetWS = 'Falhou!'
Endtry

If lOk
   cJRet  = m.HTTPRequest.Responsetext
Endif
HTTPRequest  = Null

Return cJRet



Function apiMdc_RegistrarContratos( cToken, cStrJSON, cPorta )
* Exemplo: ? apiMdc_RegistrarContratos( '{codjson}' )
Local HTTPRequest As WinHttp.WinHttpRequest
Local cToken, lcData, cJRet, cUrl

cPorta = IIF( TYPE('cPorta') = 'C', cPorta, '4443' )
cUrl   = "https://medicar.irisemergencia.com:"+cPorta+"/api/Integracao/RegistrarContratos?semCompressao=true"

cJRet  = ''
If Type('cToken') <> 'C'
   cToken = apiMdc_Tocken( cPorta )
Endif

m.HTTPRequest = Createobject("WinHttp.WinHttpRequest.5.1")
m.HTTPRequest.Open("POST", cUrl, .F.)
m.HTTPRequest.SetRequestHeader("content-type",    "application/json" )
m.HTTPRequest.SetRequestHeader('Authorization',   "Bearer " +cToken )
m.HTTPRequest.SetRequestHeader('Accept-Encoding', 'gzip, deflate')
m.HTTPRequest.SetRequestHeader('Connection', 'keep-alive')
m.HTTPRequest.SetTimeouts(300000, 300000, 300000, 300000)


lcData ='{"GuidUsuarioIntegracao":"50e03086-22fc-4fba-bf1e-6be039e07256","Contratos":'+ cStrJSON +'}'


Try
   m.HTTPRequest.Send(lcData )
   lOk    = .T.
   cRetWS = Transform( m.HTTPRequest.Status )
Catch To oErr
   lOk    = .F.
   cRetWS = 'Falhou! '+ NVL(oErr.Message,'')
ENDTRY

If lOk
   cJRet  = m.HTTPRequest.Responsetext
   If cRetWS = '200'
      cJRet  = m.HTTPRequest.Responsetext
   ELSE
      cJRet  = STREXTRACT( cJRet, '"MensagemDeErro":"', '",' )   
   ENDIF
ELSE
   cJRet = cRetWS 
Endif
HTTPRequest  = Null

Return cJRet


Function apiMdc_RegistrarPacientes( cToken, cStrJSON, cPorta )
* Exemplo: ? apiMdc_RegistrarPacientes( '{codjson}' )
Local HTTPRequest As WinHttp.WinHttpRequest
Local cToken, lcData, cJRet, cUrl


cPorta = IIF( TYPE('cPorta') = 'C', cPorta, '4443' )
cUrl   = "https://medicar.irisemergencia.com:"+ cPorta +"/api/Integracao/RegistrarPacientes?semCompressao=true"

cJRet  = ''
If Type('cToken') <> 'C'
   cToken = apiMdc_Tocken( cPorta )
Endif


m.HTTPRequest = Createobject("WinHttp.WinHttpRequest.5.1")
m.HTTPRequest.Open("POST", cUrl, .F.)
m.HTTPRequest.SetRequestHeader("content-type",    "application/json; charset=utf-8" )
m.HTTPRequest.SetRequestHeader('Authorization',   "Bearer " +cToken )
m.HTTPRequest.SetRequestHeader('Accept-Encoding', 'gzip, deflate')
m.HTTPRequest.SetRequestHeader('Connection', 'keep-alive')
m.HTTPRequest.SetTimeouts(300000, 300000, 300000, 300000)

lcData ='{"GuidUsuarioIntegracao":"50e03086-22fc-4fba-bf1e-6be039e07256","Pacientes":'+ cStrJSON +'}'

Try
   m.HTTPRequest.Send(lcData )
   lOk    = .T.
   cRetWS = Transform( m.HTTPRequest.Status )
Catch To oErr
   lOk    = .F.
   cRetWS = 'Falhou! '+ NVL(oErr.Message,'')
Endtry

IF lOk = .f.
   SET STEP ON 
ENDIF    

If lOk
   If cRetWS = '200'
      cJRet  = m.HTTPRequest.Responsetext
   ELSE
      cJRet  = cRetWS
   Endif
Endif
HTTPRequest  = Null

Return cJRet





Function apiMdc_LeConsultaFaturaSimulacao( cJson, cArqSaida )
* Retorna um cursor (cArqSaida) com as informações do jSon
Local i, oReg, cId

Create Cursor (cArqSaida) ;
   ( IdWS i, IdFaturaStatus i, NmSimulacao C(100),  DtInicio C(25),  DtFim C(25), DtVencimentoFatura C(25), ;
   IdContrato i, NmCliente C(100), VlTotal N(12,2), IdCodigoImportacao i )

IF !EMPTY(cJson) AND cJson<> '[]'
   For i=1 To 1000

      cId = Strextract( cJson, '"Id":',             ',',  i )
      If Empty(cId)
         Exit
      Endif
      oReg = Createobject('Empty')
      =AddProperty( oReg, 'IdWS',             Int(Val(Strextract( cJson, '"Id":',             ',',  i ))) )
      =AddProperty( oReg, 'IdFaturaStatus', Int(Val(Strextract( cJson, '"IdFaturaStatus":', ',',  i ))) )
      =AddProperty( oReg, 'NmSimulacao',            Strextract( cJson, '"NmSimulacao":"',   '",', i )   )
      =AddProperty( oReg, 'DtInicio',               Strextract( cJson, '"DtInicio":"',      '",', i )   )
      =AddProperty( oReg, 'DtFim',                  Strextract( cJson, '"DtFim":"',         '",', i )   )
      =AddProperty( oReg, 'DtVencimentoFatura',     Strextract( cJson, '"DtVencimentoFatura":"',   '",', i )   )
      =AddProperty( oReg, 'IdContrato',     Int(Val(Strextract( cJson, '"IdContrato":',             ',',  i ))) )
      =AddProperty( oReg, 'NmCliente',              Strextract( cJson, '"NmCliente":"',   '",', i )   )
      cVlr =  Strextract( cJson, '"VlTotal":',  ',',  i )
      =AddProperty( oReg, 'VlTotal',    Val( Chrtran(cVlr,'.',Set("Point")) ) )
      =AddProperty( oReg, 'IdCodigoImportacao',     Int(Val(Strextract( cJson, '"IdCodigoImportacao":',             '}',  i ))) )

      Insert Into (cArqSaida) From Name oReg
   Next
ENDIF 





Function apiMdc_ConsultaFaturaSimulacao( cToken, cTipo, cDtFecha, cPorta )
* cTipo = 1 (Similacao) ou 2 (Fatura)
* cDtFecha = AAAA-MM-DD
* Exemplo: ? apiMdc_ConsultaFaturaSimulacao( <cToken>, '1', '2019-10-09' )
Local HTTPRequest As WinHttp.WinHttpRequest
Local lcData, cJRet, cUrl

cJRet  = ''

cPorta = IIF( TYPE('cPorta') = 'C', cPorta, '4443' )
cUrl   = "https://medicar.irisemergencia.com:"+cPorta+"/api/Integracao/ConsultaFaturaSimulacao?semCompressao=true"

m.HTTPRequest = Createobject("WinHttp.WinHttpRequest.5.1")
m.HTTPRequest.Open("POST", cUrl, .F.)
m.HTTPRequest.SetRequestHeader("content-type",    "application/json; charset=utf-8" )
m.HTTPRequest.SetRequestHeader('Authorization',   "Bearer " +cToken )
m.HTTPRequest.SetRequestHeader('Accept-Encoding', 'gzip')

*!*   TEXT TO lcData
*!*   {"GuidUsuarioIntegracao":"50e03086-22fc-4fba-bf1e-6be039e07256","IdTipoConsulta":<<cTipo>>,"DtFechamento":"<<cDtFecha>>"}
*!*   ENDTEXT

lcData = '{"GuidUsuarioIntegracao":"50e03086-22fc-4fba-bf1e-6be039e07256","IdTipoConsulta":'+cTipo+',"DtFechamento":"'+cDtFecha+'"}'
m.HTTPRequest.Send(lcData )
cJRet = m.HTTPRequest.Responsetext

If Transform( m.HTTPRequest.Status ) <> '200'
   _ClipText = cJRet 
   cJRet = ''
Endif
m.HTTPRequest  = Null

Return cJRet


Function apiMdc_ConsultaDadosFatura( cToken, cId, cPorta )
* cId = Codigo que esta em cada item do retorno de apiMdc_ConsultaFaturaSimulacao
* Exemplo: ? apiMdc_ConsultaDadosFatura( <cToken>, '1' )
Local HTTPRequest As WinHttp.WinHttpRequest
Local lcData, cJRet, cUrl

cPorta = IIF( TYPE('cPorta') = 'C', cPorta, '4443' )
cUrl   = "https://medicar.irisemergencia.com:"+cPorta+"/api/Integracao/ConsultaDadosFatura?semCompressao=true"
cJRet  = ''

m.HTTPRequest = Createobject("WinHttp.WinHttpRequest.5.1")
m.HTTPRequest.Open("POST", cUrl, .F.)
m.HTTPRequest.SetRequestHeader("content-type",    "application/json; charset=utf-8" )
m.HTTPRequest.SetRequestHeader('Authorization',   "Bearer " +cToken )
m.HTTPRequest.SetRequestHeader('Accept-Encoding', 'gzip')

lcData = '{"GuidUsuarioIntegracao":"50e03086-22fc-4fba-bf1e-6be039e07256","Id":'+cId +'}'
m.HTTPRequest.Send(lcData )
cJRet = m.HTTPRequest.Responsetext

If Transform( m.HTTPRequest.Status ) <> '200'
   _ClipText = cJRet 
   cJRet = ''
Endif
m.HTTPRequest  = Null

Return cJRet




Function apiMdc_Tocken( cPorta )
Local HTTPRequest As WinHttp.WinHttpRequest
Local oJ, cRetWS, cUrl

cPorta = IIF( TYPE('cPorta') = 'C', cPorta, '4443' )
cUrl   = "https://medicar.irisemergencia.com:"+cPorta +"/token"

Set Procedure To C:\desenv\win\vfp9\libbase\qdfoxJSON.prg
JSONStart()

m.HTTPRequest = Createobject("WinHttp.WinHttpRequest.5.1")
m.HTTPRequest.Open("Get", cUrl, .F.)
lcData ='&username=50e03086-22fc-4fba-bf1e-6be039e07256&password=e23TOYn65atd3xb3&grant_type=password'
m.HTTPRequest.Send(lcData )
cToken = ''

If Tran( m.HTTPRequest.Status ) = '200'

   cRetWS =   m.HTTPRequest.Responsetext
   cToken = Strextract( cRetWS , '"access_token":"', '",' )
Endif
HTTPRequest  = Null

Return cToken
