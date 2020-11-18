nCtr = 66299
dHoje = DATE()

SELECT ; 
       cc.idContrato,;
       cc.codigo,;
       cc.nome,;
       cc.situacao,;
       cc.dataExc,;
       ;
       aa.idPlano,;
       bb.descricao,;
       aa.dtInc,;
       dHoje  Hoje,;
       CAST( (dHoje-aa.dtinc) as N (5) ) as dias, ;
       aa.valor ;
       ;
FROM   ASSOCIADO_PLANO  aa ;
JOIN   PLANOS bb ON aa.idPlano = bb.plano ;
JOIN   ASSOCIADO cc ON aa.idAssoc = cc.idAssoc ;
WHERE  cc.idContrato = nCtr       
