Set Talk Off
Set Escape On

Clear
Cd "C:\DLL_NFSe_v1.3d\v1.3d"

obj = Createobject("NFSe_Util.Util")

cLoteRPSTXT   = Filetostr( 'c:\testeRPS.txt' )


cNroLote      = '2'
cCertificado  = ''
cMunicipio    = '3543402'
cResultado    = 0
cMsgResultado = ''
cErros        = ''
cLicenca      = '07234f897c5513c18f8698402fd1164758b475d85ba2906e080277542fec083f96480d166063a0e975c5d29ec592516e220b629ca49f74035542df5740b789a3'


*--- CAPITURA O NOME DO CERTIFICADO
obj.PegaNomeCertificado( @cCertificado, @cMsgResultado )

cLoteRPSXML   = obj.geraLoteRPS( @cLoteRPSTXT, @cNroLote, @cCertificado, @cMunicipio, @cResultado, @cMsgResultado, @cErros, @cLicenca)


=Strtofile( cLoteRPSXML, 'C:\tst.xml' )
* cLoteRPSXML = FILETOSTR( 'C:\TST.XML' )


TEXT TO cTXT TEXTMERGE
     cNroLote <<cNroLote>>
 cCertificado <<cCertificado>>
   cMunicipio <<cMunicipio>>
   cResultado <<cResultado>>
cMsgResultado <<cMsgResultado>>
       cErros <<cErros>>
     cLicenca <<cLicenca>>
ENDTEXT

? cTxt

*!*   * valida XML
*!*   cMsgResultado = ''
*!*   qtdeErros = 0
*!*   erroXML = ''
*!*   ?
*!*   ? 'ValidaXML'
*!*   obj.ValidaXML( @cLoteRPSXML;
*!*                , @cMunicipio;
*!*                , @cMsgResultado;
*!*                , @qtdeErros;
*!*                , @erroXML )
*!*
*!*   ? 'cMsgResultado: '+ cMsgResultado
*!*   ? 'qtdeErros: '+ TRANSFORM(qtdeErros)
*!*   ? 'erroXML: '+ erroXML


*!*   cMsgResultado        = ''
*!*   cResultado           = 0
*!*   atr = ""
*!*   cTag = 'LoteRps'
*!*   ? obj.Assinar(@cLoteRPSXML, @cTag , @atr, @cCertificado, @cResultado, @cMsgResultado)

Clear
?
? cResultado
? cMsgResultado






nTpAmb               = 2 && 1.Producao 2.Homolocação
cVersao              = ''
cMsgDados            = cLoteRPSXML
cResultado           = 0
cMsgResultado        = ''
CNPJPrestador        = '68322411000137'
numeroLote           = ''
cDataRec             = ''
cProtocolo           = ''
cLstMsgRet           = ''
cProxy               = ''
cUsr                 = ''
cSenha               = ''

cRet = ''
SET STEP ON 
cRet = obj.EnviaLoteRPS( @cMunicipio    ; &&
,@cCertificado  ; &&
,@nTpAmb        ; &&
,@cVersao       ; &&
,@cMsgDados     ; &&
,@cResultado    ; &&
,@cMsgResultado ; &&
,@CNPJPrestador ; &&
,@cNroLote      ; &&
,@cDataRec      ; &&
,@cProtocolo    ; &&
,@cLstMsgRet    ; &&
,@cProxy        ; &&
,@cUsr          ; &&
,@cSenha        ; &&
,@cLicenca      )

?
?
?

TEXT TO cTXT TEXTMERGE
   @cMunicipio    ; && <<cMunicipio>>
  ,@cCertificado  ; && <<cCertificado>>
  ,@nTpAmb        ; && <<nTpAmb>>
  ,@cVersao       ; && <<cVersao>>
  ,@cMsgDados     ; && <<cMsgDados>>
  ,@cResultado    ; && <<cResultado>>
  ,@cMsgResultado ; && <<cMsgResultado>>
  ,@CNPJPrestador ; && <<CNPJPrestador>>
  ,@cNroLote      ; && <<cNroLote>>
  ,@cDataRec      ; && <<cDataRec>>
  ,@cProtocolo    ; && <<cProtocolo>>
  ,@cLstMsgRet    ; && <<cLstMsgRet>>
  ,@cProxy        ; && <<cProxy>>
  ,@cUsr          ; && <<cUsr>>
  ,@cSenha        ; && <<cSenha>>
  ,@cLicenca      ; && <<cLicenca>>
