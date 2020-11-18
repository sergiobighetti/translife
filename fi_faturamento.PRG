Parameters cLote, cProt, nVlrO, dVcto

#Define ID_CODIGO_TRANSP 7

Local cAls, oBSNFI, oBSINF, oBSREC, oNFI, oINF, oNFI, cCnpjCPF, nIdCONTRATO, cTpTrans, cHistAR
Local oCalcNF, lOK, i, nID, nDias, nVlrDIA, nSUM, aDiasEVE[1,2]
Local cNroDoctoAR, dDiaVcto, nCodBanco, nCodConta, nIdNFI, nIdAREC, cAlsPac, cPac, nIdR, cIdTra
Local aCapErr[1], aOpen[1], cAlsO, cErr, cWhe, nVlrL, nVlrTotal, x

cLote = Upper(cLote)
cProt = Upper(cProt)

cAlsO   = Alias()
cAls    = Sys(2015)
cAlsPac = Sys(2015)
cPac    = ''
cIdTra  = ''

=Aused( aOpen )

If !Used('Nfiscal')
   Use bdmdc!NFISCAL In 0
Endif

Select NFISCAL
CursorSetProp("Buffering", 5)

Use bdmdc!IFISCAL In 0
Use bdmdc!ARECEBER In 0

Use bdtransp!TRANSP In 0
Select TRANSP
CursorSetProp("Buffering", 5)

Use bdtransp!TRANSP_PACIENTE In 0
Use bdtransp!TRANSP_ITINERARIO In 0
Use bdmdc!FILIAL In 0
Use bdmdc!banco In 0

Select ARECEBER
CursorSetProp("Buffering", 5)

Select NFISCAL
CursorSetProp("Buffering", 5)
Scatter Name oBSNFI Memo Fields Except controle Blank

Select IFISCAL
CursorSetProp("Buffering", 5)
Scatter Name oBSINF Memo Blank

Select ARECEBER
Scatter Name oBSREC Memo Blank

Select          TRANSP.idtransp          idtransp,;
   LEFT(TRANSP.fat_codigo,2) FIL_FAT,;
   TRANSP.idFilial           FIL_ATE,;
   TRANSP.fat_forma         Forma,;
   ( TRANSP.valor_inicial+Iif(TRANSP.hrp_quant>0,TRANSP.hrp_valor,0)-TRANSP.desconto+TRANSP.acrescimo ) VALOR,;
   dVcto                      VENCTO,;
   contrato.banco_portador      PORTADOR,;
   CAST( 396 As i )          CODCONTA,;
   TRANSP.fat_nome            NOMEFAT,;
   TRANSP.fat_codigo          CODIGO,;
   NVL(contrato.idContrato,0) idContrato,;
   TRANSP.data_transporte,;
   NVL(TRANSP_PACIENTE.nomepacien,'') PAC_NOME,;
   TRANSP.solicitado_em       SOL_DATA,;
   TRANSP.solicitante_nome    SOL_NOME, ;
   000000000                  ID_REC, ;
   TRANSP.lote             As lote, ;
   TRANSP.protocolo        As protocolo ;
   ;
   from            TRANSP ;
   LEFT Outer Join TRANSP_PACIENTE On TRANSP.idtransp = TRANSP_PACIENTE.idtransp ;
   LEFT Outer Join contrato On Alltrim(TRANSP.fat_codigo) = contrato.CODIGO ;
   where           Upper(TRANSP.lote) = Upper(cLote) And Upper(TRANSP.protocolo) = Upper(cProt) ;
   ORDER By        TRANSP.idFilial, TRANSP.fat_codigo, TRANSP.data_transporte ;
   into Cursor     (cAls) Readwrite


Select (cAls)


&&CREATE CURSOR (cAlsPac) ( CodPro i, Descricao C(60), Valor Y,  IdTransp i )
nVlrTotal = 0


Select (cAls)

*!*   SCAN ALL

&&nID    = IdTransp
&&cIdTra = cIdTra + ','+TRANSFORM(IdTransp)

