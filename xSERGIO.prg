CLOSE DATABASES ALL
SET ESCAPE ON
clear

cArq = GETFILE('dbf')


USE (cArq) IN 0 ALIAS LV_VER
tAgora = DATETIME()
nQtdF = AFIELDS( aFld, 'LV_VER' )
xNomeArq = STRTRAN( JUSTFNAME(cArq), '.DBF', '' )



DO CASE
   CASE xNomeArq  = 'ASSOCIADO'
      cCampoID = 'idAssoc'
   CASE xNomeArq  = 'CONTRATO'
      cCampoID = 'idContrato'
ENDCASE

IF EMPTY(cCampoID)
   RETURN
ENDIF

CREATE CURSOR FALHAS ( falhas C(200) )

SET STEP ON 
SELECT LV_VER

GO TOP 
cTd = ''

SCAN ALL
   
  
   cSql = ''

   cUpd = 'UPDATE '+xNomeArq  +" SET dtBase='"+ TTOC_SQL( LV_VER.database )+"' WHERE " +cCampoID +'='+TRANSFORM(EVALUATE(cCampoID))
   nOk  = SQLEXEC( conexao(), cUpd )
      IF nOk   < 0
         _ClipText = cUpd 
         INSERT INTO FALHAS VALUES ( cUpd )
         ? 'Falhou!!!'
      ENDIF 
   
      @ 10, 10 say TRANSFORM(RECNO())+ ' de '+TRANSFORM(RECCOUNT())
   
   
ENDSCAN 


CLOSE DATABASES ALL
? DATETIME() - tAgora



