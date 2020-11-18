CLOSE DATABASES all
CLOSE TABLES all

SELECT aa.idContrato, aa.codigo, aa.nome, ap.idPlano ;
FROM   \\dcrpo\bdmdc$\ASSOCIADO_PLANO ap ;
JOIN   \\dcrpo\bdmdc$\ASSOCIADO aa ON ap.idAssoc = aa.idAssoc ;
JOIN   \\dcrpo\bdmdc$\CONTRATO  cc ON aa.idContrato = cc.idContrato ;
WHERE  aa.atendimento=.t. ;
   AND ap.idPlano in (31,32) ;
   AND cc.idFilial ='01' ;
   AND (  ( aa.situacao='ATIVO' AND aa.ativacao<={^2009-09-30} ) OR ( aa.situacao='CANC'  AND aa.dataExc<={^2009-09-30} ) ) ;
ORDER BY aa.codigo ;
INTO TABLE c:\TEMP\SOL_092009


SELECT aa.idContrato, aa.codigo, aa.nome, ap.idPlano ;
FROM   \\dcrpo\bdmdc$\ASSOCIADO_PLANO ap ;
JOIN   \\dcrpo\bdmdc$\ASSOCIADO aa ON ap.idAssoc = aa.idAssoc ;
JOIN   \\dcrpo\bdmdc$\CONTRATO  cc ON aa.idContrato = cc.idContrato ;
WHERE  aa.atendimento=.t. ;
   AND ap.idPlano in (31,32) ;
   AND cc.idFilial ='01' ;
   AND (  ( aa.situacao='ATIVO' AND aa.ativacao<={^2009-10-31} ) OR ( aa.situacao='CANC'  AND aa.dataExc<={^2009-10-31} ) ) ;
ORDER BY aa.codigo ;
INTO TABLE c:\TEMP\SOL_102009

*Período: 01/09 a 30/09 = total de ATIVOS   
*Período: 01/10 a 30/10 = Total de ATIVOS. 