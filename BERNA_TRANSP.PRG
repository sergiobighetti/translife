SELECT ;
       idfilial FILIAL,;
       LEFT(DTOS(FAT_VENCIMENTO),6) ANO_MES,;
       COUNT(*)  QUANT_TRANSP,;
       SUM( valor_inicial+ IIF(hrp_quant>0,hrp_valor,0)-desconto+acrescimo ) VALOR_TRANP ;
FROM   transp ;
WHERE  situacao='6' .and. LEFT(DTOS(FAT_VENCIMENTO),6) BETWEEN '200701' AND '200711';
ORDER BY 1,2 ;
GROUP BY 1,2 
  
  
  
  
SELECT ;
       idfilial FILIAL,;
       LEFT(DTOS(FAT_VENCIMENTO),6) ANO_MES,;
       COUNT(*)  QUANT_EVENTO,;
       SUM(  total ) VALOR_EVENTO ;
FROM   EVENTO ;
WHERE  situacao='6' .and. LEFT(DTOS(FAT_VENCIMENTO),6) BETWEEN '200701' AND '200711';
ORDER BY 1,2 ;
GROUP BY 1,2 




SELECT ;
       '01' FILIAL,;
       LEFT(DTOS(bb.dataag),6) anomes,;
       IIF(bb.tipo_agenda=1,'ENFERMAGEM    ',;
       IIF(bb.tipo_agenda=2,'FISIOTERAPIA  ',;
       IIF(bb.tipo_agenda=3,'COLETA        ',;
       IIF(bb.tipo_agenda=4,'NUTRICAO      ',;
       IIF(bb.tipo_agenda=5,'FONOAUDIOLOGIA',;
       IIF(bb.tipo_agenda=6,'ACOMPANHAMENTO',;
       IIF(bb.tipo_agenda=7,'HOMECARE      ', '' ))))))) Tipo,;
       ;
       SUM( aa.valor-aa.desconto ) VALOR ;
FROM   agenda_proc aa ;
JOIN   agenda bb ON aa.idAgenda == bb.i_d ;
WHERE  LEFT(DTOS(dataag),6) BETWEEN '200701' AND '200711' AND situacao='Realizado ' ;
GROUP BY 1,2,3 ;
ORDER BY 1,2,3
