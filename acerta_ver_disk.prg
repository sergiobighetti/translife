CLOSE DATABASES all
USE ver_disk   
*!*   BEGIN TRANSACTION 

SET TEXTMERGE TO c:\NAOACERTOU.TXT NOSHOW
SET TEXTMERGE ON

SCAN all
   
   nID      = ver_disk.idassoc   
   nProdOLD = 4
   nProdNEW = INT(VAL(ver_disk.cpd))

   UPDATE \\dcrpo\bdmdc$\associado_plano ;
      SET idplano = nProdNEW ;
   WHERE  associado_plano.idAssoc = nID AND ;
          associado_plano.idplano = nProdOLD
   
   IF _TALLY = 0
      \IDASSOC: <<idassoc>> Nome: <<nome>> #Rec: <<RECNO()>>
      ?? "*"
      INKEY(0)
   ELSE
      ?? [.]
   ENDIF
   
ENDSCAN 

SET TEXTMERGE off
SET TEXTMERGE to

*!*   ROLLBACK 