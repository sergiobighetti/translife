CLEAR 

? 'Contrato '
SELECT ;
       aa.idContrato ;
       ,SPACE( 40 ) as prods ;
FROM   CONTRATO  aa ;
WHERE aa.situacao='ATIVO' ;
AND idFilial in ('01','02','04' ) ;
INTO CURSOR LV_CTR READWRITE 

?? _Tally 
?

SELECT LV_CTR
SCAN ALL

   ?? [.]
   
   nId = LV_CTR.idContrato
   
   SELECT DISTINCT PADL(aa.idPlano,3,'0' ) AS PLN ;
   FROM   ASSOCIADO_PLANO aa ;
   JOIN   ASSOCIADO bb ON bb.idAssoc=aa.idAssoc ;
   WHERE  bb.idContrato= nID ;
      AND bb.situacao='ATIVO' ;
      AND bb.atendimento=.t. ;
   ORDER BY aa.idPlano ;
   INTO CURSOR TMP

   cPln = ''
   SCAN all
      cPln = cPln +','+PLN
   ENDSCAN 
      
      
   SELECT LV_CTR
   replace prods WITH cPln
      
ENDSCAN 