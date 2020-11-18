#Define ID_ATEND_ALO_DR  1236

_SCREEN.VISIBLE     = .f.
_Screen.WindowState = 2

? 'Exportação para MEDICAR'

CLEAR MEMORY
CLEAR ALL
LOCAL lnCnt, lnHwnd, lcNewDir, lwStartUp,  lnNameLength, gnFileHandle, nSize, cString
LOCAL cVersao, lcBuffer, cCaption, nAt, nRat, cStr, i
LOCAL ARRAY laVFPBars(13)
PUBLIC drvDiretorio, drvWindowsDir, oErr, drvTmpPath, drvIpLocal, drvRefGlobal

SET TALK OFF
SET DEBUG OFF
SET ESCAPE OFF
SET RESOURCE OFF
SET RESOURCE TO
SET DATE BRITISH 

lcNewDir = JUSTPATH( SYS(16,0) )
m.drvDiretorio = lcNewDir
CD (lcNewDir)
SET DEFAULT TO (lcNewDir)

CLOSE TABLES   ALL
CLOSE DATABASES ALL


* \\10.0.0.253
m.drvDiretorio = '\\10.0.0.253'
SET PATH TO (lcNewDir) 
SET PATH TO '\\10.0.0.253\BDMEM'      ADDITIVE 
SET PATH TO '\\10.0.0.253\BDMDC$'     ADDITIVE 
SET PROCEDURE TO ..\LIBBASE\LIBROTINA.PRG 

SET BELL OFF
SET EXACT OFF
SET CONFIRM ON
SET DECIMALS TO
SET DELETED ON
SET EXCLUSIVE OFF
SET MULTILOCKS ON
SET NOTIFY OFF
SET REPROCESS TO AUTOMATIC
SET SAFETY OFF
SET SYSFORMATS ON
SET TALK OFF
SET ENGINEBEHAVIOR 70 
SET FUNCTION  1 TO && F1 ayuda
SET STATUS BAR OFF
SET SYSMENU AUTOMATIC
SET SYSMENU TO
   
lErr = .f.   
TRY 
  OPEN DATABASE bdmdc SHARED
CATCH
  _SCREEN.VISIBLE  = .t.
   MESSAGEBOX( 'FALHA NA ABERTURA DO BANCO DE DADOS DA MEDICAR "bdmdc"', 16, 'Atenção' )
  _SCREEN.VISIBLE  = .f.
   lErr = .t.   
ENDTRY
  
TRY 

   USE ATENDIMENTO IN 0
   =CURSORSETPROP("Buffering",1,'ATENDIMENTO')
   
   USE LV_EVENTO   IN 0 NODATA 
   =CURSORSETPROP("Buffering",5,'LV_EVENTO')

CATCH
   _SCREEN.VISIBLE  = .t.
   MESSAGEBOX( 'FALHA NA ABERTURA DE LV_EVENTO',16,'Atenção')
   _SCREEN.VISIBLE  = .f.
   lErr = .t.   
ENDTRY

IF NOT lErr

TRY 
   DO IMPORTA_DO_ALODR
CATCH TO oErr 
   _SCREEN.VISIBLE  = .t.
    cErr = ''
    cErr = cErr +CHR(13)+[  Error: ] + STR(oErr.ErrorNo) 
    cErr = cErr +CHR(13)+[  LineNo: ] + STR(oErr.LineNo) 
    cErr = cErr +CHR(13)+[  Message: ] + oErr.Message 
    cErr = cErr +CHR(13)+[  Procedure: ] + oErr.Procedure 
    cErr = cErr +CHR(13)+[  Details: ] + oErr.Details 
    cErr = cErr +CHR(13)+[  StackLevel: ] + STR(oErr.StackLevel) 
    cErr = cErr +CHR(13)+[  LineContents: ] + oErr.LineContents
    cErr = cErr +CHR(13)+[  UserValue: ] + oErr.UserValue 
    MESSAGEBOX(cErr,16,'Atenção')
   _SCREEN.VISIBLE  = .f.
ENDTRY
ENDIF 

SET ENGINEBEHAVIOR 90

CLOSE TABLES   ALL
CLOSE DATABASES ALL
CLEAR DLLS
CLEAR ALL
CLOSE ALL
CLEAR MEMORY 
CLEAR ALL
RELEASE ALL EXTENDED
QUIT

READ EVENTS





*--------------------------------------------------------------------------------------------
#define DF_PRODUTO_MEDICAR_MAIS 3

PROCEDURE IMPORTA_DO_ALODR

Local cArqTXT, cTmp, nCodReg
Public oReg, drvNomeUsuario, drvID


cArqTXT = LOCFILE('DadosAPH.txt')
IF EMPTY(cArqTXT)
   RETURN
