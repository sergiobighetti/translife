SET ESCAPE ON

select      ;
            cc.tipo_contrato,;
            aa.idPlano      ,;
            dd.descricao    ,;
            aa.valor        ,;
            COUNT(aa.idAssoc) quant ;
            ;
from        associado_plano aa;
join        associado bb on aa.idAssoc   == bb.idAssoc;
join        contrato cc on bb.idContrato == cc.idContrato;
join        planos dd on aa.idPLano      == dd.plano ;
where       cc.situacao='ATIVO' AND bb.atendimento = .t. AND aa.idPlano in (4,19,20,30) ;
group by    1,2,3,4 ;
order by    1,2,3,4 