ENDTEXT
? cTxt

_Cliptext = cLstMsgRet









******************
Local  lcMunicipio,lcNomeCertificado,lcTipoAmb,lcMsgDados,;
   lcMsgRetWs,lcMsgRetDll,lcCNPJPrestador,lcIMPrestador,lcProtocolo,;
   lcProxy,lcUsuario,lcSenha,lcLicenca,lcResultado,lcNumeroRPS,;
   lcSerieRPS,lcTipoRPS,lcCaminho,lcArquivo,lcRand


lcMunicipio       = cMunicipio
lcTipoAmb         = 2
lcNomeCertificado = cCertificado
lcMsgDados        = ''
lcMsgRetWs        = ''
lcMsgRetDll       = ''
lcProxy           = ''
lcUsuario         = ''
lcSenha           = ''
lcLicenca         = cLicenca
lcCNPJPrestador   = CNPJPrestador
lcIMPrestador     = '7411101'
lcProtocolo       = ''
cSituacao= ''
listaMensagemRetorno=''
lcProtocolo = cProtocolo

** CONSULTA SITUACAO DO LOTE ENVIADO E GUARDA AS INFORMAÇÕES NO ARQUIVO DE
** LOTES ENVIADOS
lcMsgDados        = ''
lcMsgRetWs        = 0
lcMsgRetDll       = ''

lcResultado = obj.ConsultaSituacaoLoteRPS( @cMunicipio,@cCertificado,lcTipoAmb,@cVersao,;
   @cMsgDados,@lcMsgRetWs,@lcMsgRetDll,;
   CNPJPrestador,lcIMPrestador,cProtocolo,;
   @cNroLote,@cSituacao, @listaMensagemRetorno, ;
   cProxy,cUsr,cSenha,cLicenca)



If cSituacao $ '1234'
   Local lcSituacao

   Do Case
      Case cSituacao = '1' && não Recebido
         Messagebox('Lote não recebido, veirifique ')
      Case cSituacao = '2' && não processado
         Messagebox('Lote não processado ainda ')
      Case cSituacao = '3' && Processado com erro
         Messagebox('Lote processado com erros ')
      Case cSituacao = '4' && Processado com Sucesso
         Messagebox('Lote processado, nota fiscal gerada com sucesso ')
   Endcase



Endif


   cMsgDados=''
   cResultado=0
   msgResultado=''
   listaMensagemRetorno=''


   lcResultado = obj.ConsultaLoteRPS(@cMunicipio,@cCertificado,lcTipoAmb,@cVersao,;
      @cMsgDados,@cResultado,@msgResultado,;
      CNPJPrestador,lcIMPrestador,cProtocolo,listaMensagemRetorno, ;
      cProxy,cUsr,cSenha,cLicenca)



If !Empty(lcResultado )

   If !Empty( Strextract( lcResultado , '<ListaMensagemRetorno>', '</ListaMensagemRetorno>' ) )

      If !Empty( Strextract( lcResultado , '<ns4:MensagemRetorno>',  '</ns4:MensagemRetorno>' ) )
      
         TEXT TO cMsgErr TEXTMERGE NOSHOW 
 
 Protocolo: << cProtocolo >>
 
    Codigo: << STREXTRACT( lcResultado , '<ns4:Codigo>',    '</ns4:Codigo>'  ,1 ) >>
  Mensagem: << STREXTRACT( lcResultado , '<ns4:Mensagem>',  '</ns4:Mensagem>',1 ) >>
  Correção: << STREXTRACT( lcResultado , '<ns4:Correcao>',  '</ns4:Correcao>',1 ) >>

         ENDTEXT
         
         Messagebox( cMsgErr )
         
      Endif

   Endif

ENDIF 


   Release obj
