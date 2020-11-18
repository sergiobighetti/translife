
CLOSE DATABASES all
CLOSE TABLES all


SELECT cc.idFilial, cc.vendedor, NVL(ff.nome,'** Vendedor ñ encontrato **') as NomeVendedor, SUBSTR( cc.codigo,3,2) as TIPO, cc.tipo_CONTRATO, COUNT(*) as quant, SUM(cc.valor) as VALOR, SUM(cc.NroVidas) as Vidas;
FROM   CONTRATO cc ;
LEFT JOIN FAVORECIDO ff ON cc.idFilial=ff.idFilial AND cc.vendedor=ff.CODIGO ;
WHERE cc.idFilial='02' AND cc.situacao='ATIVO' AND cc.database between {^2013-12-12} and {^2014-11-30} ;
GROUP BY 1,2,3,4,5  ;
ORDER BY 1,2,3,4,5 ;
INTO CURSOR LV_BASE


SELECT *, (VALOR/QUANT) VLR_MEDIO_CONTRATO FROM LV_BASE