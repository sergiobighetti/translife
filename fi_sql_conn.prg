Function fi_sql_conn( lComChamada )
*-- inicialização as conexoes com bancos de dados
Local cIni, cConn, cMsg

If Pcount() = 0
   lComChamada =.F.
Endif

If Occurs( 'LIBROTINA.PRG', Upper(Set("Procedure")) ) = 0
   Set Procedure To c:\desenv\win\vfp9\libBase\libRotina.PRG Additive
Endif

If Not Pemstatus( _Screen, 'hConn', 5 )
   _Screen.oApp.AddProperty( 'hConn', 0 )
Endif

If File( 'MEDILAR.INI' )

   cIni = Locfile( 'MEDILAR.INI' )

   *-- le as informações de conexado
   cConn = ReadFileIni( cIni, 'SAF', 'CONEXAO' )
   *-- decondifica a informação de conexao
   cConn = Strconv( cConn, 14 )
   If _Screen.hConn> 0  &&-- se esta conectado MICROSIGA
      Try
         =SQLDisconnect( _Screen.hConn) &&--- desconecta
      Catch
      Endtry
   Endif
   *-- cria a conexao 
   _Screen.hConn= Sqlstringconnect(cConn)


Endif

cMsg = ''
If _Screen.hConn <= 0
   cMsg = cMsg + Chr(13)+ 'Folhou ao conectar banco SQL'
Endif

cMsg = Substr(cMsg,2)
Return cMsg
