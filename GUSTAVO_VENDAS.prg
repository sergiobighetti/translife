cFil = '01'
dIni = {^2008-09-01}
dFim = {^2009-09-30}

SELECT DISTINCT ;
       ap.idAssoc, ap.idVend, LEFT(DTOS(ap.dtInc),6) ANOMES,  ;
       IIF( aa.situacao='ATIVO', 0001, 0000 ) qtdA,  ;
       IIF( aa.situacao#'ATIVO', 0001, 0000 ) qtdC, ;
       ;
       SUM( IIF( aa.situacao='ATIVO', aa.valor, $0 ) ) VALOR_A, ;
       SUM( IIF( aa.situacao#'ATIVO', aa.valor, $0 ) ) VALOR_C  ;
       ;
FROM   ASSOCIADO_PLANO  ap ;
JOIN   ASSOCIADO aa ON ap.idAssoc = aa.idAssoc ;
WHERE   ap.idVend>0 ;  && somente os que tem vendedor
   AND  ap.idVend<>999; && que nao seja medicar
   AND  aa.codigo=cFil ;  && somente RIBEIRAO
   AND  ap.dtInc BETWEEN dIni AND dFim ; && dentro do periodo
GROUP BY   1,2,3,3,4 ;
ORDER BY   1,2,3 ;
INTO CURSOR CVER1

Select               ;
                     ctr.idContrato             idAssc,;
                     ctr.vendedor               idVend,;
                     LEFT(DTOS(ctr.dataVigor),6) ANOMES,;
                     SUM(IIF( ctr.situacao='ATIVO', 0001, 0000 )) qtdA,  ;
                     SUM(IIF( ctr.situacao#'ATIVO', 0001, 0000 )) qtdC, ;
                     SUM(IIF( ctr.situacao='ATIVO', ctr.valor, $0 )) valor_a,  ;
                     SUM(IIF( ctr.situacao#'ATIVO', ctr.valor, $0 )) valor_C  ;
                     ;
FROM                 CONTRATO ctr ;
WHERE   ctr.vendedor>0 ;  && somente os que tem vendedor
   ; && AND  ctr.vendedor<>999 && que nao seja medicar
   AND  ctr.codigo=cFil ;  && somente RIBEIRAO
   AND  ctr.dataVigor BETWEEN dIni AND dFim ; && dentro do periodo
   AND  LEFT(ctr.tipo_contrato,3) IN ( 'ARE', 'REM' ) ;
GROUP BY   ctr.idContrato, ctr.vendedor, ctr.dataVigor ;
ORDER BY   ctr.idContrato, ctr.vendedor, ctr.dataVigor ;
INTO CURSOR CVER2

SELECT * FROM CVER1 UNION ALL SELECT * FROM CVER2 INTO CURSOR CVER


SELECT aa.idVend, ven.nome, TRANSFORM(aa.anomes,'@R 9999/99') Ano_Mes, ;
       ;
       SUM(aa.qtdA+qtdC          ) VIDAS_TOTAL, ;
       SUM(aa.valor_A+aa.valor_C ) VALOR_TOTAL,;
       ;
       SUM(aa.qtdA)                VIDAS_ATIVAS,; 
       SUM(aa.valor_A)             VALOR_ATIVO,;
       ;
       SUM(aa.qtdC)                VIDAS_CANC, ;
       SUM(aa.valor_C )            VALOR_CANC;
       ;
FROM              CVER aa ;
LEFT Outer Join   FAVORECIDO ven On  ven.idFilial=cFil And aa.idVend == ven.codigo ;
GROUP BY 1,2,3 ORDER BY 1,2,3
   
