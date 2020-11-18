*!*   cToken = fiAlsWS_Token()
*!*   cB64 = fiAlsWS_ATD_TO_B64( 8437 )
*!*   CLEAR
*!*   * ? cToken 
*!*   * ? cB64 
*!*   ? fiAlsWS_EnviaAtd( cToken, cB64  )

Function fiAlsWS_EnviaAtd( cToken, cStrJSON )
Local HTTPRequest, nFlags, nResult  
Local cToken, lcData, cJRet, cUrl, xUrl

cUrl   = "<<cUrl>>/fw001.rule?sys=WAL&tkn=<<cToken>>&b64=<<cStrJSON>>"
cJRet  = ''

IF FILE( 'WSALIAS.INI' )

   &&-- codificada em base64
   xUrl     = ReadFileIni(LOCFILE('WSALIAS.INI'),[WSALIASTI],'url')
   xUrl     = xUrl
   xUrl     = STRCONV(xUrl,14)

   If Type('cToken') <> 'C'
      cToken = fiAlsWS_Token()
   Endif

   IF !EMPTY(cToken)

      declare integer InternetGetConnectedState in WinInet.dll integer @lpdwFlags, integer dwReserved
      nFlags  = 0
      nResult = InternetGetConnectedState(@nFlags, 0)
   
      IF nResult <> 1  && se nao tem internet nao retorna token
         cToken = ''
         cJRet  = 'Falhou! Sem conexao de internet'
         =STRTOFILE( 'WSAliasTI.LOG', TTOC(DATETIME())+': '+cJRET+CHR(13)+"*"+CHR(13) ,1 )
         
      ELSE 

         cUrl = STRTRAN( cUrl, '<<cUrl>>',     xUrl,     1, 1 )
         cUrl = STRTRAN( cUrl, '<<cToken>>',   cToken,   1, 1 )
         cUrl = STRTRAN( cUrl, '<<cStrJSON>>', cStrJSON, 1, 1 )

*!*            HTTPRequest  = Createobject("MSXML2.ServerXMLHTTP.4.0")
*!*            HTTPRequest.Open("GET",cUrl ,.F.)
         
         
         HTTPRequest  = Createobject("WinHttp.WinHttpRequest.5.1")
         HTTPRequest.Open("GET", cUrl, .F.)

         WAIT WINDOW 'Enviando para APP.... aguarde' NOWAIT NOCLEAR 
         Try
            HTTPRequest.Send()
            lOk    = .T.
            cRetWS = Transform( HTTPRequest.Status )
         Catch To oErr
            lOk    = .F.
            cRetWS = 'Falhou! '+ NVL(oErr.Message,'')
         ENDTRY
         WAIT CLEAR

         If lOk
            cJRet  = m.HTTPRequest.Responsetext
            If cRetWS = '200'
               cJRet  = m.HTTPRequest.Responsetext
            ELSE
               cJRet  = 'Falhou! '+STREXTRACT( cJRet, '"MensagemDeErro":"', '",' )   
               =STRTOFILE( 'WSAliasTI.LOG', TTOC(DATETIME())+': '+cJRET+CHR(13)+cUrl+chr(13)+"*"+CHR(13) ,1 )
            ENDIF
         ELSE
            cJRet = cRetWS 
         Endif
         HTTPRequest  = Null
      ENDIF 
      
  ELSE
     cJRet  = 'Falhou! Sem token'
     =STRTOFILE( 'WSAliasTI.LOG', TTOC(DATETIME())+': '+cJRET+CHR(13)+"*"+CHR(13) ,1 )
  ENDIF 
  
ENDIF 

Return cJRet




FUNCTION fiAlsWS_Token()
LOCAL cCliente, nQtdHR, cDe, cAte, cToken, nFlags, nResult 

declare integer InternetGetConnectedState in WinInet.dll integer @lpdwFlags, integer dwReserved
nFlags  = 0
nResult = InternetGetConnectedState(@nFlags, 0)

IF nResult <> 1  && se nao tem internet nao retorna token

   cToken = ''

