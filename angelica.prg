Clear

SET DELETED On
Close Tables All
Close Databases All

Cd \\dcrpo\bdmdc$\

Use c:\xact In 0
Use \\dcrpo\bdmdc$\areceber In 0
Use \\dcrpo\bdmdc$\ifiscal  In 0 Order controle
Use \\dcrpo\bdmdc$\nfiscal  In 0 Order controle
Use \\dcrpo\bdmdc$\rcontrat In 0

* BEGIN TRANSACTION

Select xact
Scan For xact.idNF > 0


   nIDNF = xact.idNF
   nIDAR = xact.controle

   If Seek( nIDNF, 'NFISCAL', 'CONTROLE' )

      ?? [.]

      If Seek( nIDNF, 'IFISCAL', 'CONTROLE' )
         Select ifiscal
         nBr = 0
         Scan While ifiscal.controle = nIDNF
            If !Deleted()
               nBr = nBr + ifiscal.vlrtotal
            Endif
         Endscan
         Select xact
      Endif

      nPosNF  = Recno( 'NFISCAL' )
      oCalcNF = Createobject( 'CalcNF' )

      oCalcNF.acm_data_final = Date()
      oCalcNF.acm_filial     = nfiscal.idFilial
      oCalcNF.acm_cnpj       = nfiscal.cnpj_cnpf
      oCalcNF.VlrBruto       = nBr
      oCalcNF.ir_limite      = nfiscal.ir_limite
      oCalcNF.ir_Aliq        = nfiscal.ir_Aliq
      oCalcNF.inss_Limite    = nfiscal.inss_Limite
      oCalcNF.inss_Aliq      = nfiscal.inss_Aliq
      oCalcNF.iss_Aliq       = nfiscal.iss_Aliq
      oCalcNF.retem_ISS      = nfiscal.retem_ISS
      oCalcNF.cofins_ALIQ    = nfiscal.cofins_ALIQ
      oCalcNF.csoc_ALIQ      = nfiscal.csoc_ALIQ
      oCalcNF.pis_ALIQ       = nfiscal.pis_ALIQ
      oCalcNF.Calcula( nIDNF )

      =Seek( nIDNF, 'NFISCAL', 'controle' )

      Replace ;
         nfiscal.ValorBruto   With oCalcNF.VlrBruto    ,;
         nfiscal.IR_Base      With oCalcNF.IR_Base     ,;
         nfiscal.IR_Valor     With oCalcNF.IR_Valor    ,;
         nfiscal.ISS_Base     With oCalcNF.ISS_Base    ,;
         nfiscal.ISS_Valor    With oCalcNF.ISS_Valor   ,;
         nfiscal.INSS_Base    With oCalcNF.INSS_Base   ,;
         nfiscal.INSS_Valor   With oCalcNF.INSS_Valor  ,;
         nfiscal.COFINS_VALOR With oCalcNF.COFINS_VALOR,;
         nfiscal.CSOC_VALOR   With oCalcNF.CSOC_VALOR  ,;
         nfiscal.PIS_VALOR    With oCalcNF.PIS_VALOR   ,;
         nfiscal.ValorLiquido With oCalcNF.VlrLiquido In nfiscal

      nVlrL = oCalcNF.VlrLiquido

      cMsg = ''
      If (oCalcNF.cofins_ALIQ+oCalcNF.csoc_ALIQ+oCalcNF.pis_ALIQ) > 0
         cMsg = 'Ret.4,65% lei 10925/04 Vr: '+;
            alltrim( Transform( (oCalcNF.COFINS_VALOR+oCalcNF.CSOC_VALOR+oCalcNF.PIS_VALOR), '999,999,999.99'))+;
            iif( !Empty(oCalcNF.cAcm_NF_REF), " Ref.NF's:"+ Alltrim(oCalcNF.cAcm_NF_REF), '' )
      Endif
      If !Empty(oCalcNF.cAcm_NF_REF_ir) And oCalcNF.IR_Valor > 0
         cMsg = cMsg + " IRRF Ref.NF's: "+oCalcNF.cAcm_NF_REF_ir
      Endif
      If !Empty(cMsg)
         Replace nfiscal.informacao With cMsg
      Endif
      =Seek( nIDNF, 'NFISCAL', 'controle' )

      nTaxaBOL = $0
      If Seek(nfiscal.idContrato,'RCONTRAT','IDCONTRATO' ) And rcontrat.taxa_BOL > 0
         nTaxaBOL = rcontrat.taxa_BOL
      Endif
      nVlrL = nVlrL + nTaxaBOL

      Update   areceber           ;
         set   areceber.valor_documento = nVlrL ;
       where   areceber.idNF            = nIDNF

   Endif

   Select xact

Endscan







*!*      ?? [.]

*!*      nIDAR = xact.controle
*!*      nIDNF = xact.idNF
*!*
*!*      IF diferenca < 9.90
*!*         REPLACE MFLAG WITH '< 9.90'
*!*         LOOP
*!*      endif
*!*
*!*      nVlrAR = (xact.valor_docu - 9.90)
*!*
*!*      IF nVlrAR > 0
*!*
*!*         UPDATE ARECEBER ;
*!*         SET    valor_documento = nVlrAR ;
*!*         WHERE  controle = nIdAR
*!*
*!*         IF _TALLY = 0
*!*            REPLACE MFLAG WITH 'UPD 0'
*!*         ENDIF
*!*      ELSE
*!*         REPLACE MFLAG WITH 'VLR 0'
*!*      ENDIF
*!*
*!*      IF nIDNF > 0
*!*         DELETE FROM IFISCAL ;
*!*         WHERE  controle=nIdNF AND ;
*!*                descricao = 'TAXA DE MANUTENCAO ANUAL' AND ;
*!*                compl = '2007/2008' AND ;
*!*                codpro = 0

*!*         IF _TALLY = 0
*!*            REPLACE MFLAG WITH 'DEL 0'
*!*         ENDIF
*!*
*!*      ENDIF

*!*      SELECT xact
*!*
*!*   ENDSCAN
Close Databases All
Close Tables All

* ROLLBACK