ENDIF

cTmp    = Sys(2015)

Create Cursor (cTmp) ;
   ( ;
   I_D             C(15),;
   CODIGO          C(15),;
   ENDERECO        C(40),;
   COMPLEMENTO     C(40),;
   BAIRRO          C(20),;
   CIDADE          C(20),;
   REFERENCIA      C(80),;
   NomeSolicitante C(40),;
   FoneSolicitante C(20),;
   Classificacao   C(10),;
   Sintomas        C(200),;
   DataHoraAtend   C(19),;
   NomeRegulador   C(60))

Append From (cArqTXT) Delimited With Tab

Select (cTmp)

nCodReg          = Int( VAL( Strextract( &cTmp..NomeRegulador, '#', '#' ) ) )
cChv             = ALLTRIM(&cTmp..codigo)

m.drvNomeUsuario = 'ALODR'

Select LV_EVENTO
Scatter Name oReg Memo Blank Fields Except Id

oReg.IDFILIAL          = Left(&cTmp..CODIGO,2)
oReg.idfilial_atend    = Left(&cTmp..CODIGO,2) 
oReg.PACCODIGO         = &cTmp..CODIGO
oReg.CODATENDIMENTO    = 1
oReg.VALORCOBRANCA     = 0
oReg.PACENDERECO       = &cTmp..ENDERECO
oReg.PACCOMPLEMENTO    = &cTmp..COMPLEMENTO
oReg.PACBAIRRO         = &cTmp..BAIRRO
oReg.PACCIDADE         = &cTmp..CIDADE
oReg.PACREFERENCIA     = &cTmp..REFERENCIA
oReg.SOLNOME           = &cTmp..NomeSolicitante
oReg.SOLFONE           = &cTmp..FoneSolicitante
oReg.IDSINTOMAS1       = 3 && outros
oReg.OUTROSSINTOMAS    = "VER OBSERVACAO DO REGULADOR"
oReg.ATECLASSIFICACAO  = &cTmp..Classificacao
oReg.ATEOBSERVACAO     = 'ORIGEM: Alô Dr: <'+ ALLTRIM(&cTmp..I_D) +'>'
oReg.REGCLASSIFICACAO  = &cTmp..Classificacao
oReg.REGOBSERVACAO     = &cTmp..Sintomas
oReg.TM_CHAMA          = Ctot( &cTmp..DataHoraAtend )
oReg.TM_TARME          = Substr( &cTmp..DataHoraAtend,12,5)
oReg.TM_REGUL          = Substr( &cTmp..DataHoraAtend,12,5)
oReg.IDATENDENTE       = ID_ATEND_ALO_DR
oReg.IDREGULADOR       = nCodReg
oReg.SITUACAO          = 1 && em aberto
oReg.LIBERACAO         = 2 && liberado
oReg.AUDITORIA         = GrvAuditoria( oReg.AUDITORIA, 'I' )
oReg.KEYOLD            = '<AD>'+ALLT(&cTmp..I_D)+'</AD>'
cKeyOLD = oReg.KEYOLD


