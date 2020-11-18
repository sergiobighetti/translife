
SELECT LEFT(bb.codigo,2) as Filial, aa.idPlano, cc.Descricao, COUNT(*) as qtd, SUM(aa.valor) as valor ;
FROM  ASSOCIADO_PLANO aa ;
JOIN  ASSOCIADO bb ON aa.idAssoc=bb.idAssoc ;
JOIN  PLANOS cc ON aa.idPlano=cc.plano ;
WHERE  aa.idPlano in (31,32) and bb.situacao='ATIVO' and bb.atendimento=.t. ;
group by 1, 2, 3 ;
order by 1, 2, 3 