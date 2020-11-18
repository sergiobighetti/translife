CLOSE DATABASES all
CLOSE TABLES all
CLEAR

nContr = 67595


SELECT IDASSOC, CODIGO, NOME, codorigem, SPACE(20) as new_codorigem  ;
FROM   ASSOCIADO ;
WHERE  IDCONTRATO=nContr ;
AND    !EMPTY(codorigem) ;
INTO CURSOR LV_BASE READWRITE 


cArq = GETFILE('TXT' )  && pega o arquivo DE_PARA
create CURSOR LV_ORIGEM ( linha C(200) )
APPEND FROM (cArq) SDF

SELECT LV_ORIGEM
SCAN ALL
   ALINES( aCod, linha, 1, CHR(9) )
   
   cDe = aCod[1]
   cPa = aCod[2]
   
   IF !EMPTY(cDe)
      SELECT LV_BASE
      LOCATE FOR codOrigem = cDe
      IF FOUND()
         ?? '.'
         replace new_codorigem WITH cPa
      ELSE
         ?? '<NE '+ cDe +' NE>'
      ENDIF 
   ELSE
      ? '<PULO '+ cDe +' PULO>'
      ?
   ENDIF 
   SELECT LV_ORIGEM
ENDSCAN 

?
? 'Fim...'
?
? 'Ajustando: '


SELECT LV_BASE
SCAN FOR !EMPTY(NEW_codOrigem)

   IF SEEK( LV_BASE.idAssoc, 'ASSOCIADO', 'IDASSOC' )
      replace ASSOCIADO.codOrigem WITH LV_BASE.new_codOrigem 
      ?? '.'
   ELSE
      ?? 'Ñ'
   ENDIF 

   SELECT LV_BASE
ENDSCAN 

