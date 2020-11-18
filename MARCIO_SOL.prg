*-- vidas p/ Tipo de Contrato e Forma de Pagamento
SELECT tipo_contrato, forma_pagamento, COUNT(idContrato) qtd_Contr, SUM(nroVidas) qtd_Vidas ;
FROM   contrato ;
WHERE  idFilial='01' AND situacao='ATIVO' ;
GROUP  by 1,2 ;
order  by 1,2 ;
INTO CURSOR CTMP
COPY TO C:\TEMP\Planilha1.XLS TYPE XLS

*-- vidas p/ Forma de Pagamento
SELECT forma_pagamento, COUNT(idContrato) qtd_Contr, SUM(nroVidas) qtd_Vidas ;
FROM   contrato ;
WHERE  idFilial='01' AND situacao='ATIVO' ;
GROUP  by 1 ;
order  by 1 ;
INTO CURSOR CTMP
COPY TO C:\TEMP\Planilha2.XLS TYPE XLS

*-- contratos com transporte monitorado p/ forma de pagamento
SELECT b.forma_pagamento, COUNT(a.idContrato) qtd_Contr, SUM(b.nroVidas) qtd_Vidas ;
FROM   RCONTRAT a ;
JOIN   CONTRATO b ON a.idContrato=b.idContrato;
WHERE  b.idFilial='01'  AND b.situacao='ATIVO' AND a.transp_mes>0 ;
GROUP  by 1 ;
order  by 1 ;
INTO CURSOR CTMP
COPY TO C:\TEMP\Planilha3.XLS TYPE XLS

*-- contratos familiares ATIVOS > 01/01/2008
SELECT forma_pagamento, COUNT(idContrato) qtd_Contr, SUM(nroVidas) qtd_Vidas ;
FROM   contrato ;
WHERE  tipo_contrato='FAMILIAR' AND idFilial='01' AND situacao='ATIVO' AND data_cadastro >={^2008-01-01};
GROUP  by 1 ;
order  by 1 ;
INTO CURSOR CTMP
COPY TO C:\TEMP\Planilha4.XLS TYPE XLS

*-- quantidade de lancamentos no database motivo 25
SELECT COUNT(*) FROM newdb WHERE tpcontato=25 AND DTOS(cadastro) >= '20080101' ;
INTO CURSOR CTMP
COPY TO C:\TEMP\Planilha5.XLS TYPE XLS