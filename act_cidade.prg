CLEAR 

CLOSE DATABASES ALL
CLOSE TABLES 
USE C:\ACTCID IN 0
USE \\dcrpo\BDMDC$\CONTRATO IN 0
USE \\dcrpo\BDMDC$\ASSOCIADO IN 0

SELECT ACTCID
SCAN ALL

   cCidATU = actcid.cidade
   cCidNEW = 'RIBEIRAO PRETO'
   
   UPDATE contrato ;
   SET    cidade = cCidNEW ;
   WHERE  cidade == cCidAtu
   IF _TALLY > 0
      ?? [1]
   ELSE
      ?? [.]
   ENDIF

   UPDATE contrato ;
   SET    cob_cid = cCidNEW ;
   WHERE  cob_cid == cCidAtu
   IF _TALLY > 0
      ?? [2]
   ELSE
      ?? [.]
   ENDIF

   UPDATE associado ;
   SET    cidade = cCidNEW ;
   WHERE  cidade == cCidAtu
   ?? [3]
   
   ?? '.'


SELECT ACTCID
ENDSCAN 

CLOSE DATABASES ALL 
CLOSE TABLES ALL

* SELECT distinct cidade FROM contrato WHERE cidade like "B%"

