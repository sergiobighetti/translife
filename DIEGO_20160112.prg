
CLOSE DATABASES ALL
? UpdateAutoIncID( 'CONTRATO', 'IDCONTRATO' )
* retira o auto inc
CLOSE DATABASES all

ALTER TABLE contrato ALTER COLUMN idcontrato I





INSERT INTO CONTRATO ( ;
     Idcontrato, Idfilial, Fil_cart, Tipo_contrato, Numero, Codigo, Situacao;
   , Datavigor, Nome_responsavel, Nome_fantasia, Iniciais, Endereco, Cob_end;
   , Complemento, Cob_compl, Bairro, Cob_bairro, Cidade, Cob_cid, Uf, Cob_uf;
   , Cep, Cob_cep, Fone, Fax, Email, Cnpj, Inscricao_estadual, Cpf, Rg, Classificacao;
   , Datacancela, Dataexc, Motivocancel, Motivo, Forma_pagamento, Banco_portador;
   , Agencia, Conta_corrente, Nome_cartao, Numero_cartao, Tipo_parcela, Dia_vencimento;
   , Database, Emite_nf, Vendedor, Valor, Observacao, Orientacao, Regulacao;
   , Ficha, Inss, Iss, Ir, Ir_limite, Cofins, Csocial, Pis, Optante, Gera_cart;
   , Agrupamento, Vldreg, Desconto, Valor_ant, Ult_reajuste, Nrovidas, Retem_iss;
   , Ctr_grupo, Gera_dbc, Renovacao, Ativacao, Auditoria, Master, Data_cadastro;
   , Dataexp, Oldkey, Codorigem, Operadora, Celular, Mkt_campanha, Simples;
   , Inss_base, Id_vend_tele, Im;
     ) ;
  SELECT ;
     Idcontrato ;
   , Idfilial   ;
   , Fil_cart   ;
   , Tipo_contrato;
   , Numero     ;
   , Codigo     ;
   , Situacao   ;
   , Datavigor  ;
   , Nome_responsavel;
   , Nome_fantasia;
   , Iniciais   ;
   , Endereco   ;
   , Cob_end    ;
   , Complemento;
   , Cob_compl  ;
   , Bairro     ;
   , Cob_bairro ;
   , Cidade     ;
   , Cob_cid    ;
   , Uf         ;
   , Cob_uf     ;
   , Cep        ;
   , Cob_cep    ;
   , Fone       ;
   , Fax        ;
   , Email      ;
   , Cnpj       ;
   , Inscricao_estadual;
   , Cpf        ;
   , Rg         ;
   , Classificacao;
   , Datacancela;
   , Dataexc    ;
   , Motivocancel;
   , Motivo     ;
   , Forma_pagamento;
   , Banco_portador;
   , Agencia    ;
   , Conta_corrente;
   , Nome_cartao;
   , Numero_cartao;
   , Tipo_parcela;
   , Dia_vencimento;
   , Database   ;
   , Emite_nf   ;
   , Vendedor   ;
   , Valor      ;
   , Observacao ;
   , Orientacao ;
   , Regulacao  ;
   , Ficha      ;
   , Inss       ;
   , Iss        ;
   , Ir         ;
   , Ir_limite  ;
   , Cofins     ;
   , Csocial    ;
   , Pis        ;
   , Optante    ;
   , Gera_cart  ;
   , Agrupamento;
   , Vldreg     ;
   , Desconto   ;
   , Valor_ant  ;
   , Ult_reajuste;
   , Nrovidas   ;
   , Retem_iss  ;
   , Ctr_grupo  ;
   , Gera_dbc   ;
   , Renovacao  ;
   , Ativacao   ;
   , Auditoria  ;
   , Master     ;
   , Data_cadastro;
   , Dataexp    ;
   , Oldkey     ;
   , Codorigem  ;
   , Operadora  ;
   , Celular    ;
   , Mkt_campanha;
   , Simples    ;
   , Inss_base  ;
   , Id_vend_tele;
   , Im         ;
    FROM CONTRATO



CLOSE DATABASES all




? UpdateAutoIncID( 'contrato','idcontrato')


FUNCTION UpdateAutoIncID
LPARAMETERS tcTableName, tcIDfieldName, lnNextID
LOCAL lnAantalRecords, lnLastID

USE (tcTableName) IN 0

SET DELETED OFF

lnNextID = IIF(TYPE('lnNextID')='N', lnNextID, 0 )

IF lnNextID = 0

   SELECT COUNT(*) AS xx FROM &tcTableName INTO CURSOR tmp
   lnAantalRecords = xx
   SELECT MAX(&tcIDfieldName) AS xx FROM &tcTableName INTO CURSOR tmp

   lnLastID = xx
   lnNextID = MAX(lnAantalRecords,lnLastID) + 1
ENDIF

USE IN &tcTableName

ALTER TABLE &tcTableName ALTER COLUMN &tcIDfieldName I NOT NULL AUTOINC NEXTVALUE lnNextID STEP 1

USE IN &tcTableName
