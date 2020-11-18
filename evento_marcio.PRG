


Select          DISTINCT ;
                ;
                EVENTO.idEvento           I_D,;
                LEFT(EVENTO.fat_codigo,2) FIL_FAT,;
                EVENTO.idfilial           FIL_ATE,;
                ;
                EVENTO.eve_nome           EVE_NOME,;
                TTOD(EVENTO.prev_inicio)  PAC_DATA,;
                ;
                EVENTO.fat_forma                    EV_FORMAPGTO,;
                evento.permuta                      EV_PERMUTA ,;
                evento.total                        EV_VALOR,;
                NVL( ( select SUM(ee.valor) FROM EVENTO_EQUIPE ee WHERE ee.idevento=EVENTO.idevento ), $0 ) EV_VALOR_EQP, ;
                EVENTO.desp_extra+EVENTO.pedagio    EV_DESPESAS,;
                ;
                EVENTO.fat_nome            NOMEFAT,;
                NVL(CONTRATO.idContrato,0) IDCONTRATO,;
                EVENTO.fat_controle        ID_REC ;
                ;
               ,NVL(ARECEBER.numero_documento,SPACE(14))   as AR_DOCUMENTO;
               ,NVL(ARECEBER.valor_documento,$0)           as AR_VALOR;
               ,EVENTO.fat_vencimento                      as EV_VENCTO;
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
from            EVENTO ;
LEFT OUTER JOIN CONTRATO ON ALLTRIM(EVENTO.fat_codigo)=CONTRATO.codigo ;
LEFT OUTER JOIN ARECEBER ON EVENTO.fat_controle = ARECEBER.controle ;
LEFT OUTER JOIN NFISCAL  ON ARECEBER.idnf = NFISCAL.controle ;    
where           EVENTO.situacao="6" AND !EMPTY(EVENTO.v_central) ;
                AND EVENTO.idEvento in (617,618,619) ;
GROUP BY        EVENTO.idEvento ;
ORDER BY        EVENTO.idfilial, EVENTO.fat_codigo


                ; &&AND DTOS(EVENTO.prev_inicio) >= '2010010' 

