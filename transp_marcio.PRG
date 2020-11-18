


Select          DISTINCT ;
                ;
                TRANSP.idTransp              I_D,;
                LEFT(TRANSP.fat_codigo,2)    FIL_FAT,;
                TRANSP.idfilial              FIL_ATE,;
                ;
                TRANSP_PACIENTE.nomepacien   PAC_NOME,;
                TRANSP.data_transporte       PAC_DATA,;
                ;
                TRANSP.fat_forma             TR_FORMAPGTO,;
                (TRANSP.valor_inicial-TRANSP.desconto+TRANSP.acrescimo) + IIF(TRANSP.hrp_quant>0,TRANSP.hrp_valor,0) TR_VALOR,;
                TRANSP.pedagio               TR_PEDAGIO,;
                TRANSP.extras                TR_EXTRA,;
                ;
                NVL( ( select SUM(ee.valor) FROM transp_equipe ee WHERE ee.idtransp=TRANSP.idtransp), $0 ) TR_VALOR_EQP, ;
                ;
                TRANSP.fat_nome              NOMEFAT,;
                NVL(CONTRATO.idContrato,0)   IDCONTRATO,;
                TRANSP.fat_controle          ID_REC ;
                ;
                ,NVL(ARECEBER.numero_documento,SPACE(14))   as AR_DOCUMENTO;
                ,NVL(ARECEBER.valor_documento,$0)           as AR_VALOR;
                ,TRANSP.fat_vencimento                      as TR_VENCTO;
                ,NVL(ARECEBER.data_vencimento,{})           as AR_VENCTO;
                ,NVL(ARECEBER.forma_pagto,SPACE(15))        as AR_FORMAPGTO;
                ,NVL(ARECEBER.codigo_subconta,00000000)     as AR_CONTA;
                ,NVL(ARECEBER.situacao,SPACE(10))           as AR_SITUACAO;
                ,NVL(nfiscal.numeronf,000000000)            as NF_NUMERO;
                ,NVL(nfiscal.dataemissao,{})                as NF_DATA;
                ;
                ,NVL( ( select SUM(c1.vlr_recebido) FROM BXAREC c1 WHERE c1.controle = ARECEBER.controle  ), $0) VlrBaixado;
                ,NVL( ( select SUM(c2.acrescimo)    FROM BXAREC c2 WHERE c2.controle = ARECEBER.controle  ), $0) acrescimo;
                ,NVL( ( select SUM(c3.desconto)     FROM BXAREC c3 WHERE c3.controle = ARECEBER.controle  ), $0) desconto;               
                ;
from            TRANSP ;
LEFT OUTER JOIN TRANSP_PACIENTE ON TRANSP_PACIENTE.idtransp=TRANSP.idTransp ;
LEFT OUTER JOIN CONTRATO        ON ALLTRIM(TRANSP.fat_codigo)=CONTRATO.codigo ;
LEFT OUTER JOIN ARECEBER        ON TRANSP.fat_controle = ARECEBER.controle ;
LEFT OUTER JOIN NFISCAL         ON ARECEBER.idnf = NFISCAL.controle ;    
where           TRANSP.situacao="6" AND !EMPTY(TRANSP.v_central) ;
            AND DTOS(TRANSP.data_transporte) >= '2010010' ;
GROUP BY        TRANSP.idTransp ;
ORDER BY        TRANSP.idfilial, TRANSP.fat_codigo

