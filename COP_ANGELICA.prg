SELECT aa.idContrato, aa.nome_responsavel, aa.dia_vencimento, aa.tipo_parcela, ;
       ( SELECT COUNT(bb.idContrato) FROM CONTRATO_COP bb WHERE aa.idContrato==bb.idContrato ) QTD_COP ;
FROM   contrato aa ;
WHERE  aa.situacao='ATIVO' ;
INTO CURSOR CBASE

SELECT * FROM cBASE WHERE QTD_COP > 0 INTO CURSOR CBS2


SELECT aa.*,;
       ( SELECT COUNT(bb.id) ;
         FROM   ATENDIMENTO bb ;
         WHERE         bb.ctrNumero == aa.idContrato ;
                   AND bb.formarec  = 5    ;               && COBRANDO NO FATURAMENTO
                   AND bb.codatendimento = 17 ;             && ATENDIDO COMO CUSTO OPERACIONAL
                   AND bb.situacao  == 2 ;                 && ENCERRADO
                   AND bb.liberacao == 2 ;                 && LIBERADO  
                   and bb.valorcobranca > $0 ;             && QUE VALOR >= 0
                   AND EMPTY(bb.idcancelamento) ;          && NAO ESTA CANCELADO
                   AND EMPTY(bb.faturamento) ) as qtd_atend ;
FROM CBS2 aa ;
into cursor xxx

SELECT * FROM xxx WHERE   qtd_atend >0    ORDER BY dia_vencimento        
       