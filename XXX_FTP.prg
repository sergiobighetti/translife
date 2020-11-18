#INCLUDE "c:\desenv\win\vfp9\libbase\ftp.h"
#Define ACAO_INCLUSAO  1
#Define ACAO_ALTERACAO 2
#Define ACAO_EXCLUSAO  3

Local lcPom,loFTP, cUltImportado, lOk , lii, cArq
Local Array laFiles(1),laFile(1)
Private cArqINTERCOR

cDirDestino   = '\\dcrpo\bdmem\robo\'

cArqINTERCOR  = cDirDestino+'INTERCORRENCIA.LOG'
lcPom         = ''


cImportados = ''
IF FILE( cDirDestino+'IMPORTADOS.VER' )
   cImportados = FILETOSTR(cDirDestino+'IMPORTADOS.VER' )
ENDIF 

Clear

Set Procedure To ftp.prg Additive

loFTP         = Createobject('FTP_SERVICE')
cUltImportado = ReadFileIni(cDirDestino+'Status.INI','DOWNLOAD','UltimoArquivoImportado')

*--------------------- usuario   senha        endereco          porta
If loFTP.OpenInternet("medilar", "unimedilar","201.62.123.106", "21" )

   * Lista de nomes de arquivos disponiveis para importação
   lOk = loFTP.NLST( @laFiles, "", _FTPS_RWF_Array, 0 )

   If lOk

      *-- ordena de maneira descendente o nome do arquivo
      =Asort( laFiles,1,-1,1)

      For lii=1 To Alen(laFiles)

         *-- captura informações sobre cada arquivo
         loFTP.GetFTPDirectoryArray( @laFile, laFiles(lii), 0 )

         cArq = laFile[1,1]

         If Type( 'cArq' ) = 'C'

            IF OCCURS( cArq, cImportados ) > 0
               EXIT
            ENDIF 
*!*               If !Empty(cUltImportado)
*!*                  If Upper(cArq) = Upper(cUltImportado)
*!*                     Exit
*!*                  Endif
*!*               Endif


            =Strtofile( TRANSFORM(DATETIME())+ " - Importando: "+ cArq+CHR(13)+CHR(10), cArqINTERCOR, 1 )

            *-- copia o arquivo (ORIGEM, DESTINO         )
            If !loFTP.GetFTPFile( cArq, cDirDestino+cArq )
               *-- se der algum erro

               Set Textmerge To Memvar cErr Noshow
               Set Textmerge On
               \---> <<DATETIME()>>
               \     - Falha ao fazer o download do arquivo da FTP para <<cDirDestino>>
               \       <<loFTP.GetExtendedErrorCode()>>
               \       <<loFTP.GetExtendedErrorMsg()>>
               \
               Set Textmerge Off
               Set Textmerge To
               =Strtofile( cErr, cArqINTERCOR, 1 )

            Else
               *-- tudo certo... processar o arquivo:

               If Occurs( '_PJ', Upper(cArq) ) > 0   &&... se é pessoa JURIDICA
                  nContrato = 2157
                  nValor    = 1.45
               Else                                  &&... se é pessoa FISICA
                  nContrato = 2156
                  nValor    = 4
               Endif


               If FI_AbreTabelas()  &&... se conseguiu abrir as tabelas

                  cErr = ''
                  Try
                     *-- transforma o arquivo texto importado para um CURSOR
                     =fi_TXT_TO_CURSOR( cDirDestino+cArq, 'LV_ORIGEM' )
                  Catch To loError

                     Set Textmerge To Memvar cErr Noshow
                     Set Textmerge On
                      \---> <<DATETIME()>>
                      \     - Falha na conversao do TXT p/ CURSOR (fi_TXT_TO_CURSOR())
                      \      Erro: <<loError.ERRORNO>>
                      \     Linha: <<loError.LINENO>>
                      \   Mensage: <<loError.MESSAGE>>
                      \ Procedure: <<loError.PROCEDURE>>
                      \  Detalhes: <<loError.DETAILS>>
                      \StackLevel: <<loError.STACKLEVEL>>
                      \Comentario: <<loError.LINECONTENTS>>
                      \
                     Set Textmerge Off
                     Set Textmerge To

                  Endtry

                  If Empty(cErr)
                     Try
                        *-- ajusta as informacoes importadas do cursor
                        =fi_Ajusta_Cursor( 'LV_ORIGEM', nContrato, nValor )

                     Catch To loError

                        Set Textmerge To Memvar cErr Noshow
                        Set Textmerge On
                        \---> <<DATETIME()>>
                        \     - Falha ao fazer o ajuste no cursor (fi_Ajusta_Cursor())
                        \      Erro: <<loError.ERRORNO>>
                        \     Linha: <<loError.LINENO>>
                        \   Mensage: <<loError.MESSAGE>>
                        \ Procedure: <<loError.PROCEDURE>>
                        \  Detalhes: <<loError.DETAILS>>
                        \StackLevel: <<loError.STACKLEVEL>>
                        \Comentario: <<loError.LINECONTENTS>>
                        \
                        Set Textmerge Off
                        Set Textmerge To
                     Endtry
                  Endif

                  If Empty(cErr)
                     Try
                        *-- processa o cursor
                        cArqLog = FI_Processando( 'LV_ORIGEM', nContrato )
                        If !Empty(cArqLog)
                           Select (cArqLog)
                           Copy To (cDirDestino+ Forceext(JUSTSTEM(cArq)+'_LOG','XLS')) Type XLS FOR NOT DELETED()
                        ENDIF
                        
                        =fi_ACT_BSPSQ()
                        
                     Catch To loError

                        Set Textmerge To Memvar cErr Noshow
                        Set Textmerge On
                        \---> <<DATETIME()>>
                        \     - Falha ao processar o arquivo (FI_Processando())
                        \      Erro: <<loError.ERRORNO>>
                        \     Linha: <<loError.LINENO>>
                        \   Mensage: <<loError.MESSAGE>>
                        \ Procedure: <<loError.PROCEDURE>>
                        \  Detalhes: <<loError.DETAILS>>
                        \StackLevel: <<loError.STACKLEVEL>>
                        \Comentario: <<loError.LINECONTENTS>>
                        \
                        Set Textmerge Off
                        Set Textmerge To

                     Endtry
                  Endif

                  ****************
                  =WriteFileIni(cDirDestino+'Status.INI','DOWNLOAD','UltimoArquivoImportado',cArq)
                  =Strtofile( cArq+'|', cDirDestino+'IMPORTADOS.VER', 1 )
                  ****************
                  
                  
                  If Empty(cErr)
                     * =fi_M3_A_I_L( nContrato )
                  Endif

                  Close Databases All
                  Close Tables All

                  If !Empty(cErr)
                     =Strtofile( cErr, cArqINTERCOR, 1 )
                  Else

                  Endif

               Endif
               *-- se deu LOG avisar marcio@medicar.com.br
               Endif

         Endif

      Next

   Endif
   =loFTP.CloseInternet()

Else
   TEXT TO cErr TEXTMERGE NOSHOW
