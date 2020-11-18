
dRef = {^2019-12-01} && ou date()

SELECT  ;
        IIF( ( aa.data_vencimento-dRef ) < 0,'VENCIDO ', 'A VENCER') as Situacao ;
      , abs( ( aa.data_vencimento-dRef ) ) as nDias ;
      , aa.data_vencimento ;
      , aa.valor_documento as vNOMINAL ;
      , LEFT( DTOS(aa.data_vencimento),6) as anoMes ;
FROM   APAGAR aa  ;
WHERE  EMPTY(aa.data_baixa) ;
INTO CURSOR LV_BASE

SUM vNOMINAL TO nTot

SELECT xx.situacao, xx.vNominal,  ((xx.vNominal/nTot)*100) as nPerc, REPLICATE( '|', (xx.vNominal/nTot)*80 ) as xChart ;
FROM ( SELECT Situacao, SUM(vNOMINAL) as vNOMINAL FROM  LV_BASE ) xx



