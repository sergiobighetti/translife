#INCLUDE "c:\desenv\win\vfp9\libbase\ftp.h"
#Define ACAO_INCLUSAO  1
#Define ACAO_ALTERACAO 2
#Define ACAO_EXCLUSAO  3
#DEFINE __CONS_CONTRATO  69359   &&-- ID DO CONTRATO DO SASSOM

Local lcPom,loFTP, cUltImportado, lOk , nK, cFileNaFtp,nDown
Local Array laFiles(1),laFile(1)
Private cArqINTERCOR


cDirDestino = '\\dcrpo\bdmem\robo\SASSOM\'
*cDirDestino = 'c:\desenv\win\vfp9\sca_new\TST\'

cArqINTERCOR  = cDirDestino+'INTERCORRENCIA.LOG'
lcPom         = ''

cImportados = ''
If File( cDirDestino+'IMPORTADOS.VER' )
   cImportados = Filetostr(cDirDestino+'IMPORTADOS.VER' )
Endif

Clear

Set Procedure To ftp.prg Additive

loFTP         = Createobject('FTP_SERVICE')

*--------------------- usuario   senha        endereco          porta
If loFTP.OpenInternet("medicar", "swfn8v","189.112.129.1", "21" )

   * Lista de nomes de arquivos disponiveis para importação
   lOk = loFTP.NLST( @laFiles, "", _FTPS_RWF_Array, 0 )
  
   nDown = 0
   
   If lOk
     
      For nK=1 To 1 &&-- Alen(laFiles)

         *-- captura informações sobre cada arquivo
         loFTP.GetFTPDirectoryArray( @laFile, laFiles(nK), 0 )

         cFileNaFtp = 'medicar.txt' &&--laFile[1,1]

         If Type( 'cFileNaFtp' ) = 'C'
  
            =Strtofile( Transform(Datetime())+ " - Download: "+ cFileNaFtp+Chr(13)+Chr(10), cArqINTERCOR, 1 )

            *-- copia o arquivo (ORIGEM, DESTINO         )
            If !loFTP.GetFTPFile( cFileNaFtp, cDirDestino+cFileNaFtp )
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

            ELSE
               *-- se o arquivo foi copiado, alimenta a matriz
               nDown = nDown + 1 
               LOCAL aDown[nDown]
               aDown[nDown] = cFileNaFtp
               
               =Strtofile( cFileNaFtp+'|', cDirDestino+'IMPORTADOS.VER', 1 )
               
            ENDIF 

         Endif

      Next

***************** ///////////////////////////////////////////////////////////
If nDown>=1   &&... se conseguiu abrir as tabelas

   For nDown=1 To Alen(aDown,1)

      cFileNaFtp = aDown[nDown]

      nContrato = __CONS_CONTRATO  && contrato do SASSON

      If FI_mdc_AbreTabelas()
         cErr = ''
         Try
            *-- transforma o arquivo texto importado para um CURSOR
            =fi_TXTtoALS_SASSOM( cDirDestino+cFileNaFtp, 'LV_ORIGEM' )
            
            RENAME (cDirDestino+cFileNaFtp) TO (cDirDestino+"SASSOM_"+DTOS(DATE())+'.TXT')
            
         Catch To loError

            Set Textmerge To Memvar cErr Noshow
            Set Textmerge On
               \---> <<DATETIME()>>
               \     - Falha na conversao do TXT p/ CURSOR (fi_TXTtoALS_SASSOM())
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
               =fi_ajt_Cursor_SASSOM( 'LV_ORIGEM', nContrato, 0 )

            Catch To loError

               Set Textmerge To Memvar cErr Noshow
               Set Textmerge On
                        \---> <<DATETIME()>>
                        \     - Falha ao fazer o ajuste no cursor (fi_ajt_Cursor_SASSOM())
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
               cArqLog = FI_Proc_SASSOM( 'LV_ORIGEM', nContrato )
               If !Empty(cArqLog)
                  Select (cArqLog)
                  Copy To (cDirDestino+ Forceext(Juststem(cFileNaFtp)+'_LOG','XLS')) Type Xls For Not Deleted()
               Endif

            Catch To loError

               Set Textmerge To Memvar cErr Noshow
               Set Textmerge On
                        \---> <<DATETIME()>>
                        \     - Falha ao processar o arquivo (FI_Proc_SASSOM())
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
         =WriteFileIni(cDirDestino+'Status.INI','DOWNLOAD','UltimoArquivoImportado_SASSON',cFileNaFtp+' em '+TRANSFORM(DATETIME()) )
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

   Next

   Close Databases All
   Close Tables All
   If FI_mdc_AbreTabelas()     
      =fi_ACT_BSPSQ()
   ENDIF 
   Close Databases All
   Close Tables All