---> <<DATETIME()>>
     - Falha na tentativa de coneção com a FTP (Endereço: 201.62.123.106 Porta 21)

   ENDTEXT
   =Strtofile( cErr, cArqINTERCOR, 1 )

Endif
Release Procedure ftp.prg

CLOSE DATABASES all
CLEAR EVENTS 

RETURN 


**********************************************************
Function FI_Processando( cOrg, nContrato )
**********************************************************
Local cArq, cUpd, N, cCond, i, cPlano, nPos, nContrato, Nxxx, nTerm, oReg, cPrn, cESCAPE
Local nAcao, nTipo, cSexo, cEstC, cCep, lTemAtendimento , nSele, nCtrt, cCodTIT, cRecCount
Local aTmp[1], cTmp

Private dDataBase, dDataVigor

cTmp   = Sys(2015)
nSele  = Select()


Select Database, DataVigor From CONTRATO Where idContrato == nContrato Into Array aTmp

dDataBase  = aTmp[1]
dDataVigor = aTmp[2]
Release aTmp

Go Top In &cOrg.

Select ASSOCIADO
Set Order To IDASSOC

Sele &cOrg.
Go Top

Scan

   If Not &cOrg..TIPO $ [12]
      Loop
   Endif

   =Seek( nContrato, 'CONTRATO', 'I_D' )

   nAcao = Val( Tran(&cOrg..ACAO) )
   nTipo = Val( Tran(&cOrg..TIPO) )

   If nTipo == 1 && TITULAR

      fi_imp_titular( cOrg, nAcao, nContrato )

      If Empty(ASSOCIADO.codigo)
         FI_CODIFICA( 'TITULAR' )
      Endif

   Endif

   If nTipo == 2 && DEPENDENTE

      Select &cOrg.
      cCodTIT = fi_imp_dependente( cOrg, nAcao, nContrato )

      *********************** aqui a gambiarra começa: O DEPENDENTE SERA IMPORTADO COMO TITULAR
      If Empty(cCodTIT)
         If Used( 'CLOG' ) And CLOG.DETALHES = "NAO ENCONTRADO O TITULAR P/ DEPENDENTE"
            
            DELETE IN CLOG
            
            *-- passa o DEPENDENTE para TITULAR
            Replace &cOrg..TIPO      With '1'
            Replace &cOrg..codigoTIT With &cOrg..codigoDEP
            Replace &cOrg..codigoDEP With ''
            =fi_imp_titular( cOrg, nAcao, nContrato )
            If Empty(ASSOCIADO.codigo)
               FI_CODIFICA( 'TITULAR' )
            Endif
         Endif
      Endif
      *********************** aqui a gambiarra termina

      If Empty(ASSOCIADO.codigo) And !Empty(cCodTIT)

         FI_CODIFICA( 'DEPENDENTE', Left(cCodTIT,10) )

      Endif

   Endif

   Select (cOrg)

Endscan

=Tableupdate( 2, .T., 'ASSOCIADO'         )
=Tableupdate( 2, .T., 'ASSOCIADO_PLANO'   )

cRet = ''
If Used( 'CLOG' )
   If Recno( 'CLOG' ) > 0
      *--- deu log
      cRet = 'CLOG'
   Endif
Endif

Return cRet



**********************************************************
Function fi_imp_titular( cOrg, nAcao, nContrato )
*--- importa inforcoes do TITULAR
***********************************************************
Local nSele, cSexo, cCep, cCpf, cPerto_DE, cEntre_RUAS, lTemAtendimento, cEstC, nContrato, lJaExiste
Local lMassaTotal, lReplace, nChv, cCodTIT, cEnd, cCpl

nSele       = Select()
lMassaTotal = .F.

If Empty(&cOrg..codigoTIT)
   FI_GravaLog( &cOrg..codigoDEP, "CODIGO DO TITULAR NAO INFORMADO", cOrg )
   Return
Endif

cCodTIT = Str( nContrato,10) + Alltrim(&cOrg..codigoTIT)
If Seek( cCodTIT, 'ASSOCIADO', 'CODORIGEM' )
   nChv = ASSOCIADO.IDASSOC
   lJaExiste = .T.
Else
   lJaExiste = .F.
   nChv = 0
Endif

Select ASSOCIADO

If nAcao = ACAO_EXCLUSAO

   If lJaExiste

      Replace In ASSOCIADO ;
         SITUACAO     With "CANCELADO",;
         datacancela  With Date(),;
         motivocancel With "OUTROS"

   Else

      FI_GravaLog( &cOrg..codigoTIT, "EXC: TITULAR NÃO ENCONTRATO", cOrg )

   Endif

