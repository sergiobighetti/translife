
CLOSE DATABASES all
CLOSE TABLES all
SET ESCAPE ON



*-----------------------------------------------------------------------
USE  'W:\backup vidalar\CONTRATO'                 IN 0 ALIAS VDL_CONTR
USE  'W:\backup vidalar\ASSOCIADO'                IN 0 ALIAS VDL_ASSOC
USE  'W:\backup vidalar\ASSOCIADO_PLANO'          IN 0 ALIAS VDL_PLANO
*-----------------------------------------------------------------------
USE  'c:\desenv\win\vfp9\sca_new\CONTRATO'        IN 0 ALIAS CONTRATO
USE  'c:\desenv\win\vfp9\sca_new\ASSOCIADO'       IN 0 ALIAS ASSOCIADO
USE  'c:\desenv\win\vfp9\sca_new\ASSOCIADO_PLANO' IN 0 ALIAS ASSOCIADO_PLANO
*-----------------------------------------------------------------------

* BEGIN TRANSACTION 




SELECT       aa.* ;
FROM         CONTRATO aa ;
WHERE        aa.idFilial='06' ;
INTO CURSOR  CTR_ATUAL 


CLEAR

SELECT CTR_ATUAL
SCAN ALL
    
   nIdCtrVIDALAR = INT(VAL(OLDKEY))
   nIdCtrMEDICAR = CTR_ATUAL.idContrato
   
   ? nIdCtrVIDALAR 
      
   SELECT         ;
                  '06'                  IDFILIAL,;
                  '06'                  FIL_CART,;
                  aa.TIPO_CONTRATO      TIPO_CONTRATO,;
                  aa.idContrato         NUMERO,;
                  '06'+fi_tpcontrato(aa.TIPO_CONTRATO)+padl(aa.idContrato,6,'0')+'CT' CODIGO,;
                  aa.SITUACAO           SITUACAO,;
                  aa.DATAVIGOR          DATAVIGOR,;
                  aa.NOME_RESPONSAVEL   NOME_RESPONSAVEL,;
                  aa.NOME_FANTASIA      NOME_FANTASIA,;
                  aa.INICIAIS           INICIAIS,;
                  aa.ENDERECO           ENDERECO,;
                  aa.COB_END            COB_END,;
                  aa.COMPLEMENTO        COMPLEMENTO,;
                  aa.COB_COMPL          COB_COMPL,;
                  aa.BAIRRO             BAIRRO,;
                  aa.COB_BAIRRO         COB_BAIRRO,;
                  aa.CIDADE             CIDADE,;
                  aa.COB_CID            COB_CID,;
                  aa.UF                 UF,;
                  aa.COB_UF             COB_UF,;
                  aa.CEP                CEP,;
                  aa.COB_CEP            COB_CEP,;
                  aa.FONE               FONE,;
                  aa.FAX                FAX,;
                  aa.EMAIL              EMAIL,;
                  aa.CNPJ               CNPJ,;
                  aa.INSCRICAO_ESTADUAL INSCRICAO_ESTADUAL,;
                  aa.CPF                CPF,;
                  aa.RG                 RG,;
                  aa.CLASSIFICACAO      CLASSIFICACAO,;
                  aa.DATACANCELA        DATACANCELA,;
                  aa.DATACANCELA        DATAEXC,;
                  aa.MOTIVOCANCEL       MOTIVOCANCEL,;
                  aa.MOTIVO             MOTIVO,;
                  aa.FORMA_PAGAMENTO    FORMA_PAGAMENTO,;
                  aa.BANCO_PORTADOR     BANCO_PORTADOR,;
                  aa.AGENCIA            AGENCIA,;
                  aa.CONTA_CORRENTE     CONTA_CORRENTE,;
                  aa.NOME_CARTAO        NOME_CARTAO,;
                  aa.NUMERO_CARTAO      NUMERO_CARTAO,;
                  aa.TIPO_PARCELA       TIPO_PARCELA,;
                  aa.DIA_VENCIMENTO     DIA_VENCIMENTO,;
                  aa.DATABASE           DATABASE,;
                  aa.EMITE_NF           EMITE_NF,;
                  aa.VENDEDOR           VENDEDOR,;
                  aa.VALOR              VALOR,;
                  aa.OBSERVACAO         OBSERVACAO,;
                  aa.ORIENTACAO         ORIENTACAO,;
                  aa.REGULACAO          REGULACAO,;
                  aa.FICHA              FICHA,;
                  aa.INSS               INSS,;
                  aa.ISS                ISS,;
                  aa.IR                 IR,;
                  aa.IR_LIMITE          IR_LIMITE,;
                  aa.COFINS             COFINS,;
                  aa.CSOCIAL            CSOCIAL,;
                  aa.PIS                PIS,;
                  aa.OPTANTE            OPTANTE,;
                  aa.GERA_CART          GERA_CART,;
                  space(4)              AGRUPAMENTO,;
                  aa.VLDREG             VLDREG,;
                  aa.DESCONTO           DESCONTO,;
                  aa.VALOR_ANT          VALOR_ANT,;
                  aa.ULT_REAJUSTE       ULT_REAJUSTE,;
                  aa.NROVIDAS           NROVIDAS,;
                  aa.RETEM_ISS          RETEM_ISS,;
                  CAST(0 as i)          CTR_GRUPO,;
                  .t.                   GERA_DBC,;
                  {//}                  RENOVACAO,;
                  aa.DATAVIGOR          ATIVACAO,;
                  aa.auditoria          AUDITORIA,;
                  aa.MASTER             MASTER,;
                  aa.DATA_CADASTRO      DATA_CADASTRO,;
                  aa.DATAEXC            DATAEXP,;
                  PADR(aa.idContrato,30) OLDKEY,;
                  PADR(aa.idContrato,30) CODORIGEM,;
                  ' '                   OPERADORA,;
                  space(15)             CELULAR,;
                  space(50)             MKT_CAMPANHA,;
                  'N'                   SIMPLES ;
                  ;
   FROM           VDL_CONTR aa ;
   WHERE          aa.idContrato = nIdCtrVIDALAR  ;
   INTO CURSOR    LV_CTR  READWRITE 
   
   IF _TALLY > 0

      SCATTER NAME oReg MEMO 
   
      IF SEEK( nIdCtrMEDICAR, 'CONTRATO', 'I_D' )
      
         SELECT CONTRATO
         GATHER NAME oReg MEMO 
         
         SELECT      aa.* ;
         FROM        VDL_ASSOC aa ;
         WHERE       aa.situacao='ATIVO' AND aa.idContrato == nIdCtrVIDALAR  ;
         ORDER BY    aa.idAssoc ;
         INTO CURSOR LV_ASSOC
         
         IF _TALLY > 0
            SCAN WHILE !EOF()
               ?? [.]
               
               nOldIdAssoc = LV_ASSOC.idAssoc
               
               SCATTER NAME oReg MEMO
               
               oReg.idContrato = nIdCtrMEDICAR 
               oReg.CODIGO     = '06'+SUBSTR(oReg.CODIGO,3)
               
               SELECT ASSOCIADO
               APPEND BLANK
               GATHER NAME oReg FIELDS EXCEPT idAssoc 
               
               nNewIDAssoc = ASSOCIADO.idAssoc
               
               
               SELECT DISTINCT * FROM VDL_PLANO WHERE idAssoc = nOldIdAssoc INTO CURSOR LV_PLANO
               
               SCAN WHILE idAssoc = nOldIdAssoc 
               
                   SCATTER NAME oReg
                   oReg.idAssoc = nNewIDAssoc 
                   
                   IF oReg.idPlano = 1
                      oReg.idPlano = 2
                   ENDIF 
                   
                   SELECT ASSOCIADO_PLANO
                   APPEND BLANK
                   GATHER NAME oReg 
                   
                   SELECT LV_PLANO
                   
               ENDSCAN 
               
            
               SELECT LV_ASSOC
            ENDSCAN 
         ENDIF
         
      ENDIF
      
   ENDIF     
   
   SELECT CTR_ATUAL
ENDSCAN 

