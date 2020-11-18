Lparam _Key, cAls
Local nSele, lUsaARECEBER, lUsaBXAREC, cAre, lUsaNFISCAL, cSQL

If verGrupo( 'CONTAS A RECEBER' )

   lUsaARECEBER = Used( 'ARECEBER' )
   lUsaBXAREC   = Used( 'BXAREC' )
   lUsaNFISCAL  = Used( 'NFISCAL' )

   cAre  = 'T'+Sys(3)
   nSele = Select()

   If Type( '_Key' ) = 'C'
      =Seek( _Key, 'CONTRATO', 'CODIGO' )
      _Key = CONTRATO.idContrato
   Endif

   cSQL = 'SELECT DISTINCT '
   cSQL = cSQL + 'aa.idFilial as FILIAL, aa.data_vencimento  as Vencimento,'
   cSQL = cSQL + 'aa.numero_documento as Documento,'
   cSQL = cSQL + 'aa.valor_documento  as Valor,'
   cSQL = cSQL + 'NVL( SUM(bb.vlr_recebido),$0 ) as VlrRecebido,'
   cSQL = cSQL + 'aa.forma_pagto as FormaPgto,'
   cSQL = cSQL + 'aa.situacao as Situacao,'
   cSQL = cSQL + 'NVL(nn.numeronf,0)  as NF,'
   cSQL = cSQL + "NVL( MAX(bb.data_baixa), CTOT('') ) AS DataBaixa,"
   cSQL = cSQL + "NVL( bb.motivobaixa, SPACE(50) ) as MotivoBaixa,"
   cSQL = cSQL + "NVL(bb.formaRec,0) as FR,"
   cSQL = cSQL + "aa.codigo_subconta as CTA_FNC,"
   cSQL = cSQL + "NVL( bb.sequencia, INT(0) ) as SeqBaixa,"
   cSQL = cSQL + "aa.historico as Historico, "
   cSQL = cSQL + "aa.codigo_banco as Portador, "
   cSQL = cSQL + 'aa.observacao,'
   cSQL = cSQL + 'aa.controle as Controle '
   cSQL = cSQL + 'FROM ARECEBER aa '
   cSQL = cSQL + 'LEFT OUTER JOIN CONTRATO cc ON aa.idContrato == cc.idContrato '
   cSQL = cSQL + 'LEFT OUTER JOIN BXAREC  bb ON aa.controle == bb.controle '
   cSQL = cSQL + 'LEFT OUTER JOIN NFISCAL nn ON aa.idNf == bb.controle '
   cSQL = cSQL + 'WHERE aa.idContrato = '+ Transform(_Key)

   If Type( 'gnConexao' ) $ 'IN' And gnConexao > 0

      If SQLrun( cSQL, cAre ) >0
         If Type('cAls') = 'C'
            Select * From (cAre) Into Cursor (cAls)
         Else
            Do Form PESQUISA With 'SELECT * FROM '+cAre,,,'Histórico financeiro', [IIF(SITUACAO="ABERTO" AND (date()-vencimento)>0, 255,IIF(SITUACAO="LIQUIDADO",16777088,16777215))]
         Endif
      Endif

   Else

      Wait Window 'Selecionando informações...aguarde' Nowait Noclear
      If Not lUsaBXAREC
         Use BXAREC In 0 Shared
      Endif
      If Not lUsaNFISCAL
         Use NFISCAL In 0 Shared
      Endif
      FI_CARGA_AR( cAre, _Key )
      Wait Clear

      If Used( cAre ) And Reccount( cAre ) > 0
         If Type('cAls') = 'C'
            Select * From (cAre) Into Cursor (cAls)
         Else
            Do Form PESQUISA With 'SELECT * FROM '+cAre,,'fi_do_Form_AR( CONTROLE )','Histórico financeiro', [IIF(SITUACAO="ABERTO" AND (date()-vencimento)>0, 255,IIF(SITUACAO="LIQUIDADO",16777088,16777215))],,.T.
         Endif
      ELSE

         TRY 
             FoxyDialog("Atenção!", ;
              "Não existem lançamentos", ;
              "Não foram encontrados lançamentos financeiros" , ;
              "X,R", ; && Error icon, with red background  
              "OK") && Button caption
         
         CATCH
            Messagebox( 'Não existem lancamentos no A RECEBER', 16, 'Atenção' )
         ENDTRY

      Endif

   Endif

   If Not lUsaARECEBER
      Use In ( Select( 'ARECEBER' ) )
   Endif

   If Not lUsaBXAREC
      Use In ( Select( 'BXAREC' ) )
   Endif

   If Not lUsaNFISCAL
      Use In ( Select( 'NFISCAL' ) )
   Endif

   Use In ( Select( cAre ) )

   Sele (nSele)