Else

   cSexo       = Iif( &cOrg..sexo=[M], "MASCULINO", "FEMININO" )
   cCep        = Strtran( Strtran( Tran(&cOrg..cep), [.] ), [-] )
   cCep        = Iif( !Empty(cCep), Tran(cCep, [@R 99.999-999] ), '' )
   cCpf        = Strtran( Strtran( Strtran( Alltrim( &cOrg..cpf ), [.] ), [-] ), [/] )
   cCpf        = Tran( Padl(cCpf,11,[0]),[@R 999.999.999-99] )
   cPerto_DE   = Iif( Empty(&cOrg..perto_DE),  '<NÃO CONSTA>', Upper(Alltrim(&cOrg..perto_DE )) )
   cEntre_RUAS = Iif( Empty(&cOrg..ENTRE_RUA), '<NÃO CONSTA>', Upper(Alltrim(&cOrg..ENTRE_RUA)) )

   lTemAtendimento = Val(Tran(&cOrg..atend)) = 1
   cEstC = Left( Upper(Allt(&cOrg..civil)), 2 )
   cEstC = Iif( cEstC = "CA", "CASADO",;
      IIF( cEstC = "SO", "SOLTEIRO",;
      IIF( cEstC = "VI", "VIUVO",;
      IIF( cEstC = "DI", "DIVORCIADO",;
      IIF( cEstC = "CO", "COMPANHEIRO", "OUTROS" )))))

   If nAcao = ACAO_INCLUSAO && INCLUSAO

      If Not lJaExiste

         lReplace = .T.

         Append Blank In ASSOCIADO

         Replace ASSOCIADO.idContrato      With nContrato
         Replace ASSOCIADO.data_cadastro   With Datetime()

      Else

         If ASSOCIADO.SITUACAO = 'CANCELADO'

            Replace In ASSOCIADO ;
               SITUACAO     With "ATIVO",;
               datacancela  With {},;
               dataExc      With {},;
               motivocancel With ""

            lReplace = .T.

         Else

            If Not lMassaTotal
               lReplace = .F.
               FI_GravaLog( &cOrg..codigoTIT, "INC: TITULAR JA CADASTRADO", cOrg  )
            Else
               lReplace = .T.
            Endif

         Endif

      Endif

   Else

      lReplace = ( nAcao == ACAO_ALTERACAO And lJaExiste )

   Endif

   If lReplace

      cEnd = Alltrim(&cOrg..endereco)
      If Len(cEnd) > 40
         cEnd = cEnd +' '+ Alltrim(Iif( Fsize('COMPLE',     cOrg)>0, &cOrg..Comple,       ;
            IIF( Fsize('COMPLEMENT ', cOrg)>0, &cOrg..COMPLEMENT,'' )) )
         cEnd = Alltrim(cEnd)
         cEnd =   Left(cEnd,40)
         cCpl = Substr(cEnd,41)
      Else
         cCpl = Alltrim(Iif( Fsize('COMPLE',      cOrg )>0, &cOrg..Comple,       ;
            IIF( Fsize('COMPLEMENT ', cOrg )>0, &cOrg..COMPLEMENT,'' )) )
      Endif

      Replace ;
         ASSOCIADO.Nome            With &cOrg..Nome,;
         ASSOCIADO.iniciais        With MONOGRAMA(&cOrg..Nome),;
         ASSOCIADO.SITUACAO        With "ATIVO",;
         ASSOCIADO.datacancela     With {},;
         ASSOCIADO.dataExc         With {},;
         ASSOCIADO.motivocancel    With "",;
         ASSOCIADO.endereco        With cEnd,;
         ASSOCIADO.complemento     With cCpl,;
         ASSOCIADO.bairro          With &cOrg..bairro,;
         ASSOCIADO.cep             With cCep,;
         ASSOCIADO.cidade          With &cOrg..cidade,;
         ASSOCIADO.uf              With &cOrg..estado,;
         ASSOCIADO.fone_residencia With &cOrg..FONE_RES,;
         ASSOCIADO.fone_comercial  With &cOrg..fone_com,;
         ASSOCIADO.perto_DE        With cPerto_DE,;
         ASSOCIADO.entre_ruas      With cEntre_RUAS,;
         ASSOCIADO.data_nascimento With FI_ActData(&cOrg..DT_NASCIME),;
         ASSOCIADO.sexo            With cSexo,;
         ASSOCIADO.estado_civil    With cEstC,;
         ASSOCIADO.cpf             With cCpf,;
         ASSOCIADO.rg              With &cOrg..rg,;
         ASSOCIADO.CodOrigem       With Alltrim(&cOrg..codigoTIT),;
         ASSOCIADO.atendimento     With lTemAtendimento,;
         ASSOCIADO.Database        With dDataBase,;
         ASSOCIADO.vendedor        With CONTRATO.vendedor,;
         ASSOCIADO.ficha           With CONTRATO.ficha,;
         ASSOCIADO.DataVigor       With dDataVigor,;
         ASSOCIADO.ativacao        With Date(),;
         ASSOCIADO.vldReg          With .T. ;
         IN ASSOCIADO

      If Fsize( 'RESTRICOES', cOrg ) > 0
         Replace ASSOCIADO.orientacao With &cOrg..RESTRICOES In ASSOCIADO
      Endif

      If Fsize( 'OBSERVACAO', cOrg ) > 0
         Replace ASSOCIADO.observacao With &cOrg..observacao In ASSOCIADO
      Endif

      If nAcao = ACAO_INCLUSAO
         =Tableupdate( 2, .T., 'ASSOCIADO' )
      Endif

      FI_ActPlano( cOrg, ASSOCIADO.IDASSOC, &cOrg..VALOR )

   Else

      If nAcao = ACAO_ALTERACAO
         FI_GravaLog( &cOrg..codigoTIT, "ALT: TITULAR NAO ENCONTRADO", cOrg )
      Endif

   Endif

Endif

Select (nSele)

Return




*************************************************************
Function fi_imp_dependente( cOrg, nAcao, nContrato )
*************************************************************
Local nSele, cSexo, cCep, cCpf, cPerto_DE, cEntre_RUAS, lTemAtendimento, cEstC, nContrato, lJaExiste
Local lMassaTotal, lReplace,  cCodDEP, cCodTIT, nChv
Local cCodTIT

nSele       = Select()
lMassaTotal = .F.

If Empty(&cOrg..codigoTIT)
   FI_GravaLog( &cOrg..codigoDEP, "CODIGO DO TITULAR NAO INFORMADO", cOrg )
   Return ""
Endif

If Empty(&cOrg..codigoDEP)
   FI_GravaLog( &cOrg..codigoDEP, "CODIGO DO DEPENDENTE NAO INFORMADO", cOrg )
   Return ""
Endif

cCodTIT = Str( nContrato,10 )+ Alltrim( &cOrg..codigoTIT )
If Seek( cCodTIT, 'ASSOCIADO', 'CODORIGEM' )
   cCodTIT  = ASSOCIADO.codigo
Else
   cCodTIT  = ""
   nChv = 0
Endif

Use In ( Select( 'CLV_TIT_VER' ) )

If Empty(cCodTIT)

   FI_GravaLog( &cOrg..codigoDEP, "NAO ENCONTRADO O TITULAR P/ DEPENDENTE", cOrg )

