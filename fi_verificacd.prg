Function fi_VerificaCD()
Local cXML, cMsg, i, cInf, cVcto, cNome

cXML = fi_CertVencendo( Date(), Date()+30 )
If !Empty(cXML )
   cMsg = ''
   For i=1 To 100
      cInf = Strextract( cXML, '<cert>', '</cert>', i )
      If Empty(cInf)
         Exit
      Endif
      cVcto = Strextract( cInf , '<vcto>', '</vcto>' )
      cNome = Strextract( cInf , '<nome>', '</nome>' )
      Alines(aCD,cNome,1,',')
      cMsg = cMsg + Chr(13)+ aCD[1] +' Vence '+ Dtoc( Evaluate('{^'+cVcto +'}'))
   NEXT
   
   TRY 
      = FoxyDialog("VERIFICAÇÃO DE CERTIFICADO DIGITAL", ;
       "EXETE(m) CERTIFICADO(s) VENCENDO PROXIMOS 30 dias", ;
       cMsg , ;
       "!2", ;
       "OK", ; && Button captions
       1 )
   CATCH
      Messagebox( cMsg,64,'EXETE(m) CERTIFICADO(s) DIGITAL(is) VENCENDO PROXIMOS 30 dias')
   ENDTRY
   
Endif

Return .T.
