*****************************
* VERIFICA N�VEL DO USU�RIO *
*****************************
Function VERGRUPO( fModulo As String, fRotina As String, lMostraMsg )
Local nSele As Integer, cMsg As String, lRtn As Boolean, cSQL, lUsedMODULOS, cSetEXCLUSIVE
Local nTally

lRtn    = .T.        && VARIAVEL DE RETORNO
nSele   = Select()   && AREA ATUAL

lMostraMsg = IIF(PCOUNT()=3,lMostraMsg,.t.)

If Type("fRotina") = "C"      && CASO  FOI PASSADO A ROTINA
   fRotina = Upper( fRotina ) && LETRAS MAIUSCULAS
Else                          && SE N�O
   fRotina = "PSQ"            && ASSUME COMO PESQUISA
Endif

cSetEXCLUSIVE = Set("Exclusive")
Set Exclusive Off

lUsedMODULOS = Used( 'MODULOS' )

* Seleciona as permissoes de acordo com o grupo do usuario (definido em SENHA) e o modulo passado
cSQL = 'SELECT MODULOS.incluir, MODULOS.alterar, MODULOS.excluir, MODULOS.pesquisar, MODULOS.nivel '
cSQL = cSQL + 'FROM bdMdc!MODULOS '
cSQL = cSQL + 'WHERE MODULOS.usuario="'+ m.drvNomeUsuario+ '" AND MODULOS.modulo = "'+ fModulo + '"'

If Type( 'gnConexao' ) $ 'IN' And gnConexao > 0

   If SQLRun( cSQL, 'RV_MDLUSER' ) <= 0
      Messagebox( 'Falha na sele��o de diretos do usu�rio', 16, 'Aten��o' )
      Return .F.
   Endif
   nTally = Reccount( 'RV_MDLUSER' )
Else

   cSQL = cSQL + ' INTO CURSOR RV_MDLUSER'
   &cSQL
   nTally = _Tally

Endif

cMsg = ""

If nTally > 0  && SE TEM LINHAS

   Do Case

      Case fRotina = "ADD" .And. Not RV_MDLUSER.Incluir

         cMsg = 'Voc� n�o possui direitos para Incluir'

      Case fRotina = "EDT" .And. Not RV_MDLUSER.Alterar

         cMsg = 'Voc� n�o possui direitos para Alterar'

      Case fRotina = "DEL" .And. Not RV_MDLUSER.Excluir

         cMsg = 'Voc� n�o possui direitos para Excluir'

      Case fRotina = "PSQ" .And. Not RV_MDLUSER.Pesquisar

         cMsg = 'Voc� n�o possui direitos para Pesquisar'

   Endcase

Else

   cMsg = 'M�dulo n�o definido para este usu�rio'

Endif

If cSetEXCLUSIVE # 'OFF'
   Set Exclusive &cSetEXCLUSIVE
Endif

If Empty(cMsg)                                                                 && USUARIO SEM RESTRICOES
   If Type( "drvNivelUsuario" ) # [U] And m.drvNivelUsuario < RV_MDLUSER.nivel && MAS NAO TEM NIVEL
      cMsg = 'Usuario sem direitos'
   Endif
Endif

Use In ( Select( 'RV_MDLUSER' ) )

If Not lUsedMODULOS
   Use In ( Select( 'MODULOS' ) )
Endif

If !Empty(cMsg)
   IF lMostraMsg
      Messagebox( fModulo+Chr(13)+cMsg, 16+0, "Aten��o" )
   ENDIF    
   lRtn = .F.
Endif

Select ( nSele )

Return lRtn

Endfunc