Select           tt.IDASSOC, tt.SITUACAO, tt.Nome, tt.data_nascimento, tt.sexo, tt.fone_residencia,;
                 tt.fone_comercial, tt.rg, tt.ENDERECO, tt.COMPLEMENTO, tt.BAIRRO, tt.CIDADE, tt.perto_de,;
                 tt.entre_ruas, tt.dataCancela, tt.dataExc, tt.motivocancel, tt.observacao, tt.ATENDIMENTO,;
                 tt.Database DataBase_ASSOC, tt.orientacao As OriBENE, tt.CODIGO COD_ASSOC,;
                 ;
                 tt.idEmpresa, Nvl(ee.cnpj,Space(14)) EMPR_CNPJ, Nvl(ee.NomeEmpresa, Space(40)) EMPR_NOME,;
                 nvl(ee.orientacao,"") EMPR_ORIENTACAO,;
                 ;
                 cc.idContrato As idContrato, cc.nome_responsavel As CTRRESPONSAVEL, cc.orientacao As OriCONTR,;
                 cc.CODIGO COD_CONTRATO, cc.tipo_contrato As CtrTipoContrato, cc.Classificacao As CTRCLASSIFICACAO,;
                 cc.Database DataBase_CTR, ;
                 ;
                 NVL(rc.transp_mes,00) transp_mes,;  && transporte monitorado (MES)
                 Nvl(rc.transp_vlr,$0) transp_vlr,;  && transporte monitorado (VALOR)
                 ;
                 iif( cc.regulacao,[SIM],[NÃO]) As CtrRegulacao, cc.NroVidas, ;
                 iif( Empty(Nvl(gg.FM_VIGENCIA,{//})), "NÃO", "SIM") As TemREGRAS ;
                 ;
from             BDMDC!ASSOCIADO tt ;
INNER Join       BDMDC!CONTRATO cc           On cc.idContrato = tt.idContrato ;
left Outer Join  rcontrat       rc           On rc.idContrato = tt.idContrato ;
left Outer Join  BDMDC!CONTRATO_GARANTIAS gg On cc.idContrato = gg.idContrato ;
left Outer Join  BDMDC!EMPRESA ee            On tt.idEmpresa = ee.idEmpresa ;
where            tt.CODIGO = cChv ;
into Cursor      CASSOC

If _Tally > 0   && ENCONTROU COMO DEPENDENTE
   oReg.CTRNUMERO = CASSOC.idContrato

   cTipoAssoc      = Substr( cChv, 11,2)
   lTemAtendimento = CASSOC.ATENDIMENTO

   oReg.obsatendimento = 'ALO DR: #'+ ALLT( &cTmp..I_D ) +'#'+CHR(13)
   If !Empty( CASSOC.OriCONTR )
      oReg.obsatendimento = "ORIENTAÇÃO DO CONTRATO: " +Chr(13)+ CASSOC.OriCONTR + Chr(13)
   Endif

   If !Empty(CASSOC.EMPR_ORIENTACAO)
      oReg.obsatendimento = oReg.obsatendimento + "ORIENTAÇÃO DA EMPRESA: " +Chr(13) +Alltrim(CASSOC.EMPR_ORIENTACAO) +Chr(13)
   Endif

   If !Empty( CASSOC.OriBENE )
      oReg.obsatendimento = oReg.obsatendimento + "ORIENTAÇÃO DO ASSOCIADO: " +Chr(13) +CASSOC.OriBENE +Chr(13)
   Endif

   oReg.PACNASC = CASSOC.data_nascimento
   oReg.IDASSOC = CASSOC.IDASSOC

   cSit = CASSOC.SITUACAO

   oReg.pacsituacao = CASSOC.SITUACAO

   oReg.pacfone        = CASSOC.fone_residencia
   oReg.pacnome        = CASSOC.Nome
   oReg.pacrg          = CASSOC.rg
   oReg.pacidade       = calcIdade( CASSOC.data_nascimento,Date(),'EXTENSOR' )
   oReg.pacsexo        = CASSOC.sexo
   oReg.ctrtipo        = CASSOC.CtrTipoContrato
   oReg.ctrdatabase    = CASSOC.DataBase_CTR
   oReg.CTRRESPONSAVEL = CASSOC.CTRRESPONSAVEL

   oReg.pacinformacoes   = ''
   oReg.CTRCLASSIFICACAO = CASSOC.CTRCLASSIFICACAO
   oReg.ctrnumerovidas   = CASSOC.NroVidas

   if cTipoAssoc # "CT"
      =SEEK( left(cChv,10)+'00', 'ASSOCIADO', 'CODIGO' )
      oReg.titcodigo  =  alltrim(ASSOCIADO.Codigo)
      oReg.titnome    = ASSOCIADO.nome
      oReg.titempresa = alltrim(ASSOCIADO.endereco) +[ ] +;
                        alltrim(ASSOCIADO.complemento) +[, ]+;
                        alltrim(ASSOCIADO.bairro) +[, ]+;
                        alltrim(ASSOCIADO.cidade)
      oReg.titempresa = CASSOC.EMPR_CNPJ
   endif

   cVar = []

   Select      pd.idplano As CodPlano, pm.descricao As NomePlano, pm.cor, pm.CodTipAtendimento ;
   from        ASSOCIADO_PLANO pd ;
   INNER Join  PLANOS pm On pm.plano = pd.idplano ;
   where       pd.IDASSOC == CASSOC.IDASSOC ;
   into Cursor CLV_DADOS_TMP
   
   cTemRegras = 'NAO'
   
   If _Tally > 0
      If !Empty(cVar)
         cVar = cVar + Chr(13)+ [------------------------------] + Chr(13)
      Endif
      cPrd = ''
      cVar = cVar + [PRODUTO(s): ]+Chr(13)
      Scan All
         If CLV_DADOS_TMP.CodPlano == DF_PRODUTO_MEDICAR_MAIS And CASSOC.TemREGRAS = 'SIM'
            cTemRegras = "SIM"
         Endif
         oReg.CODATENDIMENTO = CLV_DADOS_TMP.CodTipAtendimento
         cVar = cVar + Proper( Alltrim( CLV_DADOS_TMP.NomePlano ) )+[, ]
         cPrd = cPrd + ","+Transform(CLV_DADOS_TMP.CodPlano )
      Endscan
      cPrd = Substr(cPrd,2)
      If Fsize( 'PRODUTOS', 'LV_EVENTO' ) > 0
         Replace oReg.PRODUTOS With cPrd
      Endif
   Endif

   oReg.ctrregras = cTemRegras
   oReg.ctrregmedica = CASSOC.CtrRegulacao

   Select      ac.descricao ;
   from        ASSOCIADO_ACLINICO aa ;
   INNER Join  ANTCLINICO ac On ac.Id = aa.idAntClinico ;
   where       aa.IDASSOC == CASSOC.IDASSOC ;
   into Cursor CLV_DADOS_TMP

   If _Tally > 0
      If !Empty(cVar)
         cVar = cVar + Chr(13)+ [------------------------------] + Chr(13)
      Endif
      cVar = cVar + [ANTECEDENTES CLINICOS: ]+Chr(13)
      Scan All
         cVar = cVar + Proper( Alltrim( CLV_DADOS_TMP.descricao ) )+[, ]
      Endscan
   Endif

   oReg.pacinformacoes = cVar

   cVar = []
   Select     bb.descricao ;
   from       ASSOCIADO_HOSPITAL aa ;
   INNER Join HOSPITAL bb On bb.HOSPITAL = aa.idhospital ;
   where      aa.IDASSOC == CASSOC.IDASSOC ;
   into Cursor CLV_DADOS_TMP

   If _Tally > 0
      cVar = cVar + [HOSPITAL(ais):]+Chr(13)
      Scan All
         cVar = cVar + Proper( Alltrim( CLV_DADOS_TMP.descricao ) )+[, ]
      Endscan
   Endif

   Select      bb.descricao ;
   from        ASSOCIADO_PSAUDE aa ;
   INNER Join  PLANOSAUDE bb On bb.PLANOSAUDE = aa.idPlanoSaude ;
   where       aa.IDASSOC == CASSOC.IDASSOC ;
   into Cursor CLV_DADOS_TMP

   If _Tally > 0
      If !Empty(cVar)
         cVar = cVar + Chr(13)+ [------------------------------] + Chr(13)
      Endif
      cVar = cVar + [PLANO(s) DE SAÚDE:]+Chr(13)
      Scan All
         cVar = cVar + Proper( Alltrim( CLV_DADOS_TMP.descricao ) )+[, ]
      Endscan
   Endif
   oReg.pacpreferencia = cVar

   fi_VerFinanc( CASSOC.idContrato )

   *-- verifica o FATOR MODERADOR
   IF fi_FM( CASSOC.idContrato )
      *-- qdo tem FATOR MODERADOR nao tem CUSTO OPERACIONAL
   ELSE
      *-- verifica o CUSTO OPERACIONAL
      IF fi_cop( cChv )
      ENDIF 
   ENDIF

Endif

cVerOLD = SYS(2015)
lAdd    = .t.
SELECT id  FROM ATENDIMENTO WHERE pacCodigo = cChv AND keyOld = cKeyOld INTO CURSOR (cVerOLD)
IF _TALLY > 0
   m.drvID = &cVerOLD..id
   SELECT ATENDIMENTO
   =CURSORSETPROP("Buffering",5,'ATENDIMENTO')
   BEGIN TRANSACTION 
   IF SEEK(m.drvID,'ATENDIMENTO', 'SEQUENCIA' )
      GATHER NAME oReg MEMO
   ELSE
      Select LV_EVENTO
      =REQUERY('LV_EVENTO')   
      GATHER NAME oReg MEMO
   ENDIF
ELSE
   BEGIN TRANSACTION 
   Select LV_EVENTO
   APPEND BLANK
   GATHER NAME oReg MEMO
ENDIF
   
GO TOP


lOK = TABLEUPDATE(.t.)

IF lOK
   END TRANSACTION 
ELSE
   ROLLBACK 

   _SCREEN.VISIBLE  = .t.
   MESSAGEBOX( 'FALHA NA ATUALIZAÇÃO DO ATENDIMENTO',16,'Atenção',3000)
   _SCREEN.VISIBLE  = .f.
   
ENDIF 

FLUSH 
UNLOCK ALL 

CLEAR EVENTS 

return



*  ////////////////////////////////////////////////////
Function fi_VerFinanc
*  ////////////////////////////////////////////////////
Lparameters nKey

   Local dHj
   Local aTmp[1]

   dHj  = Date()

   Select     Sum( Iif(ARECEBER.origem="S.A.M.D", 1, 0 ) ) QTD_SAMD,;
              COUNT(*) QTD_GERAL ;
   FROM       ARECEBER ;
   WHERE      ARECEBER.idContrato == nKey And ;
              ARECEBER.SITUACAO = 'ABERTO' And  (dHj-ARECEBER.data_Vencimento) > 10 ;
   INTO Array aTmp

   If _Tally > 0 And aTmp[2] > 0
      oReg.ctrfinanceiro = Tran( aTmp[2] ) + ' parcela(s) em aberto'
   Else
      oReg.ctrfinanceiro = ''
   Endif

   Release aTmp

ENDFUNC 


*  ////////////////////////////////////////////////////
FUNCTION FI_FM
*  ////////////////////////////////////////////////////
Lparameters nIDC
*-- fator moderador

Local cCCOP, nSele, dINI, dFIM, cAls, cVQT, cClassif, cMsg, oMsgDestaque, nVlr, lRtn

lRtn  = .f.
nSele = Select()
cCCOP = Sys(2015)

*-- verifica a existencia de FATOR MODERADOR
Select      qtdatend, tipo, classificacao, valorcob, dtinicio ;
FROM        CONTRATO_FM ;
WHERE       idcontrato = nIDC ;
INTO Cursor (cCCOP)

If _Tally > 0 &&-- existe FATOR MODERADOR
   
   ** FIXA O CODIGO 16 (MEDICAR FATOR MODERADOR APH) COMO CODIGO DE TIPO DE ATENDIMENTO         
   oReg.CodAtendimento  = 16  && codigo de atendimento
  
   nVlr = &cCCOP..valorcob
   dFIM = oReg.tm_chama
  
   If &cCCOP..tipo = 'MENSAL'
      dIni = DATE( YEAR(dFIM),MONTH(dFim),DAY(&cCCOP..dtInicio))
   Else
      dIni = DATE( YEAR(dFIM)-1,MONTH(dFim),DAY(&cCCOP..dtInicio))
   Endif

   *-- data de referencia menos 1 mes
   IF dINI > TTOD(oReg.tm_chama)
      If &cCCOP..tipo = 'MENSAL'
         dINI = GOMONTH( dINI,  -1 ) + 1
      ELSE
         dINI = GOMONTH( dINI, -12 ) + 1
      ENDIF
   ENDIF
   
   dIni = DTOT(dINI)

   *--- verifica o historico de atendimentos do contrato
   cAls = FI_HistAtend( nIDC, Datetime(), 'WZREG' )

   If Reccount( cAls ) > 0 &&-- se possui atendimentos anteriores

      cVQT     = Sys(2015)
      cClassif = Alltrim( &cCCOP..classificacao )

      *-- verifica a QUANTIDADE DE ATENDIMENTO que possuem a classificacao especificada no contrato
      *-- e que estejam dentro do periodo para apuracao
      *-- que tenha codigo de atendimento 1 APH
      
      Select      COUNT(*) QUANT ;
      FROM        (cAls) ;
      WHERE       Alltrim(Clas_Med) $ cClassif ;
              And DataEvento Between dINI And dFIM ;
              AND CodAtend = 16 ;
      INTO Cursor (cVQT)

      *-- se a quantidade encontrada MAIOR que a especificada no contrato
      If &cVQT..QUANT >= &cCCOP..qtdatend
         oReg.valorcobranca = nVlr
         oReg.formarec      = 5
      Endif

      Use In ( Select( cVQT ) )

   Endif

   Use In ( Select( cAls ) )

   lRtn = .t.

Endif

Use In ( Select( cCCOP ) )

Select (nSele)

RETURN lRtn



*  ////////////////////////////////////////////////////
FUNCTION FI_COP
*  ////////////////////////////////////////////////////
Lparameters cCod
*-- parametro é o codigo do associado

*-- Custo Operacional
Local cVer, cCodR, nSel, dRef, nValor, nQtdAtend, cAls, cTipoAtend, cTp, lRtn, nIDC, cNAP, cNAP_COD
Local cDataRef, i, cRegra, cDe, cAte, cVlr

lRtn = .f.
nSel = Select()
cVer = Sys(2015)

IF SEEK( cCod, 'ASSOCIADO', 'CODIGO' )
   nIDC = ASSOCIADO.idContrato
   =SEEK( ASSOCIADO.idContrato, 'CONTRATO', 'I_D' )
   cTp = 'A'
ELSE   
   =SEEK( cCod, 'CONTRATO', 'CODIGO' )
   nIDC = ASSOCIADO.idContrato
   cTp = 'C'
ENDIF   

*-- verifica se o contrato tem regra para custo operacional
Select aa.* From CONTRATO_COP aa Where aa.idContrato = nIDC Into Cursor (cVer)

If _Tally > 0

   lRtn = .t.
   
   IF cTp = 'C' &&-- se é um codigo de contrato
      ** FIXA O CODIGO 17 (MEDICAR CUSTO OPERACIONAL APH) COMO CODIGO DE TIPO DE ATENDIMENTO         
      oReg.CodAtendimento = 17  && codigo de atendimento
      oReg.formarec       = 5   && cobrado no faturamento
   ENDIF

   cTipoAtend = UPPER(ALLTRIM(&cVer..tipoatend))
   cDataRef   = UPPER(ALLTRIM(&cVer..dtref))
   cTXT       = &cVer..regra

   *-- nivel de apuracao
   cNAP = &cVer..nivel_apuracao
   cNAP_COD = IIF(&cVer..nivel_apuracao='CONTRATO', nIDC,;
              IIF(&cVer..nivel_apuracao='TITULAR', LEFT(ALLTRIM(cCod),10)+'00', cCod ))
   
   *-- transforma o Texto da regra em TABELA
   Create Cursor (cVer) ( de C(3), ate C(3), vlr N(12,2) )
   For i = 1 To 100
      cRegra = Alltrim(Strextract( cTXT, '<REGRA>', '</REGRA>',i) )
      If Empty(cRegra)
         Exit
      Endif
      cDe    = Alltrim( Strextract( cRegra,  'DE:[', ']' ) )
      cAte   = Alltrim( Strextract( cRegra, 'ATE:[', ']' ) )
      cVlr   = Val(     Strextract( cRegra, 'VLR:[', ']' ) )
      Insert Into (cVer) Values ( cDe, cAte, cVlr )
      Go Top
   Endfor
   Go Top In (cVer)

  
   *-- pega a data de referencia
   *-- DIA VENCIMENTO,DATA BASE,DATAVIGOR,DATA CADASTRO,DATA INCLUSAO,DATA ATIVACAO
   Do Case
      Case cDataRef = 'DIA VENCIMENTO'
         dRef = Date( Year(oReg.tm_chama), Month(oReg.tm_Chama), CONTRATO.dia_Vencimento )
      Case cDataRef = 'DATA BASE'
         dRef = Iif( cTp='C', CONTRATO.Database, ASSOCIADO.Database )
      Case cDataRef = 'DATAVIGOR'
         dRef = Iif( cTp='C', CONTRATO.DataVigor, ASSOCIADO.DataVigor )
      Case cDataRef = 'DATA CADASTRO'
         dRef = Iif( cTp='C', Ttod(CONTRATO.cadastro), Ttod(ASSOCIADO.cadastro))
      Case cDataRef = 'DATA INCLUSAO'
         dRef = Iif( cTp='C', CONTRATO.Ativacao, ASSOCIADO.Ativacao )
      Case cDataRef = 'DATA ATIVACAO'
         dRef = Iif( cTp='C', CONTRATO.Ativacao, ASSOCIADO.Ativacao )
      Other
         dRef = {//}
   Endcase

   dRef = Dtot(dRef)
   IF !EMPTY(dRef)
  
      *-- data de referencia menos 1 mes
      IF dRef > TTOD(oReg.tm_Chama)
         dRef = GOMONTH( dRef, -1 ) + 1
      ENDIF

      *--- verifica o historico de atendimentos do contrato
      cAls = FI_HistAtend( cNAP_COD, Datetime(), 'WZREG' )

      Select (cAls)
      *--- conta a quantidade de ateimentes LIBERADOS, CLASSIFICADOS acima da dta de referencia
      Count For &cAls..DataEvento >= dRef             ; &&-- Data maior que a referencia
            And &cAls..situacao =    'Liber.'         ; &&-- liberado
            AND &cAls..CodAtend =    17               ; &&-- tp atend CUSTO OPERACIONAL
            And ALLTRIM(&cAls..Clas_Med) $ cTipoAtend ; &&-- que esteja dentro das classificacoes
         TO nQtdAtend

      Use In ( Select( cAls ) )
     
      nQtdAtend = nQtdAtend + 1 
      nValor = $0

      Select (cVer)
      Scan For Between( Padl(nQtdAtend,3,'0'), &cVer..de, &cVer..ate )
         nValor = &cVer..vlr
         Exit
      Endscan
      
      oReg.valorcobranca = nValor
      oReg.formarec      = 5

   Endif

   Use In (Select(cVer))

ENDIF 

Select (nSel)

RETURN lRtn






*  ////////////////////////////////////////////////////
FUNCTION FI_HistAtend
*  ////////////////////////////////////////////////////
LPARAM cCodMed, dRef, cDeOndeVem
LOCAL nPos, nSel, cWhe, cRunFORM, lUsaATD, lUsaHST, lUsaCTR, cCabec, cHst

CHST    = SYS(2015)
nSel    = SELECT()
cCabec  = [Histórico de Atendimento(s)]

IF !EMPTY( cCodMed )

   lUsaATD = USED( 'ATENDIMENTO' )
   lUsaHST = USED( 'HSTATEND' )
   lUsaCTR = USED( 'CONTRATO' )

   IF NOT lUsaATD
      USE ATENDIMENTO IN 0
   ENDIF
   IF NOT lUsaHST
      USE HSTATEND IN 0
   ENDIF
   IF NOT lUsaCTR
      USE CONTRATO IN 0
   ENDIF

   cDeOndeVem = IIF( TYPE( 'cDeOndeVem' )='C', cDeOndeVem, 'CADASTRO' )
   
   IF TYPE( 'dRef' ) = 'D'
      dRef = DATETIME( YEAR(dRef), MONTH(dRef), DAY(dRef), 23, 23, 59 )
   ENDIF

   IF TYPE( 'cCodMed')= 'N'
      cWhe = 'att.ctrNumero ='+TRANSFORM(cCodMed)
   ELSE
      cCodMed = ALLTRIM( cCodMed )
      cWhe = 'att.paccodigo LIKE "'+cCodMed+'%"'
   ENDIF
   
   IF cDeOndeVem # 'CADASTRO'
      cRunFORM = NULL
   ELSE
      cRunFORM = 'FI_TELA_ATEND( arquivo, Sequencia )'
   endif

   IF TYPE( 'dRef' ) $ 'DT'
      cWhe = cWhe + ' AND att.tm_chama < {^'+;
             TRAN(YEAR(dRef)) +'-'+TRAN( MONTH(dRef)) +'-'+ TRAN(DAY(dRef)) +' '+;
             TRAN(HOUR(dRef)) +':'+TRAN(MINUTE(dRef)) +':'+ TRAN(SEC(dRef)) +'}'
      cCabec = cCabec + [ anterior(es) a ]+ TTOC(dRef)
   ENDIF

   SELECT          att.tm_chama          AS DataEvento,;
                   LEFT(att.pacNome,35)  AS Paciente,;
                   IIF(att.liberacao=3,  'Regulado  ', IIF(att.liberacao=2 AND att.situacao=1, 'Pendente  ', att.medclassificacao )) AS Clas_Med,;
                   IIF(att.liberacao=1,  'Aguarg', IIF(att.liberacao=2,  'Liber.','N/Lib.')) AS situacao,;
                   NVL(LEFT(hd.descricao,30),SPACE(30)) as HD_DESCRICAO,;
                   att.resumoatendimento AS Resumo, ;
                   att.pacidade          AS Idade,;
                   att.CodAtendimento    As CodAtend,;
                   ta.descricao          aS TpAtend,;
                   att.pacbairro         AS Bairro,;
                   att.pacendereco       AS Endereco,;
                   att.paccomplemento    AS Complemto,;
                   att.solnome           AS Solic_Nome,;
                   att.solfone           AS Solic_fone,;
                   NVL(s1.descricao,SPACE(30)) AS Sint1,;
                   NVL(s2.descricao,SPACE(30)) AS Sint2,;
                   NVL(s3.descricao,SPACE(30)) AS Sint3,;
                   att.outrossintomas as Sint_outros,;
                   NVL(atd.NOME,SPACE(35))     AS Atendente,;
                   NVL(reg.NOME,SPACE(35))     AS Regulador,;
                   NVL(rop.NOME,SPACE(35))     AS R_Operador,;
                   NVL(med.nome,SPACE(35))   AS MEDICO,;
                   PADR(att.idEnfermeiro,35)   AS ENFERMEIRO,;
                   att.idunidademovel    AS Unidade,;
                   att.pacNome  AS NomeCompleto,;
                   'HISTORICO  ' AS arquivo,;
                   att.ID                AS Sequencia,;
                   att.medicacao,;
                   att.pacCodigo as Codigo ;
   FROM            Atendimento att ;
   LEFT OUTER JOIN TIPOATEND ta ON att.CodAtendimento == ta.ID    ;
   LEFT OUTER JOIN EQUIPE atd   ON att.idatendente    == atd.ID       ;
   LEFT OUTER JOIN EQUIPE reg   ON att.idRegulador    == reg.ID       ;
   LEFT OUTER JOIN EQUIPE rop   ON att.idRO           == rop.ID       ;
   LEFT OUTER JOIN EQUIPE med   ON att.idMedico       == med.ID       ;
   LEFT OUTER JOIN SINTOMA s1   ON att.idSintomas1    == s1.SINTOMA   ;
   LEFT OUTER JOIN SINTOMA s2   ON att.idSintomas2    == s2.SINTOMA   ;
   LEFT OUTER JOIN SINTOMA s3  ON att.idSintomas3     == s3.SINTOMA   ;
   LEFT OUTER JOIN HIPODIAG hd ON att.idHipoteseDiag == hd.id ;
   WHERE           &cWhe ;
   ORDER BY        1 DESC ;
   GROUP BY        att.ID ;
   INTO CURSOR     CHST1

   SELECT          att.tm_chama          AS DataEvento,;
                   LEFT(att.pacNome,35)  AS Paciente,;
                   IIF(att.liberacao=3,  'Regulado  ', IIF(att.liberacao=2 AND att.situacao=1, 'Pendente  ', att.medclassificacao )) AS Clas_Med,;
                   IIF(att.liberacao=1,  'Aguarg', IIF(att.liberacao=2,  'Liber.','N/Lib.')) AS situacao,;
                   NVL(LEFT(hd.descricao,30),SPACE(30)) as HD_DESCRICAO,;
                   att.resumoatendimento AS Resumo, ;
                   att.pacidade          AS Idade,;
                   att.CodAtendimento    As CodAtend,;
                   ta.descricao          aS TpAtend,;
                   att.pacbairro         AS Bairro,;
                   att.pacendereco       AS Endereco,;
                   att.paccomplemento    AS Complemto,;
                   att.solnome           AS Solic_Nome,;
                   att.solfone           AS Solic_fone,;
                   NVL(s1.descricao,SPACE(30)) AS Sint1,;
                   NVL(s2.descricao,SPACE(30)) AS Sint2,;
                   NVL(s3.descricao,SPACE(30)) AS Sint3,;
                   att.outrossintomas as Sint_outros,;
                   NVL(atd.NOME,SPACE(35))     AS Atendente,;
                   NVL(reg.NOME,SPACE(35))     AS Regulador,;
                   NVL(rop.NOME,SPACE(35))     AS R_Operador,;
                   NVL(med.nome,SPACE(35))   AS MEDICO,;
                   PADR(att.idEnfermeiro,35)   AS ENFERMEIRO,;
                   att.idunidademovel    AS Unidade,;
                   att.pacNome  AS NomeCompleto,;
                   'HISTORICO  ' AS arquivo,;
                   att.ID                AS Sequencia,;
                   att.medicacao,;
                   att.pacCodigo as Codigo ;
   FROM            HstAtend att ;
   LEFT OUTER JOIN TIPOATEND ta ON att.CodAtendimento == ta.ID    ;
   LEFT OUTER JOIN EQUIPE atd   ON att.idatendente    == atd.ID       ;
   LEFT OUTER JOIN EQUIPE reg   ON att.idRegulador    == reg.ID       ;
   LEFT OUTER JOIN EQUIPE rop   ON att.idRO           == rop.ID       ;
   LEFT OUTER JOIN EQUIPE med   ON att.idMedico       == med.ID       ;
   LEFT OUTER JOIN SINTOMA s1   ON att.idSintomas1    == s1.SINTOMA   ;
   LEFT OUTER JOIN SINTOMA s2   ON att.idSintomas2    == s2.SINTOMA   ;
   LEFT OUTER JOIN SINTOMA s3  ON att.idSintomas3     == s3.SINTOMA   ;
   LEFT OUTER JOIN HIPODIAG hd ON att.idHipoteseDiag == hd.id ;
   WHERE           &cWhe ;
   ORDER BY        1 DESC ;
   GROUP BY        att.ID ;
   INTO CURSOR     CHST2

   SELECT * FROM CHST1 UNION ALL SELECT * FROM CHST2 INTO CURSOR (cHST) READWRITE
   
   SCAN 
      nPos = INT(VAL(ENFERMEIRO))
      IF nPos > 0
         IF PTAB( nPos, 'EQUIPE', 'ID' )
            replace ENFERMEIRO WITH EQUIPE.nome IN (cHST)
         ENDIF
      ENDIF
   ENDSCAN

   USE IN ( SELECT( 'CHST1' ) )
   USE IN ( SELECT( 'CHST2' ) )

   IF cDeOndeVem # 'WZREG'
      USE IN ( SELECT( CHST  ) )
   ENDIF

   IF NOT lUsaCTR
      USE IN ( SELECT( 'CONTRATO' ) )
   ENDIF

   IF NOT lUsaHST
      USE IN ( SELECT( 'HSTATEND' ) )
   ENDIF

   IF NOT lUsaATD
      USE IN ( SELECT( 'ATENDIMENTO' ) )
   ELSE
      SELECT ATENDIMENTO
   ENDIF

ENDIF

SELE (nSel)

IF cDeOndeVem = 'WZREG'
   RETURN cHst
ELSE
   RETURN ''
ENDIF   
