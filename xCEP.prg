CLEAR
SET ESCAPE ON 

Select Distinct CEP From ASSOCIADO Where !Empty(Left(CEP,1)) Into Cursor LV_CEP

clear
srvXMLHttp = Createobject("MSXML2.ServerXMLHTTP.4.0")
nX = 0
Scan FOR RECNO() <= 20

   cCep = Chrtran( LV_CEP.CEP, '-. ', '' )
   If Len(cCep) = 8

      nX = nX + 1
      srvXMLHttp.Open("GET","http://correiosapi.apphb.com/cep/"+ cCep,.F.)
      srvXMLHttp.Send()
      cStr = srvXMLHttp.ResponseText
      _ClipText = cStr
      ? STRCONV( cStr,1,1046)

      cStr = Upper(Chrtran( cStr, '{}', '' ))
      nTot=Alines( aXXX, cStr, 1, ',' )

      If nTot > 3
         ?  'Tipo: '+ Chrtran( Strextract( aXXX[6], ':', '' ), '"', '' )
         ?? ' Endereco: '+Chrtran( Strextract( aXXX[5], ':', '' ), '"', '' )
         ?? ' - Barro: '+Chrtran( Strextract( aXXX[1], ':', '' ), '"', '' )
         ?? ' - Cidade:'+Chrtran( Strextract( aXXX[3], ':', '' ), '"', '' )
         ?? '/'+Chrtran( Strextract( aXXX[4], ':', '' ), '"', '' )
         ?? ' CEP: '+Chrtran( Strextract( aXXX[2], ':', '' ), '"', '' )
      ELSE
         ? cCep + ' não encontrado'
      Endif
   Endif
Endscan
