CD \\dcrpo\bdmdc$

CLOSE DATABASES all
CLOSE TABLES all

CLEAR

SELECT   ;
         aa.forma_pagamento  FORMAPG,;
         aa.nome_responsavel RESP, ;
         aa.idContrato       , ;
         aa.dia_vencimento   DIA ,;
         aa.situacao,;
         aa.tipo_contrato,;
         bb.transp_mes,; 
         bb.transp_vlr,;
         ;
         000000000 ctrl,  ;
         SPACE(10) SIT_BX ;
         ;
FROM     CONTRATO aa ;
JOIN     RCONTRAT bb ON aa.idContrato == bb.idContrato ;
WHERE    bb.transp_mes =12 AND aa.dia_vencimento=5    ;
         ;
         ; && AND aa.forma_pagamento='CART' AND aa.situacao='ATIVO' 
         ;
order by 1 ;
INTO CURSOR CBASE READWRITE

*!*   SELECT SITUACAO, COUNT(*) FROM CBASE GROUP BY 1
*!*   SELECT SITUACAO, SIT_BX, COUNT(*) FROM CBASE GROUP BY 1,2
*!*   SELECT SITUACAO, SIT_BX, FORMAPG, COUNT(*) FROM CBASE GROUP BY 1,2,3


SELECT CBASE
SCAN ALL

   nIDC = CBASE.idContrato
   
   SELECT controle, SITUACAO ;
   FROM   ARECEBER ;
   WHERE  IDCONTRATO = nIDC AND ref='200612' AND origem='FATURAMENT' ;
   INTO ARRAY aTmp
   
   IF _TALLY > 0
      replace CBASE.ctrl   WITH aTmp[1]
      replace CBASE.SIT_BX WITH aTmp[2]
      ??[.]
   ELSE
      ?? [*]
   ENDIF
   
ENDSCAN 


SELECT aa.*,;
       bb.valor_documento       VLR_AR,;
       ( SELECT SUM(cc.vlr_recebido) VLR_BX FROM BXAREC cc WHERE cc.controle == aa.ctrl ) BAIXADO ;
FROM   CBASE aa ;
JOIN   ARECEBER bb ON aa.ctrl == bb.controle ;
WHERE  aa.sit_BX='LIQUIDADO' AND aa.ctrl>0 ;
INTO CURSOR CXXX


SELECT aa.*,;
       (aa.vlr_ar-aa.baixado) DIFER ;
FROM   CXXX aa ;
WHERE  (aa.vlr_ar-aa.baixado) > 0 ;
INTO CURSOR Cyyy


SELECT (vlr_ar-baixado) VLR_MENOS_BAIXA, COUNT(*) qtd FROM Cyyy GROUP BY 1 ORDER BY 1

