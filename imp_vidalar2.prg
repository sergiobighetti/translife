CLOSE DATABASES ALL
CLOSE TABLES ALL
SET ESCAPE ON
SET EXCLUSIVE OFF 
CLEAR

cAls = SYS(2015)

** USE c:\desenv\win\vfp9\sca_new\UnidadeMovel IN 0 ALIAS DEST
USE \\dcrpo\bdmdc$\UnidadeMovel IN 0 ALIAS DEST

cArqOrigem = "C:\Users\Sergio\Desktop\MEDICAR\BKP Piracicaba\sca\UnidadeMovel"


SELECT      * ;
FROM        (cArqORIGEM) ;
WHERE       ativo=.t.;
INTO CURSOR (cAls)

SELECT (cAls)
SCAN ALL

   ?? [.]
   SCATTER NAME oReg MEMO 
   oReg.caracteristica = oReg.caracteristica +'|Filial:06:'+TRANSFORM(unidade)
   oReg.unidade = 600+RECNO()
   
   SELECT DEST
   APPEND BLANK
   GATHER NAME oReg FIELDS EXCEPT ID MEMO 
   
   SELECT (cAls)
   
ENDSCAN 

CLOSE DATABASES all
CLOSE TABLES ALL
