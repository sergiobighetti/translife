LPARA nKey
* FUNCAO QUE MOSTRA A ESTATISCA DE ATENDIMENTOS FEITOS POR ANO
* nKey  = codigo assoc do paciente
LOCAL nSel

nSel = SELECT()

WAIT WINDOW "#1 - Selecionando ... Aguarde" NOWAIT NOCLEAR 

SELECT   PADC( STR(YEAR(a.tm_chama),4), 10 ) AS Ano,;
         SUM( IIF( a.MedClassificacao='CONS', 1, 0 )  ) AS CONSULTA,;
         SUM( IIF( a.MedClassificacao='EMERGENCIA', 1, 0 )  ) AS EMERGENCIA,;
         SUM( IIF( a.MedClassificacao='URGENCIA', 1, 0 )  ) AS URGENCIA,;
         SUM( IIF( a.MedClassificacao='TRANSPORTE', 1, 0 )  ) AS TRANSPORTE,;
         SUM( IIF( a.MedClassificacao='ODONTO', 1, 0 )  ) AS ODONTO,;
         SUM( IIF( a.MedClassificacao='ORIENTACAO', 1, 0 )  ) AS ORIENTACAO,;
         SUM( IIF( NOT alltrim(a.MedClassificacao)$'CONSULTA,CONS.PRIOR,EMERGENCIA,URGENCIA,ODONTO,ORIENTACAO,AGENDAMENTO', 1, 0 )  ) AS OUTROS, ;
         COUNT(*) AS TOTAL, ;
         nKey as Codigo ;
FROM     ATENDIMENTO a ;
WHERE    a.PACCODIGO = nKey AND a.idCancelamento=0 AND a.liberacao=2 ;
GROUP BY 1 ;
ORDER BY 1 DESC ;
INTO CURSOR CLV_AN1


WAIT WINDOW "#3 - Selecionando ... Aguarde" NOWAIT NOCLEAR 
SELECT   PADC( STR(YEAR(a.tm_chama),4), 10 ) AS Ano,;
         SUM( IIF( a.MedClassificacao='CONS', 1, 0 )  ) AS CONSULTA,;
         SUM( IIF( a.MedClassificacao='EMERGENCIA', 1, 0 )  ) AS EMERGENCIA,;
         SUM( IIF( a.MedClassificacao='URGENCIA', 1, 0 )  ) AS URGENCIA,;
         SUM( IIF( a.MedClassificacao='TRANSPORTE', 1, 0 )  ) AS TRANSPORTE,;
         SUM( IIF( a.MedClassificacao='ODONTO', 1, 0 )  ) AS ODONTO,;
         SUM( IIF( a.MedClassificacao='ORIENTACAO', 1, 0 )  ) AS ORIENTACAO,;
         SUM( IIF( NOT alltrim(a.MedClassificacao)$'CONSULTA,CONS.PRIOR,EMERGENCIA,URGENCIA,ODONTO,ORIENTACAO,AGENDAMENTO', 1, 0 )  ) AS OUTROS, ;
         COUNT(*) AS TOTAL,;
         nKey as Codigo ;
FROM     HSTATEND a ;
WHERE    a.PACCODIGO = nKey AND a.idCancelamento=0 AND a.liberacao=2 ;
GROUP BY 1 ;
ORDER BY 1 DESC ;
INTO CURSOR CLV_AN2

WAIT WINDOW "#3 - Selecionando ... Aguarde" NOWAIT NOCLEAR 

SELECT * FROM CLV_AN1 UNION ALL SELECT * FROM CLV_AN2 INTO CURSOR CLV_JNT

WAIT WINDOW "#4 - Selecionando ... Aguarde" NOWAIT NOCLEAR 
SELECT      ANO,;
            SUM( CONSULTA   ) as CONSULTA,;
            SUM( EMERGENCIA ) as EMERGENCIA,;
            SUM( URGENCIA   ) as URGENCIA ,;
            SUM( TRANSPORTE ) as TRANSPORTE,;
            SUM( ODONTO     ) as ODONTO,;
            SUM( ORIENTACAO ) as ORIENTACAO,;
            SUM( OUTROS     ) as OUTROS,;
            SUM( TOTAL      ) as TOTAL,;
            CODIGO ;
FROM        CLV_JNT ;
ORDER BY    1 ;
GROUP BY    1 ;
INTO CURSOR CANALIT

WAIT WINDOW "#5 - Selecionando ... Aguarde" NOWAIT NOCLEAR 
SELECT      PADC( 'TOTAL', 10 ) AS Ano,;
            SUM( CONSULTA   ) as CONSULTA,;
            SUM( EMERGENCIA ) as EMERGENCIA,;
            SUM( URGENCIA   ) as URGENCIA ,;
            SUM( TRANSPORTE ) as TRANSPORTE,;
            SUM( ODONTO     ) as ODONTO,;
            SUM( ORIENTACAO ) as ORIENTACAO,;
            SUM( OUTROS     ) as OUTROS,;
            SUM( TOTAL      ) as TOTAL,;
            nKey as Codigo ;
FROM        CLV_JNT ;
INTO CURSOR CSINTET

WAIT WINDOW "#6 - Selecionando ... Aguarde" NOWAIT NOCLEAR 
SELECT * FROM CANALIT UNION ALL SELECT * FROM CSINTET INTO CURSOR CEST

USE IN ( SELECT( 'CLV_AN1' ) )
USE IN ( SELECT( 'CLV_AN2' ) )
USE IN ( SELECT( 'CANALIT' ) )
USE IN ( SELECT( 'CSINTET' ) )
     
WAIT CLEAR 
     
DO FORM PESQUISA WITH 'SELECT * FROM CEST', ,'FI_ATEND_NO_ANO(ano,codigo)' ,'Estatistica de atendimento'
      
USE IN ( SELECT( 'CEXT' ) )

SELE (nSel)


FUNCTION FI_ATEND_NO_ANO( nAno,cCod )
IF VAL(nAno) > 0
   DO FORM ATEND_PESQUISA WITH .f., 'a.pacCodigo="'+ ALLTRIM(cCod)+'" AND a.idCancelamento=0 AND a.liberacao=2 AND YEAR(a.tm_Chama)='+nAno
ENDIF
RETURN