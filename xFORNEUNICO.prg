SELECT ;
         AA.idfilial ;
       , AA.codigo   ;
       , AA.idFavorecido ;
       , ( SELECT COUNT(*) FROM apagar xx WHERE xx.idfilial=aa.idfilial AND xx.codigo_fornecedor=aa.codigo) as QTD ;
FROM   FAVORECIDO AA INTO cursor LV_VER


SELECT * FROM LV_VER WHERE qtd > 0 INTO cursor LV_XXX


