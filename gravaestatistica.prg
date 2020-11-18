LPARAM nCtrt
LOCAL tDataProc, lOpenEST, nSle

nSle     = SELECT()
lOpenEST = USED('CONTRATO_ESTATISTICA')

IF NOT lOpenEST
   USE CONTRATO_ESTATISTICA IN 0
   if CursorGetProp( 'Buffering', 'CONTRATO_ESTATISTICA' ) < 3
      =CursorSetProp( 'Buffering', 3, 'CONTRATO_ESTATISTICA' )
   endif
ENDIF   

tDataProc = dateTime()

SELECT       T.idAssoc AS Chave, ;
             T.situacao, ;
             T.atendimento, ;
             SUM( pl.valor ) AS valor ;
FROM         ASSOCIADO T ;
INNER JOIN   ASSOCIADO_PLANO pl ON T.idAssoc == pl.idAssoc ;
WHERE        T.idContrato == nCtrt ;
GROUP BY     T.idAssoc ;
INTO CURSOR  CTIT ;

USE IN ( SELECT( 'ASSOCIADO' ) )
USE IN ( SELECT( 'ASSOCIADO_PLANO' ) )

SELECT       'TIT'         AS Tipo,;
             T.situacao,;
             T.valor      AS VlrInd,;
             COUNT(*)     AS Quantidade,;
             SUM(T.valor) AS valor ;
FROM         CTIT T ;
GROUP BY     2, 3 ;
INTO CURSOR  CRSM


SELE CRSM
GO TOP

SCAN

	APPEND BLANK IN CONTRATO_ESTATISTICA
	REPLACE  ;
		CONTRATO_ESTATISTICA.idcontrato WITH nCtrt,;
		CONTRATO_ESTATISTICA.dataproc   WITH tDataProc,;
		CONTRATO_ESTATISTICA.tipo       WITH CRSM.tipo,;
		CONTRATO_ESTATISTICA.situacao   WITH CRSM.situacao,;
		CONTRATO_ESTATISTICA.vlrind     WITH CRSM.VlrInd,;
		CONTRATO_ESTATISTICA.quantidade WITH CRSM.quantidade,;
		CONTRATO_ESTATISTICA.valor      WITH CRSM.valor ;
	IN CONTRATO_ESTATISTICA

ENDSCAN

GO TOP IN CONTRATO_ESTATISTICA

IF NOT lOpenEST
   USE IN ( SELECT( 'CONTRATO_ESTATISTICA' ) )
ENDIF

USE IN ( SELECT( 'CRSM' ) )

sele (nSle)

RETURN