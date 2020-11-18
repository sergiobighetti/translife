CLOSE DATABASES all
SET EXCLUSIVE OFF 
SET ESCAPE ON
CLEAR 
CD f:\master\tab

USE        canc363.DBF IN 0

SELECT      aa.codigo, aa.idAssoc, aa.situacao ;
FROM        associado aa  ;
JOIN   canc363 bb ON aa.codOrigem=bb.codigo ;
WHERE       aa.idContrato = 363 AND aa.situacao='ATIVO' ;
INTO CURSOR LV_CANC

SCAN all

   nID = LV_CANC.idAssoc
   
   dData    = {^2020-08-05}
   dDataExc = DATE()
   cMotv    = 'OUTROS'
   cMemo    = 'Ajuste de Ativos'+CHR(13)+'Cancelamento por demanda conforme ticket #556 AliasTi'

   UPDATE ASSOCIADO       ;
         SET situacao     = 'CANCELADO', ;
             datacancela  = dData, ;
             motivocancel = cMotv, ;
             dataExc      = dDataExc, ;
             motivo       = cMemo  ;       
   WHERE idAssoc=nID
   ?? TRANSFORM(_TALLY)

   SELECT LV_CANC
ENDSCAN 