&&=SEEK( nID,        'TRANSP', 'IDTRANSP' )
&&=SEEK( nID,        'TRANSP_PACIENTE',   'IDTRANSP' )
&&=SEEK( nID,        'TRANSP_ITINERARIO', 'IDTRANSP' )
&&=SEEK( &cAls..fil_fat, 'FILIAL', 'IDFILIAL' )

&&IF TRANSP.tipo_transporte = 'SIMPLES'
&&   cTpTrans = 'RS'
&&ELSE
&&   cTpTrans = 'RC'
&&ENDIF

nVlrTotal = nVlrO

&&INSERT INTO (cAlsPac) VALUES ( ID_CODIGO_TRANSP, cTpTrans+' '+ALLTRIM(TRANSP_PACIENTE.nomepacien), &cAls..Valor, nID )

*!*      cPac = cPac + CHR(13)+' IDR: '+TRANSFORM(nID,'9999999')+' '+ALLTRIM(TRANSP_PACIENTE.nomepacien)+' Vlr: '+ALLTRIM(TRANSFORM(&cAls..Valor,'999,999,999.99'))

*!*   ENDSCAN

cPac = 'Lote: '+Alltrim(cLote)+' Prot: '+Alltrim(cProt)

Begin Transaction

Scan All

   lOK   = .T.
   nID   = idtransp

   nVlrL = nVlrTotal

   If !Seek( nID, 'TRANSP', 'IDTRANSP' )
      Messagebox( 'Não foi encontrado o transporte '+Transform(nID), 16, 'Atenção' )
      Loop
   Endif

   =Seek( nID, 'TRANSP_PACIENTE',   'IDTRANSP' )
   =Seek( nID, 'TRANSP_ITINERARIO', 'IDTRANSP' )

   If TRANSP.tipo_transporte = 'SIMPLES'
      cTpTrans = 'RS'
   Else
      cTpTrans = 'RC'
   Endif
   =Seek( &cAls..FIL_FAT + Str(&cAls..PORTADOR,10), 'BANCO', 'FIL_PORT' )

   cHistAR = 'REMOCOES REFERENTES AO MES: ' + Subs(Ttoc(TRANSP.data_transporte),4,7)

   cCnpjCPF = Alltrim(Strtran(Strtran(Strtran(TRANSP.fat_cgc_cpf,'.',''),'-',''),'/',''))

   =Seek( TRANSP.fat_codigo, 'CONTRATO', 'CODIGO' )
   nIdCONTRATO = contrato.idContrato
   nIdNFI      = 0

   *-- se o portaror emite NF
   If &cAls..Forma <> 'ISENTO'

      oNFI = oBSNFI

      oNFI.idFilial    = &cAls..FIL_FAT
      oNFI.idContrato  = contrato.idContrato
      oNFI.nomeempresa = TRANSP.fat_nome
      oNFI.cnpj_cnpf   = TRANSP.fat_cgc_cpf
      oNFI.endereco    = TRANSP.fat_end
      oNFI.bairro      = TRANSP.fat_bairro
      oNFI.cep         = TRANSP.fat_cep
      oNFI.cidade      = TRANSP.fat_cidade
      oNFI.uf          = TRANSP.fat_uf
      oNFI.Fone        = TRANSP.solicitante_fone
      oNFI.ir_Aliq     = contrato.ir
      oNFI.ir_limite   = contrato.ir_limite
      oNFI.iss_Aliq    = contrato.iss
      oNFI.inss_Aliq   = contrato.inss
      oNFI.inss_Limite = FILIAL.nf_inss_limite
      oNFI.optante     = contrato.optante
      oNFI.retem_ISS   = contrato.retem_ISS
      oNFI.origem      = 'LIBFAT'
      oNFI.cofins_ALIQ = contrato.cofins
      oNFI.pis_ALIQ    = contrato.pis
      oNFI.csoc_ALIQ   = contrato.csocial
      oNFI.ref         = ""
      oNFI.cancelada   = 1

      Select NFISCAL
      Append Blank
      Gather Name oNFI Memo

      lOK = Tableupdate(2,.T.,'NFISCAL')

      If lOK

         nIdNFI = NFISCAL.controle

         Select (cAls)
         &&SCAN ALL

         =Seek( &cAls..idtransp, 'TRANSP', 'IDTRANSP' )

         nIdCodTra      =  0 && ID_CODIGO_TRANSP

         oINF = oBSINF
         oINF.controle  = nIdNFI
         oINF.CodPro    = nIdCodTra
         oINF.Descricao = 'LIBFAT Lt: ' +Alltrim(cLote)
         oINF.Compl     = 'Prot: ' + Alltrim(cProt)
         oINF.vlrunit   = nVlrO
         oINF.vlrtotal  = nVlrO
         oINF.origem    = 'LIBFAT'

         Select IFISCAL
         Append Blank
         Gather Name oINF Memo

         Select (cAls)
         &&ENDSCAN


         lOK = Tableupdate(2,.T., 'IFISCAL')

      Endif

      If lOK

         oCalcNF = Createobject( 'CalcNF' )
         oCalcNF.acm_cnpj    = cCnpjCPF
         oCalcNF.acm_filial  = NFISCAL.idFilial

         oCalcNF.VlrBruto    = nVlrTotal

         oCalcNF.ir_limite   = NFISCAL.ir_limite
         oCalcNF.ir_Aliq     = NFISCAL.ir_Aliq
         oCalcNF.inss_Limite = NFISCAL.inss_Limite
         oCalcNF.inss_Aliq   = NFISCAL.inss_Aliq
         oCalcNF.iss_Aliq    = NFISCAL.iss_Aliq
         oCalcNF.retem_ISS   = NFISCAL.retem_ISS
         oCalcNF.cofins_ALIQ = NFISCAL.cofins_ALIQ
         oCalcNF.csoc_ALIQ   = NFISCAL.csoc_ALIQ
         oCalcNF.pis_ALIQ    = NFISCAL.pis_ALIQ
         oCalcNF.Calcula( nIdNFI )

         Replace ;
            NFISCAL.ValorBruto   With oCalcNF.VlrBruto    ,;
            NFISCAL.IR_Base      With oCalcNF.IR_Base     ,;
            NFISCAL.IR_Valor     With oCalcNF.IR_Valor    ,;
            NFISCAL.ISS_Base     With oCalcNF.ISS_Base    ,;
            NFISCAL.ISS_Valor    With oCalcNF.ISS_Valor   ,;
            NFISCAL.INSS_Base    With oCalcNF.INSS_Base   ,;
            NFISCAL.INSS_Valor   With oCalcNF.INSS_Valor  ,;
            NFISCAL.ValorLiquido With oCalcNF.VlrLiquido  ,;
            NFISCAL.COFINS_Valor With oCalcNF.COFINS_Valor,;
            NFISCAL.CSOC_Valor   With oCalcNF.CSOC_Valor  ,;
            NFISCAL.PIS_Valor    With oCalcNF.PIS_Valor    ;
            IN NFISCAL

         If oCalcNF.inss_Aliq = 0
            Replace In NFISCAL ;
               complemento With 'NÃO RETENÇÃO DE 11% INSS, SERVIÇO SEM CESSÃO DE MÃO DE OBRA, NOS TERMOS DOS ARTIGOS 118 E 149 DA IN 971/2009'

         Else
            If oCalcNF.INSS_Valor >= 30
               Replace In NFISCAL ;
                  complemento  With 'Deduzir INSS Aliq '+ Allt( Tran(NFISCAL.inss_Aliq,[999.9] )) + ;
                  '% Vlr R$ '+ Allt( Tran(oCalcNF.INSS_Valor,'999,999,999.99') )
            Endif
         Endif

         nVlrL = oCalcNF.VlrLiquido

         If (oCalcNF.cofins_ALIQ+oCalcNF.csoc_ALIQ+oCalcNF.pis_ALIQ) > 0

            Replace In NFISCAL;
               informacao With 'Ret.4,65% lei 10925/04 Vr: '+;
               ALLTRIM( Transform( (oCalcNF.COFINS_Valor+oCalcNF.CSOC_Valor+oCalcNF.PIS_Valor), '999,999,999.99'))+;
               IIF( !Empty(oCalcNF.cAcm_NF_REF), " Ref.NF's:"+ Alltrim(oCalcNF.cAcm_NF_REF), '' )
         Endif

         lOK = Tableupdate(2,.T.,'NFISCAL') And  Tableupdate(2,.T.,'IFISCAL')

         Release oCalcNF

      Endif

   Endif

   nIdAREC = 0
   If lOK And &cAls..Forma <> 'ISENTO'

      cNroDoctoAR = Transform(nIdCONTRATO)          +'_'+;
         TRANSFORM(Month(Date()),'@L 99')+;
         RIGHT( Transform(Year(Date())), 2 ) +cTpTrans

      dDiaVcto    = &cAls..VENCTO
      nCodBanco   = &cAls..PORTADOR
      nCodConta   = &cAls..CODCONTA

      Insert Into ARECEBER ;
         ( ;
         idFilial,;
         idContrato, ;
         numero_documento, ;
         data_Vencimento, ;
         data_emissao, ;
         historico, ;
         valor_documento, ;
         codigo_banco, ;
         forma_pagto, ;
         codigo_subconta, ;
         ctrl_rr, idNF, origem, ref, situacao, observacao ) ;
         VALUES ;
         ( ;
         &cAls..FIL_FAT,;
         nIdCONTRATO,;
         cNroDoctoAR,;
         dDiaVcto,;
         DATE(),;
         cHistAR,;
         nVlrO,;
         nCodBanco,;
         IIF( TRANSP.fat_forma='A VISTA','CARTEIRA',TRANSP.fat_forma),;
         nCodConta,;
         "NAO", nIdNFI, 'LIBFAT',  Left(Dtos(&cAls..data_transporte),6), 'ABERTO', cPac )

      lOK = Tableupdate(2,.T.,'ARECEBER')

      nIdAREC = ARECEBER.controle

   Endif

   Select (cAls)
   Replace ID_REC With nIdAREC

   cWhe = 'INLIST(IdTransp'+ cIdTra +')'
   Update (cAls) Set ID_REC = nIdAREC ;
      where           Upper(TRANSP.lote) = Upper(cLote) And ;
      UPPER(TRANSP.protocolo) = Upper(cProt)