ENDIF

***************** ///////////////////////////////////////////////////////////
   ENDIF

   =loFTP.CloseInternet()

Else
   TEXT TO cErr TEXTMERGE NOSHOW
---> <<DATETIME()>>
     - Falha na tentativa de coneção com a FTP (Endereço: ftp.coderp.com.br Porta 21)

   ENDTEXT
   =Strtofile( cErr, cArqINTERCOR, 1 )

Endif
Release Procedure ftp.prg

Close Databases All
Clear Events
QUIT 

Return


**********************************************************
Function FI_Proc_SASSOM( cOrg, nContrato )
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
               *--- FI_GravaLog( &cOrg..codigoTIT, "INC: TITULAR JA CADASTRADO", cOrg  )
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
                  *--- FI_GravaLog( &cOrg..codigoDEP, "INC: DEPENDENTE JA CADASTRADO", cOrg  )
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
cPlano = '2,18,19'

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
Function fi_ajt_Cursor_SASSOM( cOrg, nContrato, nVlr )
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
Function fi_TXTtoALS_SASSOM( cArqTXT, cCursor )
* Transforma <cArqTxt> em um cursor temporario (<cCursor>)
* ---------------------------------------------------------
LOCAL cLin, nCol, aCol[1], cEstCivil, cCodTit, cCodDep

Create Cursor (cCursor) ;
   ( TIPO       C( 1),;
     NOME       C(40),;
     ENDERECO   C(40),;
     COMPLE     C(40),;
     BAIRRO     C(20),;
     CEP        C(10),;
     CIDADE     C(20),;
     ESTADO     C( 2),;
     FONE_RES   C(20),;
     FONE_COM   C(20),;
     PERTO_DE   C(40),;
     ENTRE_RUA  C(40),;
     DT_NASCIME C( 8),;
     SEXO       C( 9),;
     CIVIL      C(11),;
     CPF        C(14),;
     RG         C(18),;
     CODIGOTIT  C(20),;
     CODIGODEP  C(20),;
     ATEND      N( 1),;
     ACAO       N( 1),;
     DATABASE   C( 8),;
     APH        C(90),;
     VALOR      Y,;
     idTIT      I,;
     idDEP      I )

SELECT (cCursor)
Append From (cArqTXT) Sdf

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
Function FI_mdc_AbreTabelas()
***********************************************
Local cDirTAB, lOk, cLstTabelas, nQtd, i, aArq[1]

Close Databases All
Close Tables All

lOk         = .F.
cLstTabelas = 'CONTRATO;ASSOCIADO;ASSOCIADO_PLANO;FILIAL_CHAVES;FILIAL;BSPSQ'
cDirTAB     = ReadFileIni(cDirDestino+'Status.INI','DIRETORIO','Tabelas_SASSON') && 'c:\desenv\win\vfp9\mdl\'

SET MULTILOCKS ON

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
       \     - Falha na abertura dos arquivos (FI_mdc_AbreTabelas())
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
FUNCTION fi_ACT_BSPSQ()
******************************************************************************************************************
Local cCod, oReg, lDele, lAtz, nTot

Select BSPSQ
Go Top
nTot = Reccount()

Scan FOR BSPSQ.idcontrato = __CONS_CONTRATO

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

Scan FOR CONTRATO.idcontrato = __CONS_CONTRATO

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

Scan FOR ASSOCIADO.idcontrato = __CONS_CONTRATO

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

RETURN lOK




