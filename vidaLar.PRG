cDirCTR_V='\\dcrpo\arquivos\cpd\sergio\VIDALAR\CONTRATO'
cDirCTR_M='\\dcrpo\bdmdc$\CONTRATO'

*!*   cDirCTR_V='c:\desenv\win\vfp9\VDL\CONTRATO'
*!*   cDirCTR_M='c:\desenv\win\vfp9\SCA_NEW\CONTRATO'

CLOSE DATABASES all
CLOSE TABLES all
SET EXCLUSIVE OFF 
SET ESCAPE ON 

*-- seleciona os contratos
SELECT       ;
               aa.NUMERO_CONTRATO    IDCONTRATO,;
               '06'                  IDFILIAL,;
               '06'                  FIL_CART,;
               aa.TIPO_CONTRATO      TIPO_CONTRATO,;
               aa.NUMERO_CONTRATO    NUMERO,;
               '06'+fi_tpcontrato(aa.TIPO_CONTRATO)+padl(aa.NUMERO_CONTRATO,6,'0')+'CT' CODIGO,;
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
               PADR(aa.numero_contrato,30) OLDKEY,;
               PADR(aa.numero_contrato,30) CODORIGEM,;
               ' '                   OPERADORA,;
               space(15)             CELULAR,;
               space(50)             MKT_CAMPANHA,;
               'N'                   SIMPLES ;
;
FROM          ('\\dcrpo\arquivos\cpd\sergio\VIDALAR\CONTRATO') aa ;
WHERE         aa.situacao='ATIVO' ;
          AND NOT aa.numero_contrato IN ( 339,401 ) ;
ORDER BY      aa.numero_contrato ;
INTO CURSOR   LV_CTR  READWRITE 


*-- fecha o arquivo de contrato da VIDALAR
USE IN ( SELECT('CONTRATO' ))

*-- abre o arquivo de contrato da medicar
USE (cDirCTR_M) IN 0 

CLEAR 

SET STEP ON 

* BEGIN TRANSACTION 
*-- processa a seleção
SELECT LV_CTR
SCAN ALL

   @ 10,10 say RECNO() 
   
   SCATTER NAME oReg MEMO 
   
   SELECT contrato
   APPEND BLANK 
   GATHER NAME oReg MEMO FIELDS EXCEPT idContrato  && repassa o contrato e deixa gerar o codigo
   
   SELECT LV_CTR
  
ENDSCAN 


        
        