Else

   Select ASSOCIADO

   cCodDEP = Str(nContrato,10)+Alltrim(&cOrg..codigoDEP)

   If Seek( cCodDEP, 'ASSOCIADO', 'CODORIGEM' )
      lJaExiste = .T.
      cCodDEP = ASSOCIADO.IDASSOC
   Else
      lJaExiste = .F.
      cCodDEP   = 0
   Endif

   Select ASSOCIADO

   If lJaExiste
      =Seek( cCodDEP, 'ASSOCIADO', 'IDASSOC' )
   Endif

   If nAcao = ACAO_EXCLUSAO

      If lJaExiste

         Replace In ASSOCIADO ;
            SITUACAO     With "CANCELADO",;
            datacancela  With Date(),;
            motivocancel With "OUTROS"

      Else

         FI_GravaLog( &cOrg..codigoDEP, "EXC: DEPENDENTE NÃO ENCONTRATO", cOrg )

      Endif

   Else

      cSexo       = Iif( &cOrg..sexo=[M], "MASCULINO", "FEMININO" )
      cCep        = Strtran( Strtran( Tran(&cOrg..cep), [.] ), [-] )
      cCep        = Iif( !Empty(cCep), Tran(cCep, [@R 99.999-999] ), '' )
      cCpf        = Strtran( Strtran( Strtran( Alltrim( &cOrg..cpf ), [.] ), [-] ), [/] )
      cCpf        = Tran( Padl(cCpf,11,[0]),[@R 999.999.999-99] )
      cPerto_DE   = Iif( Empty(&cOrg..perto_DE),  '<NÃO CONSTA>', Upper(Alltrim(&cOrg..perto_DE )) )
      cEntre_RUAS = Iif( Empty(&cOrg..ENTRE_RUA), '<NÃO CONSTA>', Upper(Alltrim(&cOrg..ENTRE_RUA)) )

      lTemAtendimento = Val(Tran(&cOrg..atend)) = 1
      cEstC = Left( Upper(Allt(&cOrg..civil)), 2 )
      cEstC = Iif( cEstC = "CA", "CASADO",;
         IIF( cEstC = "SO", "SOLTEIRO",;
         IIF( cEstC = "VI", "VIUVO",;
         IIF( cEstC = "DI", "DIVORCIADO",;
         IIF( cEstC = "CO", "COMPANHEIRO", "OUTROS" )))))

      If nAcao = ACAO_INCLUSAO && INCLUSAO

         If Not lJaExiste

            lReplace = .T.

            Append Blank In ASSOCIADO
            Replace ASSOCIADO.idContrato    With nContrato
            Replace ASSOCIADO.data_cadastro With Datetime()

         Else

            If ASSOCIADO.SITUACAO = 'CANCELADO'

               Replace In ASSOCIADO ;
                  SITUACAO     With "ATIVO",;
                  datacancela  With {},;
                  dataExc      With {},;
                  motivocancel With ""

               lReplace = .T.

            Else
               If Not lMassaTotal
                  lReplace = .F.
                  FI_GravaLog( &cOrg..codigoDEP, "INC: DEPENDENTE JA CADASTRADO", cOrg  )
               Else
                  lReplace = .T.
               Endif
            Endif

         Endif

      Else

         lReplace = ( nAcao == ACAO_ALTERACAO And lJaExiste )

      Endif

      If lReplace

         Replace ;
            ASSOCIADO.Nome            With &cOrg..Nome,;
            ASSOCIADO.iniciais        With MONOGRAMA(&cOrg..Nome),;
            ASSOCIADO.SITUACAO        With "ATIVO",;
            ASSOCIADO.datacancela     With {},;
            ASSOCIADO.dataExc         With {},;
            ASSOCIADO.motivocancel    With "",;
            ASSOCIADO.endereco        With &cOrg..endereco,;
            ASSOCIADO.complemento     With Iif( Fsize('COMPLE',     cOrg )>0, &cOrg..Comple,       ;
            IIF( Fsize('COMPLEMENT ',cOrg )>0, &cOrg..COMPLEMENT,'' )),;
            ASSOCIADO.bairro          With &cOrg..bairro,;
            ASSOCIADO.cep             With cCep,;
            ASSOCIADO.cidade          With &cOrg..cidade,;
            ASSOCIADO.uf              With &cOrg..estado,;
            ASSOCIADO.fone_residencia With &cOrg..FONE_RES,;
            ASSOCIADO.fone_comercial  With &cOrg..fone_com,;
            ASSOCIADO.perto_DE        With cPerto_DE,;
            ASSOCIADO.entre_ruas      With cEntre_RUAS,;
            ASSOCIADO.data_nascimento With FI_ActData( &cOrg..DT_NASCIME ),;
            ASSOCIADO.sexo            With cSexo,;
            ASSOCIADO.estado_civil    With cEstC,;
            ASSOCIADO.cpf             With cCpf,;
            ASSOCIADO.rg              With &cOrg..rg,;
            ASSOCIADO.CodOrigem       With Alltrim(&cOrg..codigoDEP),;
            ASSOCIADO.atendimento     With lTemAtendimento,;
            ASSOCIADO.Database        With dDataBase,;
            ASSOCIADO.vendedor        With CONTRATO.vendedor,;
            ASSOCIADO.ficha           With CONTRATO.ficha,;
            ASSOCIADO.DataVigor       With dDataVigor,;
            ASSOCIADO.ativacao        With Date(),;
            ASSOCIADO.vldReg          With .T. ;
            IN ASSOCIADO

         If Fsize( 'RESTRICOES', cOrg ) > 0
            Replace ASSOCIADO.orientacao With &cOrg..RESTRICOES In ASSOCIADO
         Endif

         If Fsize( 'OBSERVACAO', cOrg ) > 0
            Replace ASSOCIADO.observacao With &cOrg..observacao In ASSOCIADO
         Endif

         If nAcao = ACAO_INCLUSAO
            =Tableupdate( 2, .T., 'ASSOCIADO' )
         Endif

         FI_ActPlano( cOrg, ASSOCIADO.IDASSOC, &cOrg..VALOR )

      Else

         If nAcao = ACAO_ALTERACAO
            FI_GravaLog( &cOrg..codigoDEP, "ALT: DEPENDENTE NAO ENCONTRADO", cOrg )
         Endif

      Endif

   Endif

Endif

Select (nSele)

Return cCodTIT



******************************************************
Function FI_ActPlano
Lparam cOrg, nChv, nVlr
******************************************************
Local cDele, cPlano, i, nPos, nPln, cPlano, nQtd, nVend, lAdd, nSele
Local aPlanos[1]

nSele  = Select()
nVend  = CONTRATO.vendedor
cPlano = '2'

nQtd = Alines( aPlanos, cPlano, .T., "," )

If nQtd > 0
   *-- apaga todos os produtos do associado

   If Seek( nChv, 'ASSOCIADO_PLANO', 'IDASSOC' )
      Select ASSOCIADO_PLANO
      Set Order To IDASSOC
      Scan While ASSOCIADO_PLANO.IDASSOC == nChv
         Delete In ASSOCIADO_PLANO
      Endscan
   Endif

Endif

If Transform(&cOrg..atend) = "1"  && com atendimento

   cDele = Set("Deleted")
   Set Deleted Off  &&-- deletados visiveis

   For i = 1 To nQtd

      If Empty(aPlanos[i])
         Loop
      Endif

      nPln = Int(Val(aPlanos[i]))
      lAdd = .T.

      If Seek( nChv, 'ASSOCIADO_PLANO', 'IDASSOC' )
         Select ASSOCIADO_PLANO
         Set Order To IDASSOC
         Scan While ASSOCIADO_PLANO.IDASSOC == nChv
            If ASSOCIADO_PLANO.idPlano == nPln
               If Deleted()  &&-- se o produto esta deletado
                  Recall     &&-- recupera
               Endif
               Replace ASSOCIADO_PLANO.VALOR With nVlr In ASSOCIADO_PLANO
               lAdd = .F.
            Endif
         Endscan
      Endif

      If lAdd

         Insert Into ASSOCIADO_PLANO ;
            (IDASSOC, idPlano, dtInc, idvend, parcela, VALOR ) ;
            VALUES ;
            (nChv, nPln,Date(), nVend, 1, nVlr )

      Endif

   Next

   Set Deleted &cDele

Endif

Select ( nSele )
Return .T.



***********************************************
Function FI_ActData
Lparameters cData
***********************************************
Local nAno, nMes, nDia, dRtn

If Type( 'cData' ) $ 'DT'
   Return cData
