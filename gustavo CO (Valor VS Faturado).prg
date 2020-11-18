SELECT aa.idfilial as FILIAL,  aa.idContrato, aa.tipo_contrato, aa.nome_responsavel, aa.dia_vencimento, aa.tipo_parcela, aa.valor as valorBase, ;
       ( SELECT COUNT(bb.idContrato) FROM CONTRATO_COP bb WHERE aa.idContrato==bb.idContrato ) QTD_COP ;
FROM   contrato aa ;
WHERE  aa.situacao='ATIVO' ;
INTO CURSOR CBASE

SELECT * FROM cBASE WHERE QTD_COP > 0 INTO CURSOR CBS2





       SELECT  ;
          aa.idcontrato ;
        , LEFT(DTOS(aa.data_vencimento),6) as ANOMES ;
        , SUM(valor_documento) as ValorFAT ; 
FROM   ARECEBER aa ;
WHERE  aa.data_vencimento between {^2016-01-05} and {^2017-04-30} and aa.origem='FATURAMENT' AND aa.idcontrato in (SELECT idContrato FROM CBS2) ;
GROUP BY 1,2 ;
ORDER BY 1,2 ;
INTO CURSOR LV_FAT

SELECT ;
CBS2.idcontrato, CBS2.filial,  CBS2.tipo_contrato, CBS2.nome_responsavel, CBS2.dia_vencimento, CBS2.tipo_parcela, CBS2.valorbase, LV_FAT.anomes, LV_FAT.valorfat ;
FROM LV_FAT ; 
JOIN CBS2 ON CBS2.idcontrato= LV_FAT.idcontrato ;
ORDER BY CBS2.idcontrato, LV_FAT.anomes


SELECT * FROM xxx WHERE   qtd_atend >0    ORDER BY dia_vencimento        
       