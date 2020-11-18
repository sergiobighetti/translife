CLOSE DATABASES all
CLOSE TABLES ALL
CLEAR
SELECT      idAssoc, codigo, codigo newcod, nome, situacao ;
FROM        \\dcrpo\bdmdc$\associado ;
WHERE       idContrato=64988 ;
  AND       codigo IN ( '02LP000828AA', '02LP000054AA' ) ;
ORDER BY    1 ;
INTO CURSOR CXXX READWRITE

SELECT CXXX
SCAN all

   ?? [.]
   nID     = CXXX.idAssoc
   cNewCOD = NovaChave( "02", "02LP", '00' )
   
   replace newCod WITH cNewCod

      UPDATE \\dcrpo\bdmdc$\ASSOCIADO        ;
      SET    codigo = cNewCOD ;
      WHERE  idAssoc == nID

ENDSCAN 


brow