Else
   nAno = Val( Substr( cData, 1, 4 ) )
   nMes = Val( Substr( cData, 5, 2 ) )
   nDia = Val( Substr( cData, 7, 2 ) )
   If nAno >= 00 And nAno <= 03
      nAno = 2000 + nAno
   Else
      If nAno <= 99
         nAno = 1900 + nAno
      Endif
   Endif
   Try
      dRtn = Date( nAno, nMes, nDia )
   Catch
      dRtn = {//}
   Endtry

   Return dRtn

Endif



******************************************************
Function fi_Ajusta_Cursor( cOrg, nContrato, nVlr )
* Ajusta o cursor
******************************************************

Select (cOrg)

Go Top In (cOrg)

Scan

   If Empty( &cOrg..Nome )
      Delete In &cOrg
   Endif

   If Fsize( 'COMPLE', cOrg ) > 0
      Replace Comple   With SemAcento( Upper(&cOrg..Comple) )
   Else
      If Fsize( 'COMPLEMENT', cOrg ) > 0
         Replace COMPLEMENT With SemAcento( Upper(&cOrg..COMPLEMENT) )
      Endif
   Endif

   Replace In (cOrg) ;
      FONE_RES With fi_act_fone(&cOrg..FONE_RES),;
      fone_com With fi_act_fone(&cOrg..fone_com),;
      NOME     With SemAcento( Upper(&cOrg..Nome)     ),;
      endereco With SemAcento( Upper(&cOrg..endereco) ),;
      bairro   With SemAcento( Upper(&cOrg..bairro)   ),;
      cidade   With SemAcento( Upper(&cOrg..cidade)   ) ;

   Replace In (cOrg) ;
      NOME     With Strtran( Alltrim( &cOrg..Nome     ), '  ', ' ' ),;
      endereco With Strtran( Alltrim( &cOrg..endereco ), '  ', ' ' ),;
      bairro   With Strtran( Alltrim( &cOrg..bairro   ), '  ', ' ' ),;
      cidade   With Strtran( Alltrim( &cOrg..cidade   ), '  ', ' ' ) ;


   If Isalpha( Transform(&cOrg..TIPO) )
      If Upper(Transform(&cOrg..TIPO) ) = 'T'
         Replace In (cOrg) TIPO With '1'
      Endif
      If Upper(Transform(&cOrg..TIPO)) = 'D'
         Replace In (cOrg) TIPO With '2'
      Endif
   Endif

   If !Empty( &cOrg..codigoTIT )

      cSeek = Str(nContrato,10)+ Padr( Alltrim(&cOrg..codigoTIT), Len(ASSOCIADO.CodOrigem) )
      If Seek( cSeek, 'ASSOCIADO', 'CODORIGEM' )
         Replace &cOrg..idTIT With ASSOCIADO.IDASSOC
      Endif

      Select &cOrg.

   Endif

   If !Empty( &cOrg..codigoDEP )

      cSeek = Str(nContrato,10)+ Padr( Alltrim(&cOrg..codigoDEP), Len(ASSOCIADO.CodOrigem) )

      Select &cOrg.

   Endif

   Replace ;
      &cOrg..codigoTIT With Padl( Alltrim( &cOrg..codigoTIT ), Len(codigoTIT) ),;
      &cOrg..codigoDEP With Padl( Alltrim( &cOrg..codigoDEP ), Len(codigoDEP) )


   Replace &cOrg..VALOR With nVlr In (cOrg)

Endscan

Select * From &cOrg. Order By codigoTIT, codigoDEP, TIPO, ACAO Into Cursor &cOrg. Readwrite

Select &cOrg.

Return .T.









*---------------------------------------------------------
Function fi_TXT_TO_CURSOR( cArqTXT, cCursor )
* Transforma <cArqTxt> em um cursor temporario (<cCursor>)
*---------------------------------------------------------
Local cOrg, cLay, cTxL, cLinha, i, cVar, nEC
Local nTpFone, cPreFix, cNroFon, cObsFon

cOrg = cCursor
cLay = Sys(2015)
cTxL = Sys(2015)

Create Cursor (cOrg) ;
   ( TIPO       C( 1),;
   NOME       C(40),;
   endereco   C(40),;
   COMPLE     C(40),;
   bairro     C(20),;
   cep        C(10),;
   cidade     C(20),;
   estado     C( 2),;
   FONE_RES   C(20),;
   fone_com   C(20),;
   perto_DE   C(40),;
   ENTRE_RUA  C(40),;
   DT_NASCIME C( 8),;
   sexo       C( 9),;
   civil      C(11),;
   cpf        C(14),;
   rg         C(18),;
   codigoTIT  C(20),;
   codigoDEP  C(20),;
   atend      N( 1),;
   ACAO       N( 1),;
   DATABASE   C( 8),;
   observacao C(200),;
   VALOR      Y,;
   idTIT      i,;
   idDEP      i )

*-- layout MEDISALVA
Create Cursor (cLay) ( de N(4), ate N(4), TIPO C(1), obrig C(1) )

Insert Into (cLay) Values ( 0001, 0001, 'A', 'S' )
Insert Into (cLay) Values ( 0002, 0050, 'A', 'S' )
Insert Into (cLay) Values ( 0052, 0050, 'A', 'S' )
Insert Into (cLay) Values ( 0102, 0008, 'D', 'S' )
Insert Into (cLay) Values ( 0110, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0160, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0210, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0260, 0001, 'A', 'S' )
Insert Into (cLay) Values ( 0261, 0002, 'S', 'S' )
Insert Into (cLay) Values ( 0263, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0293, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0295, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0297, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0299, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0301, 0018, 'A', 'N' )
Insert Into (cLay) Values ( 0319, 0018, 'A', 'N' )
Insert Into (cLay) Values ( 0337, 0030, 'A', 'N' )

Insert Into (cLay) Values ( 0367, 0004, 'N', 'S' )
Insert Into (cLay) Values ( 0371, 0050, 'A', 'S' )
Insert Into (cLay) Values ( 0421, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0471, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0521, 0008, 'D', 'N' )
Insert Into (cLay) Values ( 0529, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0531, 0010, 'N', 'S' )
Insert Into (cLay) Values ( 0541, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0543, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0593, 0010, 'A', 'N' )
Insert Into (cLay) Values ( 0603, 0015, 'A', 'N' )
Insert Into (cLay) Values ( 0618, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0648, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0678, 0002, 'A', 'N' )
Insert Into (cLay) Values ( 0680, 0009, 'A', 'N' )
Insert Into (cLay) Values ( 0698, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0691, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0741, 0010, 'A', 'N' )
Insert Into (cLay) Values ( 0751, 0015, 'A', 'N' )
Insert Into (cLay) Values ( 0766, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0796, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0826, 0002, 'A', 'N' )
Insert Into (cLay) Values ( 0828, 0009, 'A', 'N' )

Insert Into (cLay) Values ( 0837, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0839, 0004, 'N', 'N' )
Insert Into (cLay) Values ( 0843, 0010, 'N', 'N' )
Insert Into (cLay) Values ( 0853, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0883, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0885, 0004, 'N', 'N' )
Insert Into (cLay) Values ( 0889, 0010, 'N', 'N' )
Insert Into (cLay) Values ( 0899, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0929, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0931, 0004, 'N', 'N' )
Insert Into (cLay) Values ( 0935, 0010, 'N', 'N' )
Insert Into (cLay) Values ( 0945, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0975, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0977, 0004, 'N', 'N' )
Insert Into (cLay) Values ( 0981, 0010, 'N', 'N' )
Insert Into (cLay) Values ( 0991, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 1021, 0100, 'A', 'N' )
Insert Into (cLay) Values ( 1121, 0100, 'A', 'N' )
Insert Into (cLay) Values ( 1221, 0008, 'D', 'N' )
Insert Into (cLay) Values ( 1229, 0008, 'D', 'N' )

Insert Into (cLay) Values ( 1237, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 1287, 0008, 'D', 'N' )
Insert Into (cLay) Values ( 1295, 0010, 'A', 'N' )

*-- declara variavais
Select &cLay
Scan All
   cVar = TIPO+Transform(de)+'_a_'+Transform(ate)
   Local &cVar.
Endscan

*-- cursor que recebera o texto
Create Cursor (cTxL) ( lin1 C(240), lin2 C(240), lin3 C(240), lin4 C(240), lin5 C(240), lin6 C(240), lin7 C(240) )
Append From (cArqTXT) Sdf

Select (cTxL)
Scan All

   *-- monta linha
   cLinha = &cTxL..lin1+&cTxL..lin2+&cTxL..lin3+&cTxL..lin4+&cTxL..lin5+&cTxL..lin6+&cTxL..lin7

   If Empty(cLinha)
      Exit
   Endif

   *-- carrega variaveis
   Select &cLay
   Scan All
      cVar = TIPO+Transform(de)+'_a_'+Transform(ate)
      &cVar. = SemAcento(Substr( cLinha, de, ate))
   Endscan

   *-- inclui no layout medicar
   Select (cOrg)
   Append Blank

   Replace  Nome        With Upper( Alltrim(a52_a_50) )
   Replace  DT_NASCIME  With Right(d102_a_8,4)+Substr(d102_a_8,3,2)+Left(d102_a_8,2)
   Replace  sexo        With Iif(a260_a_1='M','MASCULINO','FEMININO')
   cEnd = Strtran( Alltrim(a543_a_50)+' '+Alltrim(a593_a_10)+' '+Alltrim(a603_a_15), '  ', ' ' )
   Replace  endereco    With Upper( Left(cEnd,40)   )
   Replace  Comple      With Upper(Substr(cEnd,41))
   Replace  bairro      With Upper(Alltrim(a618_a_30))
   Replace  cep         With Alltrim(a680_a_9)
   Replace  cidade      With Upper(Alltrim(a648_a_30))
   Replace  estado      With Upper(Alltrim(a678_a_2))
   Replace  cpf         With Chrtran( Alltrim(a319_a_18),'-/.','' )
   Replace  rg          With Chrtran( Alltrim(a301_a_18),'-/.','' )
   Replace  codigoTIT   With Alltrim( a1237_a_50 )
   Replace  codigoDEP   With Alltrim( a371_a_50 )
   Replace  ACAO        With Iif( a1_a_1='I', 1, Iif( a1_a_1='A', 2, Iif( a1_a_1='E',3,0)))
   Replace  atend       With 1
   Replace  observacao  With Alltrim(a471_a_50)
   nEC = Int(Val(s261_a_2))

   Replace  civil ;
      With  Iif( nEC = 1, 'SOLTEIRO',    Iif( nEC = 2, 'CASADO',;
      IIF( nEC = 3, 'DIVORCIADO',  Iif( nEC = 4, 'DIVORCIADO',;
      IIF( nEC = 5, 'COMPANHEIRO', Iif( nEC = 6, 'OUTROS',;
      IIF( nEC = 7, 'OUTROS',      Iif( nEC = 8, 'VIUVO', 'OUTROS' ))))))))

   Replace  Database ;
      With Right(d1287_a_8,4)+Substr(d1287_a_8,3,2)+Left(d1287_a_8,2)

   Local aFones[4,4]
   aFones[1,1] = Int(Val(n837_a_2))
   aFones[1,2] = Right(Alltrim(n839_a_4),3)
   aFones[1,3] = Tran(Int(Val(n843_a_10)))
   aFones[1,4] = Alltrim(a853_a_30)
   *--
   aFones[2,1] = Int(Val(n883_a_2))
   aFones[2,2] = Right(Alltrim(n885_a_4),3)
   aFones[2,3] = Tran(Int(Val(n889_a_10)))
   aFones[2,4] = Alltrim(a899_a_30)
   *--
   aFones[3,1] = Int(Val(n929_a_2))
   aFones[3,2] = Right(Alltrim(n931_a_4),3)
   aFones[3,3] = Tran(Int(Val(n935_a_10)))
   aFones[3,4] = Alltrim(a945_a_30)
   *--
   aFones[4,1] = Int(Val(n975_a_2))
   aFones[4,2] = Right(Alltrim(n977_a_4),3)
   aFones[4,3] = Tran(Int(Val(n981_a_10)))
   aFones[4,4] = Alltrim(a991_a_30)
   *--

   *-- ajusta telefones
   For i=1 To 4

      nTpFone = Int(Val(n837_a_2))
      cPreFix = Right(Alltrim(n839_a_4),3)
      cNroFon = Alltrim(n843_a_10)
      cObsFon = Alltrim(a853_a_30)

      If Inlist(aFones[i,1], 2,5 )
         If Empty(FONE_RES)
            Replace FONE_RES With '('+ aFones[i,2] +')'+aFones[i,3]
         Endif
      Else
         If Empty(fone_com)
            Replace fone_com With '('+ aFones[i,2] +')'+aFones[i,3]
         Endif
      Endif
   Next

   Select (cTxL)

Endscan

*-- ajusta CODIGO e TIPO
Select (cOrg)
Replace codigoDEP With Iif(codigoTIT==codigoDEP,'',codigoDEP) All
Replace TIPO With Iif( !Empty(codigoDEP) And !codigoTIT==codigoDEP, '2','1' ) All


Use In (Select(cLay))
Use In (Select(cTxL))


Return .T.





*------------------------------
Function fi_act_fone
* Acerta a mascara do telefone
*------------------------------
Lparameters cFone
Local nTam, cRet, i, cLet

cFone = Alltrim(cFone)
cFone = Strtran( cFone, '(', '' )
cFone = Strtran( cFone, ')', '' )
cFone = Strtran( cFone, '-', '' )
cFone = Strtran( cFone, '.', '' )
cFone = Alltrim( Strtran( cFone, ' ', '' ) )

nTam  = Len(cFone)
cRet  = ''

For i=1 To nTam

   cLet = Substr(cFone,i,1)
   If Not Isalpha( cLet )
      cRet = cRet + cLet
   Endif

Endfor

If Len(cRet) = 7
   cRet = '3'+ cRet
Endif

Return cRet



***********************************************
Function FI_GravaLog
Lparam  chv, cErr, cOrg
***********************************************

If Select( 'CLOG' ) = 0
   Create Cursor CLOG ( CHAVE C(20), Nome C(40), DETALHES C(60) )
Endif

Append Blank In CLOG
Replace ;
   CLOG.CHAVE    With Alltrim(Tran(chv)),;
   CLOG.Nome     With Alltrim(&cOrg..Nome),;
   CLOG.DETALHES With cErr ;
   IN CLOG

Return .T.



***********************************************
Function FI_AbreTabelas()
***********************************************
Local cDirTAB, lOk, cLstTabelas, nQtd, i, aArq[1]

Close Databases All
Close Tables All

lOk         = .F.
cLstTabelas = 'CONTRATO;ASSOCIADO;ASSOCIADO_PLANO;FILIAL_CHAVES;FILIAL;BSPSQ'
cDirTAB     = ReadFileIni(cDirDestino+'Status.INI','DIRETORIO','Tabelas') && 'c:\desenv\win\vfp9\mdl\'

nQtd = Alines( aArq, cLstTabelas, 1, ';' )
For i = 1 To nQtd

   Try

      Use (cDirTAB+aArq[i]) In 0

      Select (aArq[i])
      =CursorSetProp("Buffering",5)

      lOk = .T.

   Catch To loError

      Set Textmerge To (cArqINTERCOR) Additive
      Set Textmerge On
       \---> <<DATETIME()>>
       \     - Falha na abertura dos arquivos (FI_AbreTabelas())
       \      Erro: <<loError.ERRORNO>>
       \     Linha: <<loError.LINENO>>
       \   Mensage: <<loError.MESSAGE>>
       \ Procedure: <<loError.PROCEDURE>>
       \  Detalhes: <<loError.DETAILS>>
       \StackLevel: <<loError.STACKLEVEL>>
       \Comentario: <<loError.LINECONTENTS>>
      Set Textmerge Off
      Set Textmerge To

      lOk = .F.
      Exit

   Endtry

Next i

If Not lOk
   Close Databases All
   Close Tables All
Endif

Return lOk



Function fi_M_A_I_L( nContrato )

Try

   iMsg          = Createobject("CDO.Message")
   iMsg.From     = 'informatica@medicar.com.br'
   iMsg.Subject  = 'Atualização MEDILAR (Contrato: '+Transform(nContrato)+")"
   iMsg.To       = "marcio@medicar.com.br"
   iMsg.BCC      = ''
   iMsg.TextBody = "Atualização MEDILAR (Contrato: "+Transform(nContrato)+")" +;
      "Atualizado em "+Transform(Datetime())
   * iMsg.AddAttachment(cNomeArq)
   iMsg.Send
   Release iMsg

Catch To loError

   Set Textmerge To Memvar cErr Noshow
   Set Textmerge On
    \      Erro: <<loError.ERRORNO>>
    \     Linha: <<loError.LINENO>>
    \   Mensage: <<loError.MESSAGE>>
    \ Procedure: <<loError.PROCEDURE>>
    \  Detalhes: <<loError.DETAILS>>
    \StackLevel: <<loError.STACKLEVEL>>
    \Comentario: <<loError.LINECONTENTS>>
   Set Textmerge Off
   Set Textmerge To

Endtry





******************************************************************************************************************
******************************************************************************************************************
******************************************************************************************************************

FUNCTION fi_ACT_BSPSQ()
Local cCod, oReg, lDele, lAtz, nTot

Select BSPSQ
Go Top
nTot = Reccount()

* Apaga os codigos que não existem em CONTRATO e ASSOCIADO

Scan All
   lDele = .F.

   If Seek(BSPSQ.chv_filial, 'FILIAL', 'IDFILIAL' )
      If !Filial.atend
         lDele = .T.
      Endif
   Endif

   If Empty(BSPSQ.fantasia)
      lDele = .T.
   Endif
   cCod = BSPSQ.chv_filial + BSPSQ.chv_tipo + BSPSQ.chv_numero + BSPSQ.chv_class
   If !lDele
      If BSPSQ.chv_class = 'CT'
         lDele = !Seek( cCod, 'CONTRATO',  'CODIGO' )
      Else
         lDele = !Seek( cCod, 'ASSOCIADO', 'CODIGO' )
      Endif
   Endif
   If lDele
      Delete In BSPSQ
   Endif

Endscan

Select CONTRATO
Go Top
nTot = Reccount()

Scan All

   If Seek(CONTRATO.idFilial, 'FILIAL', 'IDFILIAL' )
      If  Filial.atend
         cCod = Alltrim( CONTRATO.codigo )
         lAtz = !Seek( cCod, 'BSPSQ', 'CODIGO' )
         If !lAtz
            lAtz = BSPSQ.situacao <> CONTRATO.situacao Or BSPSQ.Nome <> CONTRATO.nome_responsavel
         Endif
         If lAtz
            Scatter Name oReg
            Do BSPSQ_ATZ With oReg, 'CONTRATO'
         Endif
      Endif
   Endif
   Select CONTRATO

Endscan

Select ASSOCIADO
nTot = Reccount()

Scan All

   =Seek( ASSOCIADO.idContrato, 'CONTRATO', 'I_D' )
   If Seek(CONTRATO.idFilial, 'FILIAL', 'IDFILIAL' )
      If Filial.atend
         cCod = Alltrim( ASSOCIADO.codigo )
         lAtz = !Seek( cCod, 'BSPSQ', 'CODIGO' )
         If !lAtz
            lAtz = BSPSQ.situacao <> ASSOCIADO.situacao Or BSPSQ.Nome <> ASSOCIADO.Nome Or BSPSQ.atendimento <> ASSOCIADO.atendimento
         Endif
         If lAtz
            Scatter Name oReg
            Do BSPSQ_ATZ With oReg, 'ASSOCIADO'
         Endif
      Endif
   Endif
   Select ASSOCIADO

Endscan

lOk =Tableupdate(2,.T.,'BSPSQ')

IF lOk
   lOk = fi_AjustaSQL()
ENDIF 

RETURN lOK




FUNCTION fi_AjustaSQL()
Local cBS, cSQL, hConn
Local cNome, cEnd, cCompl, cBairro, cCid, cFant, cVer

nOk     = 0
cVer    = SYS(2015)
cBS     = Sys(2015)
cString = 'Driver=SQL Server;Server=192.168.0.7;UID=sa;PWD=medilar@fogo;Database=SIGAPH_NEW'
hConn   = Sqlstringconnect(cString)

If hConn < 0
   RETURN .f.
Endif

*-- apaga os que estao na base SQL e nao estao em CONTRATO/ASSOCIAO
*------------------------------------------------------------------
TEXT TO cSql TEXTMERGE NOSHOW
SELECT chv_filial,chv_tipo,chv_numero,chv_class,fantasia, I_D FROM BSPSQ WHERE chv_filial='17'
ENDTEXT 

IF SQLEXEC(hConn, cSql, cBS ) > 0
   SELECT (cBS)
   nTot = RECCOUNT()
   Scan All
      lDele = .F.

      If Seek(&cBS..chv_filial, 'FILIAL', 'IDFILIAL' )
         If !Filial.atend
            lDele = .T.
         Endif
      Endif

      If Empty(&cBS..fantasia)
         lDele = .T.
      Endif
      cCod = &cBS..chv_filial + &cBS..chv_tipo + &cBS..chv_numero + &cBS..chv_class
      If !lDele
         If &cBS..chv_class = 'CT'
            lDele = !Seek( cCod, 'CONTRATO',  'CODIGO' )
         Else
            lDele = !Seek( cCod, 'ASSOCIADO', 'CODIGO' )
         Endif
      Endif
      If lDele
         =SQLEXEC( hConn, 'Delete FROM BSPSQ WHERE I_D='+TRANSFORM(&cBS.i_d) )
      Endif

   ENDSCAN
   
ENDIF 

*-- seleciona informacoes da base de pesquisa DBF
Select * From BSPSQ WHERE chv_FILIAL IN ( '17' ) And !Deleted() Into Cursor (cBS)

IF _TALLY > 0
   =SQLEXEC( hConn, 'DELETE FROM BsPsq' )
ENDIF 

Scan All
   
   cFant   = ALLTRIM( Chrtran( FANTASIA,    ['], [ ] ) )
   cNome   = ALLTRIM( Chrtran( Nome,        ['], [ ] ) )
   cEnd    = ALLTRIM( Chrtran( ENDERECO,    ['], [ ] ) )
   cCompl  = ALLTRIM( Chrtran( COMPLEMENTO, ['], [ ] ) )
   cBairro = ALLTRIM( Chrtran( BAIRRO,      ['], [ ] ) )
   cCid    = ALLTRIM( Chrtran( CIDADE,      ['], [ ] ) )
   
   =SQLEXEC(hConn, 'SELECT I_D FROM BSPSQ WHERE I_D='+TRANSFORM(I_D), cVer )
   IF USED(cVer) AND RECCOUNT()=0
      *-- ira incluir o novo registro
      lInc = .t.
   ELSE
      *-- ira alteraro novo registro
      lInc = .f.
   ENDIF 
   
   SELECT (cBS)
   IF lInc
      TEXT TO cSql TEXTMERGE NOSHOW
         INSERT INTO BSPSQ
           (CHV_FILIAL,  CHV_TIPO,   CHV_NUMERO,      CHV_CLASS,   FANTASIA,   TIPO_CONTRATO, SITUACAO,      DTCANC,
            DATABASE_,   NOME,       ENDERECO,        COMPLEMENTO, BAIRRO,     CEP,           CIDADE,        UF,
            PERTO_DE,    ENTRE_RUAS, DATA_NASCIMENTO, SEXO,        CPF,        RG,            CODIGO_ANTIGO, CODORIGEM,
            ATENDIMENTO, FICHA,      CPD,             INICIAIS,    IDCONTRATO, IDASSOC,       I_D )
         VALUES
           ('<<CHV_FILIAL>>',
            '<<CHV_TIPO>>',
            '<<CHV_NUMERO>>',
            '<<CHV_CLASS>>',
            '<<semAcento(cFant)>>',
            '<<ALLTRIM(TIPO_CONTRATO)>>',
            '<<ALLTRIM(SITUACAO)>>',
            '<<IIF(!EMPTY(DTCANC),  TRANSFORM(DTOS(DTCANC),  "@R 9999-99-99"),'')>>',
            '<<IIF(!EMPTY(DATABASE),TRANSFORM(DTOS(DATABASE),"@R 9999-99-99"),'')>>',
            '<<semAcento(cNome)>>',
            '<<semAcento(cEnd)>>',
            '<<semAcento(cCompl)>>',
            '<<semAcento(cBairro)>>',
            '<<CEP>>',
            '<<semAcento(cCid)>>',
            '<<UF>>',
            '<<ALLTRIM(PERTO_DE)>>',
            '<<ALLTRIM(ENTRE_RUAS)>>',
            '<<IIF(!EMPTY(DATA_NASCIMENTO),TRANSFORM(DTOS(DATA_NASCIMENTO),"@R 9999-99-99"),'')>>',
            '<<ALLTRIM(SEXO)>>',
            '<<CHRTRAN(CPF,['],[])>>',
            '<<CHRTRAN(RG,['],[])>>',
            '<<ALLTRIM(CODIGO_ANTIGO)>>',
            '<<ALLTRIM(CODORIGEM)>>',
            <<IIF(ATENDIMENTO,1,0)>>,
            '<<ALLTRIM(FICHA)>>',
            '<<ALLTRIM(CPD)>>',
            '<<ALLTRIM(INICIAIS)>>',
            <<IDCONTRATO>>,
            <<IDASSOC>>,
            <<I_D>> )

      ENDTEXT
   ELSE
      TEXT TO cSql TEXTMERGE NOSHOW
         UPDATE BSPSQ 
            SET CHV_FILIAL='<<CHV_FILIAL>>',  
                CHV_TIPO='<<CHV_TIPO>>',   
                CHV_NUMERO='<<CHV_NUMERO>>',      
                CHV_CLASS='<<CHV_CLASS>>',   
                FANTASIA'<<semAcento(cFant)>>',   
                TIPO_CONTRATO='<<ALLTRIM(TIPO_CONTRATO)>>', 
                SITUACAO='<<ALLTRIM(SITUACAO)>>',      
                DTCANC='<<IIF(!EMPTY(DTCANC),  TRANSFORM(DTOS(DTCANC),  "@R 9999-99-99"),'')>>',
                DATABASE_='<<IIF(!EMPTY(DATABASE),TRANSFORM(DTOS(DATABASE),"@R 9999-99-99"),'')>>',   
                NOME='<<semAcento(cNome)>>',       
                ENDERECO='<<semAcento(cEnd)>>',        
                COMPLEMENTO='<<semAcento(cCompl)>>', 
                BAIRRO='<<semAcento(cBairro)>>',     
                CEP='<<CEP>>',           
                CIDADE='<<semAcento(cCid)>>',        
                UF='<<UF>>',
                PERTO_DE='<<ALLTRIM(PERTO_DE)>>',    
                ENTRE_RUAS='<<ALLTRIM(ENTRE_RUAS)>>', 
                DATA_NASCIMENTO='<<IIF(!EMPTY(DATA_NASCIMENTO),TRANSFORM(DTOS(DATA_NASCIMENTO),"@R 9999-99-99"),'')>>', 
                SEXO='<<ALLTRIM(SEXO)>>',        
                CPF='<<CHRTRAN(CPF,['],[])>>',        
                RG='<<CHRTRAN(RG,['],[])>>',            
                CODIGO_ANTIGO='<<ALLTRIM(CODIGO_ANTIGO)>>', 
                CODORIGEM='<<ALLTRIM(CODORIGEM)>>',
                ATENDIMENTO=<<IIF(ATENDIMENTO,1,0)>>, 
                FICHA='<<ALLTRIM(FICHA)>>',      
                CPD='<<ALLTRIM(CPD)>>',             
                INICIAIS='<<ALLTRIM(INICIAIS)>>',    
                IDCONTRATO=<<IDCONTRATO>>, 
                IDASSOC=<<IDASSOC>>,       
          WHERE I_D=<<I_D>>
      ENDTEXT
   ENDIF 

   nOk = SQLExec( hConn, cSQL ) 
   If nOk < 0
      Exit
   Endif

Endscan

USE IN (SELECT(cVer))

=SQLDisconnect(hConn)
Use In (Select(cBS))
RETURN nOk>=0
