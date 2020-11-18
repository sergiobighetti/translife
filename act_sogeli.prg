CLOSE DATABASES all
CLOSE TABLES ALL

USE \\dcrpo\bdmdc$\associado IN 0
USE table1 IN 0

SET ESCAPE ON

SELECT associado
SET ORDER TO IDCONTRATO   && IDCONTRATO
           
GO top
LOCATE FOR idContrato=52246

SCAN WHILE idContrato=52246
  
   cOld = ALLTRIM(Associado.codorigem)
   
   IF LEN(cOld) = 13
     IF SEEK( cOld, 'TABLE1', 'OLD' )
        ?? [.]
        replace Associado.codorigem WITH TABLE1.new
     ELSE
        ?? [*]+cOld+ '  '+ TRANSFORM(LEN(cOld))   
        * =INKEY(0)
     ENDIF
   ELSE
     ?? [-]
   ENDIF

   SELECT associado
ENDSCAN 