ELSE 

   IF FILE( 'WSALIAS.INI' )
      cCliente =         ReadFileIni(LOCFILE('WSALIAS.INI'),[WSALIASTI],'Cliente')
      cCliente = STRCONV( cCliente,14 )
      nQtdHR   = INT(VAL(ReadFileIni(LOCFILE('WSALIAS.INI'),[WSALIASTI],'nQtdHrPrecisao')))
   else
      cCliente = 'TESTE'
      nQtdHR   = 12
   ENDIF
   SET DATE BRITISH
   SET HOURS TO 24
   SET CENTURY ON
   tAgora   = DATETIME()
   cDe      = TTOC( tAgora+((nQtdHR*3600)*-1), 1 )
   cAte     = TTOC( tAgora+(nQtdHR*3600), 1 )
   cToken   = cDe+'|'+cCliente+'|'+cAte+'|'+meuIP()
   cToken   = STRCONV(cToken,13)
ENDIF 

return cToken



FUNCTION fiAlsWS_ATD_TO_B64( nIdAtend )
* Retorna o json do atendimento <nIdAtend> para ser enviado para o WS
LOCAL cBairro, cCid, cEnd, cEndAtend, cEndRef, cJson, cNaturezaAtend, cRelatoReg, cUF, oAtd
LOCAL cB64

oAtd = LTAB( 'id='+Transform(nIdAtend), "ATENDIMENTO",, "*" )

cNaturezaAtend = LTAB( 'id='+Transform(oAtd.CodAtendimento), "TIPOATEND",, "filtro" )
cRelatoReg     = semAcento( ALLT(oAtd.regobservacao) )
cRelatoReg     = semAcento( strTran(cRelatoReg,chr(13), '\n' ), .t. )
cEndRef        = semAcento( ALLT(oAtd.pacreferencia) )
cEndRef        = semAcento( strTran(cEndRef,chr(13), '\n' ), .t. )
cEnd           = SEMACENTO(oAtd.pacendereco,.t.)
cCid           = SEMACENTO(oAtd.paccidade,.t.)
cUF            = ''
cBairro        = SEMACENTO(oAtd.pacbairro,.t.)
cEndAtend      = cEnd

If !Empty(cBairro)
   cEndAtend = cEndAtend +', '+ cBairro
Endif
If !Empty(cCid)
   cEndAtend = cEndAtend +', '+ cCid
   If !Empty(cUF)
      cEndAtend = cEndAtend +'-'+ cUF
   Endif
ENDIF

TEXT TO cJson TEXTMERGE NOSHOW
{
"id": "<<oAtd.id>>",
"raio": "30",
"tipo_atendimento": "<<cNaturezaAtend>>",
"reg_classificacao": "<<ALLT(oAtd.regclassificacao)>>",
"paciente_nome": "<<semAcento(oAtd.PacNome,.t.)>>",
"paciente_idade": "<<semAcento(oAtd.PacIdade,.t.)>>",
"paciente_sexo": "<<semAcento(oAtd.PacSexo),.t.)>>",
"paciente_codorigem": "<<semAcento(oAtd.paccodorigem,.t.)>>",
"reg_relato": "<<URLEncode(cRelatoReg,.t.)>>",
"endereco_origem": "<<cEndAtend>>",
"referencia": "<<URLEncode(cEndRef,.t.)>>",
"contratante": "<<semAcento(oAtd.ctrresponsavel,.t.)+', '+semAcento(oAtd.ctrtipo,.t.)>>",
"solicitante": "<<semAcento(oAtd.solNome,.t.)>>",
"solicitante_fone": "<<chrtran( semAcento(oAtd.solFone,.t.), ' ', '' )>>",
"taborigem":"ATENDIMENTO",
"grade_hr": [
{
"tph_id": "35",
"tph_nome": "Saida",
"DataHora": "<<oAtd.tm_saida>>",
"historicoC50": "tm_saida"
},
{
"tph_id": "40",
"tph_nome": "No Local",
"DataHora": "<<oAtd.tm_nloca>>",
"historicoC50": "tm_nloca"
},
{
"tph_id": "41",
"tph_nome": "Saida do Local",
"DataHora": "<<oAtd.tm_sloca>>",
"historicoC50": "tm_sloca"
},
{
"tph_id": "50",
"tph_nome": "No Local (Remocao)",
"DataHora": "<<oAtd.tm_rnloca>>",
"historicoC50": "<<semAcento(oAtd.removidopara,.t.)>>"
},
{
"tph_id": "51",
"tph_nome": "SaiLocal (Remocao)",
"DataHora": "<<oAtd.tm_rsloca>>",
"historicoC50": "<<semAcento(oAtd.removidopara,.t.)>>"
}
]
}
ENDTEXT 

cB64 = STRCONV(cJson,13)

RETURN cB64