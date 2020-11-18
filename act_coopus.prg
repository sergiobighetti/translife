Close Databases All
Close Tables All

Clear
?
? 'Acerto de pagina de codigo da coopus...' &&--- teste git
?

cDBF = Getfile('DBF')

If !Empty(cDBF)

   lOK = .T.
   Try
      Use (cDBF)
      Use
   Catch
      lOK = .F.
      Messagebox( 'Falha na abertura de '+cArq, 16, 'Atenção' )
   Endtry

   If lOK
      Do "C:\Program Files (x86)\Microsoft Visual FoxPro 9\Tools\Cpzero\cpZero" With cDBF, 850

      Use (cDBF)
      Scan All
         ?? [.]

         Replace Nome     With semacento( Upper(Strtran(Nome,   '¦','A')) )
         Replace endereco With semacento(Upper(Strtran(endereco,'¦','A')) )
         Replace bairro   With semacento(Upper(Strtran(bairro,  '¦','A')) )
         Replace cidade   With semacento(Upper(Strtran(cidade,  '¦','A')) )
      ENDSCAN

      MESSAGEBOX( 'Processo terminado',64,'Final', 3000 )
      BROW

   Endif

   Close Databases All
   Close Tables All

Endif
