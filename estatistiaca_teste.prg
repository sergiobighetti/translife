SELECT aa.idAtendente,;
       eq.nome,;
       COUNT(aa.tmpBusca  ) qtd_atd,;
       ;
       MAX(ELAPTIME(aa.tm_chama,aa.tm_tarme,.t.)) xxx_max ,;
       MIN(ELAPTIME(aa.tm_chama,aa.tm_tarme,.t.)) xxx_min ,;
       AVG(ELAPTIME(aa.tm_chama,aa.tm_tarme,.t.)) xxx_avg ,;
       ;
       tstring(MAX(aa.tmpBusca)) tmp_max,;
       tstring(MIN(aa.tmpBusca)) tmp_min,;
       tstring(AVG(aa.tmpBusca)) tmp_med ;
FROM  ATENDIMENTO aa ;
JOIN  EQUIPE eq ON aa.idAtendente== eq.id ;
GROUP BY 1 ;
ORDER BY 3 desc,1

