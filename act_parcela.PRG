CLOSE DATABASES all
CLOSE TABLES all
CLEAR



USE \\dcrpo\bdmdc$\associado IN 0
USE \\dcrpo\bdmdc$\associado_plano IN 0

SELECT associado_plano
SET ORDER TO IDASSOC   && IDASSOC


SELECT aa.idAssoc, aa.dataVigor ;
FROM   \\dcrpo\bdmdc$\associado aa ;
WHERE  aa.situacao='ATIVO' AND ;
       aa.atendimento=.t. AND ;
       !EMPTY(aa.dataVigor) AND aa.dataVigor <={^2007-12-31} ;
ORDER BY    aa.idAssoc ;
INTO CURSOR CTMP

SELECT CTMP
SCAN ALL

   nId = CTMP.idAssoc
   
   SELECT ASSOCIADO_PLANO
   IF SEEK( nID, 'ASSOCIADO_PLANO', 'IDASSOC' )
      SCAN WHILE idAssoc == nID AND dtInc <= {^2007-12-31}
          ?? [.]

            dFatu = DATE( 2008, 07, DAY(CTMP.dataVigor) )
            nParc = FI_QUANT_PARCELA( dFatu, CTMP.dataVigor )
       
         IF nParc > Associado_plano.parcela
            replace Associado_plano.parcela WITH nParc
         ENDIF
      ENDSCAN 
   ENDIF 
   
   SELECT CTMP
ENDSCAN  


*---
clear
CLOSE DATABASES all
CLOSE TABLES all
USE \\dcrpo\bdmdc$\areceber_cms IN 0
USE \\dcrpo\bdmdc$\areceber IN 0
USE \\dcrpo\bdmdc$\associado IN 0
SELECT associado
SET ORDER TO idassoc
SELECT areceber 
SET ORDER TO controle
SELECT areceber_cms
GO TOP 
SCAN all
   =SEEK( controle, 'ARECEBER', 'controle' )
   =SEEK( chave,    'ASSOCIADO', 'IDASSOC' )
   IF LEFT(DTOS(areceber.data_vencimento),6)>='200806'
      ?? [*]
      replace parcela WITH FI_QUANT_PARCELA( areceber.data_vencimento, associado.dataVigor )
   ELSE
      ?? [.]
   ENDIF
ENDSCAN 


#IF 1=2
   SELECT aa.* ;
   FROM   areceber_cms aa ;
   JOIN   areceber bb ON aa.controle == bb.controle ;
   WHERE  bb.data_vencimento BETWEEN {^2008-06-01} AND {^2008-06-30} ;
   INTO CURSOR CTMP

   CLEAR 

   SELECT CTMP
   SCAN all
      
      SELECT      aa.parcela ;
      FROM        associado_plano aa ;
      WHERE       aa.idassoc == CTMP.chave ;
        AND       aa.idPlano == CTMP.idprod;
        AND       aa.idVend == CTMP.idVend ;
      INTO CURSOR CXXX

      IF _TALLY > 0 AND CTMP.parcela < CXXX.parcela
         UPDATE ARECEBER_CMS SET parcela = CXXX.parcela ;
         WHERE  controle = CTMP.controle ;
            AND chave    = CTMP.chave ;
            AND idvend   = CTMP.idVend ;
            AND idprod   = CTMP.idProd
         ?? TRANSFORM(_TALLY)
      ELSE 
         ?? [*]
      ENDIF

      SELECT CTMP   
   ENDSCAN 
#ENDIF