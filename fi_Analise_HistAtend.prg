FUNCTION fi_Analise_HistAtend( cAls )
Local nSel, cTmp, aOpen[1], x, laClosed[1], aTot[1]

=Aused( aOpen )

nSel = Select()
cTmp = Sys(2015)

CREATE CURSOR (cTmp) ( GRUPO C(1), TIPO C(50), DESCRICAO C(60), Quant I, nPerc N(8,2), GRAFICO C(100) )


SELECT     COUNT(1) as qtd, MIN(DataEvento) as tMin, MAX(DataEvento) as tMax ;
FROM       (cAls) aa ;
INTO ARRAY aTot

INSERT INTO (cTmp) ( GRUPO, TIPO, DESCRICAO, Quant , nPerc ) VALUES ( 'A', 'Tot.Atendimentos','Entre '+DTOC(TTOD(aTot[2]))+' e '+DTOC(TTOD(aTot[3])), aTot[1], 100 )

INSERT INTO (cTmp) ( GRUPO, TIPO, DESCRICAO, Quant ) ;
SELECT 'B' as GRUPO, PADR('Sintomas',50) as Tipo, xx.descricao, SUM(xx.qtd) as qtd ;
FROM ( ;
      SELECT   aa.Sint1 as descricao, COUNT(1) as qtd ;
      FROM     (cAls) aa  ;
      GROUP BY  aa.Sint1 ;
      UNION ALL ;
      SELECT   aa.Sint2 as descricao, COUNT(1) as qtd ;
      FROM     (cAls) aa  ;
      WHERE    !EMPTY(aa.Sint2) ;
      GROUP BY  aa.Sint2 ;
      UNION ALL ;
      SELECT   aa.Sint3 as descricao, COUNT(1) as qtd ;
      FROM     (cAls) aa  ;
      WHERE    !EMPTY(aa.Sint3);
      GROUP BY aa.Sint3 ) xx ;
GROUP BY xx.descricao 


INSERT INTO (cTmp) ( GRUPO, TIPO, DESCRICAO, Quant ) ;
SELECT 'C' as GRUPO, PADR( 'Clas.Regulador', 50 ) as Tipo, PADR(aa.Clas_Med,50) as descricao, COUNT(1) as qtd ;
FROM   (cAls)  aa ;
GROUP BY aa.Clas_Med



INSERT INTO (cTmp) ( GRUPO, TIPO, DESCRICAO, Quant ) ;
SELECT 'D' as GRUPO, PADR( 'Hipotese Diagnostico', 50 ) as Tipo, PADR(aa.HD_DESCRICAO,50) as descricao, COUNT(1) as qtd ;
FROM   (cAls)  aa ;
GROUP BY aa.HD_DESCRICAO


SELECT * FROM (cTmp) ORDER BY GRUPO, Quant DESC INTO CURSOR (cTmp) READWRITE 

SELECT (cTmp)
GO TOP 
SKIP
DO WHILE !EOF()
   cGrp = GRUPO
   nCab = 1
   SCAN WHILE cGrp = GRUPO AND !EOF()
      IF nCab <> 1
         replace TIPO WITH ''
      ENDIF 
      nCab = nCab + 1  
      replace nPerc   WITH (Quant /aTot[1])*100
      replace grafico WITH REPLICATE( '|', (Quant /aTot[1])*50 )+' '+ALLTRIM(TRANSFORM(nPerc,'@R 999.99%'))
      
   ENDSCAN 
ENDDO 
GO TOP 

SELECT * FROM (cTmp) INTO CURSOR (cTmp)

For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      IF laClosed[x,1] != cTmp
         Use In (laClosed[x,1])
      ENDIF 
   Endif
NEXT

SELECT (nSel)

RETURN cTmp
