CLOSE DATABASES ALL
CLOSE TABLES ALL
SET ESCAPE ON
CLEAR
USE ajustepc IN 0
USE PCONTA  IN  0
SELECT AjustePC
SCAN all
   cCod = ALLTRIM(AjustePC.codigo)
   
   SELECT PCONTA
   LOCATE FOR ALLTRIM(codigo) == cCod
   IF FOUND()
      replace ctb_reduzida WITH AjustePC.id_ctb
      ?? [.]
   ELSE
      ?? [*]
   ENDIF 
SELECT AjustePC
ENDSCAN 

CLOSE DATABASES all
