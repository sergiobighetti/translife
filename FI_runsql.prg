&& ////////////////////////////////////////////////////////////////////////
Function FI_SqlRun( nConn As Integer,  cSQL As String, cNomeCursor As Cursor, cMsgWait As String, nTimeOut As Integer )
&& ////////////////////////////////////////////////////////////////////////
&& Executa instrução SQL
&& cSQL          - Instrução SQL
&& [cNomeCursor] - Nome do cursor retornado (informado qdo instrucao = SELECT)
&& [cMsgWait]    - Mensagem de espera
&& RETORNA - Se [cNomeCursor] for passado retorna cNomeCursor como area, caso
&&           contrario retorna a quantidade de registros afetados pela instrucao
Local nRowCount As Integer, oRS As Object, oVFPCOM As Object, cMsg As String
Local cRowCount As String, nAreaAtual As Integer

If Occurs( 'LIBROTINA.PRG', Upper(Set("Procedure")) ) = 0
   Set Procedure To c:\desenv\win\vfp9\libBase\libRotina.PRG Additive
Endif

nRowCount = 0
nTimeOut  = Iif( Type('nTimeOut')='N', nTimeOut, 0 )

Try

   If Type('cMsgWait') = 'C'
      Wait Window cMsgWait Nowait Noclear
   Endif

   cRowCount = Sys(2015)
   If Type('cNomeCursor') = 'C'
      nRowCount = SQLExec( nConn, cSQL, cNomeCursor )
      If nRowCount >= 0
         nRowCount = Reccount(cNomeCursor)
      Endif
   Else

      cSQL = cSQL +Chr(13)+ 'SELECT @@ROWCOUNT as _T_A_L_L_Y'

      nAreaAtual = Select()
      nRowCount = SQLExec( nConn, cSQL, cRowCount )
      If nRowCount >= 0
         nRowCount = &cRowCount.._T_A_L_L_Y
      Endif
      Use In ( Select( cRowCount ) )

      Select (nAreaAtual)

   Endif

   If nRowCount < 0
      cMsg = FI_MsgErr()
      _Cliptext = cSQL +Chr(13)+"-- Erro: "+ cMsg
      If !Empty( cMsg )
         Messagebox( cMsg, 16, 'Atenção', nTimeOut )
      Endif
   Endif


Catch

   cMsg =  FI_MsgErr()
   If Occurs( 'BOF OR EOF IS TRUE', Upper(cMsg) ) > 0 Or cMsg == '1429'
      && Quer dizer que nenhum registro atendeu a selecao de dados
      nRowCount = 0
   Else
      If !Empty(cMsg)
         _Cliptext = cSQL
         Messagebox( cMsg, 16, 'Atenção', nTimeOut )
      Endif
      nRowCount = -1
   Endif

Finally

   If Type('cMsgWait') = 'C'
      Wait Clear
   Endif

Endtry

Return nRowCount

Endfunc
