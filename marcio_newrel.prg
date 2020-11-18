LOCAL cAAMM
cAAMM     = '200803'
cAAMM_ANT = '200802'
cTipo     = 'COL,FAM'

SELECT       TOP 40 ;
             aa.idContrato                    CTR_ID,;
             bb.tipo_contrato                 CTR_TIPO,;
             bb.nome_responsavel              CTR_NOME,;
             bb.nrovidas                      CTR_VIDAS,;
             bb.valor                         CTR_VALOR,;
             LEFT(DTOS(aa.data_vencimento),6) AAAAMM_VCTO,;
             ;
             SUM(aa.valor_documento)          VLR_FATURADO,;
             COUNT(aa.controle)               QTD_DOCTOS ;
             ;
FROM        areceber aa ;
JOIN        contrato bb on aa.idContrato == bb.idContrato ;
WHERE       LEFT(DTOS(aa.data_vencimento),6) == cAAMM ;
  AND       LEFT(bb.tipo_contrato,3) $ cTipo ;
GROUP BY    1,2,3,4,5,6 ;
ORDER BY    VLR_FATURADO DESC ;
INTO CURSOR CLV_1



SELECT aa.*,;
            ( SELECT COUNT(bb.id) FROM ATENDIMENTO bb ;
              WHERE  bb.ctrnumero == aa.ctr_ID  AND bb.idCancelamento=0 AND bb.situacao == 2 AND bb.liberacao == 2 ;
                AND LEFT(DTOS(tm_chama),6)=cAAMM_ANT ;
            ) QTD_ATEND ;
FROM   CLV_1 aa ;
INTO CURSOR CLV_2

SELECT aa.*, IIF(aa.qtd_atend=0,00000.00000,aa.QTD_ATEND/aa.ctr_vidas)*100 ATEND_DIV_VIDAS  FROM CLV_2 aa 
         
         
