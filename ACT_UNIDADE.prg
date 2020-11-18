CLOSE DATABASES all
CLOSE TABLES all

SELECT * FROM C:\FRT_OLD INTO CURSOR CVER

CLEAR

SCAN all

   
   nNewID  = NewID
   
   cOldFil = idFilial
   nOldID  = unidade
   ?
   ? nOldID
   ?? ' para '
   ?? nNewID
   
   ? [AG]
   UPDATE agenda      SET idunidade      = nNewID WHERE idunidade      = nOldID AND codassoc = cOldFil
   ?? _TALLY

   ? [AT]
   UPDATE atendimento SET idUnidadeMovel = nNewID WHERE idUnidadeMovel = nOldID AND idfilial = cOldFil
   ?? _TALLY

   ? [HA]
   UPDATE hstAtend    SET idUnidadeMovel = nNewID WHERE idUnidadeMovel = nOldID AND idfilial = cOldFil
   ?? _TALLY

   ? [ES]
   UPDATE escala      SET unidademovel   = nNewID WHERE unidademovel   = nOldID AND idFilial = cOldFil
   ?? _TALLY

   ? [TR]
   UPDATE transp      SET idunidade      = nNewID WHERE idunidade      = nOldID AND idfilial = cOldFil
   ?? _TALLY
   
ENDSCAN 



CLOSE DATABASES all
CLOSE TABLES all

SELECT * FROM C:\FRT_new INTO CURSOR CVER

CLEAR

SCAN all

   
   nNewID  = NewID
   
   cOldFil = idFilial
   nOldID  = unidade
   ?
   ? nOldID
   ?? ' para '
   ?? nNewID
   
   ? [AG]
   UPDATE agenda      SET idunidade      = nNewID WHERE idunidade      = nOldID AND codassoc = cOldFil
   ?? _TALLY

   ? [AT]
   UPDATE atendimento SET idUnidadeMovel = nNewID WHERE idUnidadeMovel = nOldID AND idfilial = cOldFil
   ?? _TALLY

   ? [HA]
   UPDATE hstAtend    SET idUnidadeMovel = nNewID WHERE idUnidadeMovel = nOldID AND idfilial = cOldFil
   ?? _TALLY

   ? [ES]
   UPDATE escala      SET unidademovel   = nNewID WHERE unidademovel   = nOldID AND idFilial = cOldFil
   ?? _TALLY

   ? [TR]
   UPDATE transp      SET idunidade      = nNewID WHERE idunidade      = nOldID AND idfilial = cOldFil
   ?? _TALLY
   
ENDSCAN 




CLOSE DATABASES all
CLOSE TABLES all

   ?
   ? "Acertando ... "
   
   ? [AG]
   UPDATE agenda      SET idunidade      = idunidade - 80000 WHERE idunidade > 80000 
   ?? _TALLY

   ? [AT]
   UPDATE atendimento SET idUnidadeMovel = idUnidadeMovel - 80000 WHERE idUnidadeMovel > 80000 
   ?? _TALLY

   ? [HA]
   UPDATE hstAtend    SET idUnidadeMovel = idUnidadeMovel - 80000 WHERE idUnidadeMovel > 80000 
   ?? _TALLY

   ? [ES]
   UPDATE escala      SET unidademovel   = unidademovel  - 80000 WHERE unidademovel > 80000 

   ? [TR]
   UPDATE transp      SET idunidade      = idunidade - 80000 WHERE idunidade > 80000 
   ?? _TALLY
   