Endif

Return Nvl(cAls,'')


Function fi_do_Form_AR( nCtrl )
Local nSele
nSele = Select()
Select ARECEBER
=Seek( nCtrl, 'ARECEBER', 'CONTROLE' )
Do Form ARECEBER With nCtrl
Select (nSele)
Return



Function FI_CARGA_AR( cAre, nKey )
Local nKeyAR, nNroFiscal, cAreSLB

cAreSLB = cAre
cAre    = 'AreSLB'

Select          aa.idFILIAL FILIAL, aa.data_vencimento  As Vencimento,;
   aa.numero_documento As Documento,;
   $0 As Valor,;
   $0  As VlrRecebido,;
   aa.forma_pagto As FormaPgto,;
   aa.situacao As situacao,;
   0000000000  As NF,;
   CTOT('')   As DataBaixa,;
   SPACE(50) As MotivoBaixa,;
   000 As FR,;
   0000000 CTA_FNC,;
   INT(0) As SeqBaixa,;
   aa.historico As historico, ;
   aa.codigo_banco As Portador, ;
   LEFT(aa.observacao,249) as observacao,;
   aa.controle As controle ;
   FROM            ARECEBER aa ;
   WHERE           1=2 ;
   INTO Cursor     (cAre) Readwrite

=CursorSetProp("Buffering",1,cAre)


If PTAB(nKey,'ARECEBER', 'IDCONTRATO', .T. )

   Sele ARECEBER
   Scan While ARECEBER.idContrato == nKey

      nKeyAR = ARECEBER.controle

      If ARECEBER.idNF > 0 And Seek( ARECEBER.idNF, 'NFISCAL', 'controle' )
         nNroFiscal = NFISCAL.numeroNF
      Else
         nNroFiscal = 0
      Endif

      If PTAB( nKeyAR, 'BXAREC', 'CONTROLE', .T. )

         Sele BXAREC
         Scan While BXAREC.controle == nKeyAR

            Insert Into (cAre) Values ;
               ( ARECEBER.idFILIAL,        ARECEBER.data_vencimento, ARECEBER.numero_documento,;
               ARECEBER.valor_documento, BXAREC.vlr_Recebido,;
               ARECEBER.forma_pagto,     ARECEBER.situacao, ;
               nNroFiscal,               BXAREC.data_baixa,;
               BXAREC.MotivoBaixa,       BXAREC.formaRec, ;
               ARECEBER.codigo_subconta,;
               BXAREC.sequencia,         ARECEBER.historico, ;
               ARECEBER.codigo_banco,    ARECEBER.observacao, ARECEBER.controle )

            Sele BXAREC

         Endscan


      Else

         Insert Into (cAre) Values ;
            ( ARECEBER.idFILIAL,        ARECEBER.data_vencimento, ARECEBER.numero_documento,;
            ARECEBER.valor_documento, $0,;
            ARECEBER.forma_pagto,     ARECEBER.situacao, ;
            nNroFiscal,               Ctod(''),;
            '',       0, ;
            ARECEBER.codigo_subconta,;
            0,         ARECEBER.historico, ;
            ARECEBER.codigo_banco,    ARECEBER.observacao, ARECEBER.controle )


      Endif

      Sele ARECEBER

   Endscan

   Go Top In (cAre)


   Select          ;
      FILIAL,;
      Vencimento,;
      Documento,;
      Valor,;
      SUM(VlrRecebido) As VlrRecebido,;
      FormaPgto,;
      situacao,;
      NF,;
      DataBaixa,;
      MotivoBaixa,;
      CTA_FNC,;
      FR,;
      SeqBaixa,;
      historico, ;
      Portador, ;
      observacao,;
      controle ;
      FROM            (cAre) ;
      GROUP By        controle ;
      ORDER By        1, 2, 3 Desc ;
      INTO Cursor     (cAreSLB) Readwrite

   Use In ( Select( cAre ) )

   Select (cAreSLB)

Endif

Return
