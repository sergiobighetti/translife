CLOSE DATABASES all
SET EScape ON
SET EXCLUSIVE ON


dIni = {^2019-06-01}
dFim = {^2019-12-31}
SELECT ;
                  aa.idFilial                                      as FILIAL, ;
                  PADR( NVL(cc.tipo_contrato,''),50)               as TPcontr, ;
                  LEFT(DTOS(nf.dataemissao),6)                     as AnoMes, ;
                  SUM( NVL(nf.valorbruto,aa.valor_documento))      as VALOR, ;
                  COUNT(1) as QtdLancAR ;
FROM             ARECEBER  aa ;
LEFT OUTER JOIN CONTRATO cc ON aa.idContrato == cc.idContrato ;
LEFT OUTER JOIN NFISCAL nf ON aa.idNF == nf.controle  ;
WHERE nf.dataEmissao BETWEEN dIni AND dFim  ;
GROUP BY 1,2,3 ;
ORDER BY 1,2,3 ;
INTO CURSOR LV_BASE

SELECT DISTINCT AnoMes FROM LV_BASE INTO ARRAY aAnoMes

cColunas=''
cColunaQ=''
cColSum =''
cColSumQ=''

FOR i=1 TO ALEN(aAnoMes)

   
   cNome = SUBSTR( 'JanFevMarAbrMaiJunJulAgoSetOutNovDez', (VAL(RIGHT( aAnoMes[i],2))*3)-2,3 )
   
   cColunas = cColunas + ', CAST( SUM( IIF( AnoMes="'+ aAnoMes[i]+ '",VALOR,0)) as N(14,2)) as _v'+cNome+ SUBSTR(aAnoMes[i],3,2)
   cColunaQ = cColunaQ + ', CAST( SUM( IIF( AnoMes="'+ aAnoMes[i]+ '",    1,0)) as I      ) as _q'+cNome+ SUBSTR(aAnoMes[i],3,2)

   cColSum  = cColSum  + ',SUM(_v'+cNome+ SUBSTR(aAnoMes[i],3,2)+ ') as _v'+cNome+ SUBSTR(aAnoMes[i],3,2)
   cColSumQ = cColSumQ + ',SUM(_q'+cNome+ SUBSTR(aAnoMes[i],3,2)+ ') as _q'+cNome+ SUBSTR(aAnoMes[i],3,2)

NEXT 

cColunas = cColunas + ', CAST( SUM(VALOR) as N(14,2)) as TotPeriodo'
cColSum  = cColSum  + ', SUM(TotPeriodo) as TotPeriodo'


cColunaQ = cColunaQ + ', COUNT(1) as QtdPeriodo'
cColSumQ = cColSumQ + ', SUM(QtdPeriodo) as QtdPeriodo'


TEXT TO cSql TEXTMERGE NOSHOW PRETEXT 8
   SELECT FILIAL, TPcontr <<cColunas>> <<cColunaQ >>
   FROM LV_BASE
   GROUP BY FILIAL, TPcontr
   ORDER BY FILIAL, TPcontr
   INTO CURSOR LV_BASE2 READWRITE
ENDTEXT    
&cSql.



TEXT TO cSql TEXTMERGE NOSHOW PRETEXT 8
INSERT INTO LV_BASE2 SELECT 'ZZ' as FIL, "Total..." <<cColSum>>  <<cColSumQ>> FROM LV_BASE2
ENDTEXT 

&cSql.

SELECT LV_BASE2
SCAN all
   IF TPcontr  = "Total..."
      SELECT SUM( QtdLancAR  ) as QtdLancAR  FROM LV_BASE  INTO ARRAY aQtd
   else
      cFil     = FILIAL
      cTPcontr = TPcontr
      SELECT SUM( QtdLancAR  ) as QtdLancAR  FROM LV_BASE WHERE filial = cFil AND TPcontr=cTPcontr INTO ARRAY aQtd
   ENDIF 
      SELECT LV_BASE2
      replace TPcontr WITH ALLTRIM(TPcontr)+' ( qLanc: '+ TRANSFORM(aQtd[1]) +' )'
ENDSCAN 


brow


 
 