Endscan

Scan For lOK

   nID         = idtransp


   If Forma = 'ISENTO'
      dDiaVcto    = {}
      nCodBanco   = -1
      nCodConta   = -1
      nIdR        = -1
   Else
      dDiaVcto    = &cAls..VENCTO
      nCodBanco   = &cAls..PORTADOR
      nCodConta   = &cAls..CODCONTA
      nIdR        = &cAls..ID_REC
   Endif

   Update TRANSP ;
      SET    fat_controle   = nIdR,;
             fat_vencimento = dDiaVcto,;
             fat_portador   = nCodBanco ;
      WHERE  idtransp       = nID

   lOK = Tableupdate(2,.T.,'TRANSP')

Endscan

If lOK
   Flush
   End Transaction
   Messagebox( 'Faturamento OK' )

Else

   Rollback

   cErr = ''
   =Aerror( aCapErr )
   For i = 1 To Alen(aCapErr)
      If Not Isnull(aCapErr[i])
         If i = 3
            If aCapErr[i] == aCapErr[2]
               Exit
            Endif
         Endif
         cErr = cErr +Chr(13)+ Transform(i)+': '+Transform(aCapErr[i])
      Endif
   Endfor
   Messagebox( cErr,16, 'Atenção: Falha' )

Endif

Use In ( Select( cAlsPac ) )


For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
Next

Select (cAlsO)

