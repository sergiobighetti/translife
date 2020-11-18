   select      CONTRATO.idContrato, ;
               CONTRATO.idContrato as CTR_GRUPO ,;
               CONTRATO.codigo,;
               CONTRATO.nome_responsavel, ;
               CONTRATO.inscricao_estadual as IE, CONTRATO.cpf, ;
               CONTRATO.emite_NF, CONTRATO.Fone, CONTRATO.cnpj, CONTRATO.iss, CONTRATO.ir, CONTRATO.ir_limite, CONTRATO.optante, ;
               CONTRATO.retem_ISS, CONTRATO.cofins, CONTRATO.csocial, CONTRATO.pis, CONTRATO.inss, CONTRATO.dia_vencimento as DiaVC, ;
               CONTRATO.forma_pagamento, CONTRATO.banco_portador, CONTRATO.agencia, CONTRATO.conta_corrente, ;
               CONTRATO.valor, CONTRATO.database, CONTRATO.tipo_contrato, CONTRATO.DataVigor, CONTRATO.tipo_Parcela, CONTRATO.desconto,;
               ;
               CONTRATO.COB_End ENDERECO, CONTRATO.Cob_Bairro BAIRRO, CONTRATO.cob_cep CEP, CONTRATO.cob_cid CIDADE, CONTRATO.cob_uf UF, ;
               ;
               NVL(RCONTRAT.taxa_bol,  $0) taxa_BOL,;
               NVL(RCONTRAT.transp_mes,00) transp_MES,;  && transporte monitorado (MES)
               NVL(RCONTRAT.transp_vlr,$0) transp_VLR,;  && transporte monitorado (VALOR)
               ;
               NVL(CONTRATO_FM.idContrato, -1) COM_FM,;   && contrato c/ FATOR MODERADOR
               NVL(CONTRATO_COP.idContrato,-1) COM_COP,;  && contrato c/ CUSTO OPERACIONAL
               ;
               $0 as VlrLiq,;
               CONTRATO.idFilial,;
               space(60) as MYLOG ;
   from        CONTRATO ;
   LEFT OUTER join RCONTRAT     ON RCONTRAT.idContrato     == contrato.idContrato ;
   LEFT OUTER join CONTRATO_FM  ON CONTRATO_FM.idContrato  == contrato.idContrato ;
   LEFT OUTER join CONTRATO_COP ON CONTRATO_COP.idContrato == contrato.idContrato ;
   where       CONTRATO.idFilial == CONTRATO.idFilial ; && "11" 
           AND CONTRATO.situacao = "ATIVO" ;
           AND CONTRATO.dataBase <= {^2009-12-08} ;
           AND CONTRATO.valor>0;
           AND RCONTRAT.taxa_bol > 0;
   order by    CONTRATO.idFilial, CONTRATO.dia_vencimento, CONTRATO.tipo_contrato, CONTRATO.idContrato  ;
   group by    CONTRATO.idContrato 

