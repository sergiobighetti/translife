


*!*   SELECT
*!*      tt.idfilial, aSit[VAL(tt.situacao)] as Quebra , IIF(, situacao, km_quant, tipo_transporte, data_transporte
*!*   FROM transp 


Select ;
                  LEFT(tt.Fat_codigo,2)       As FILIAL, ;
                  TRANSFORM(cc.idContrato,'@L 999999')+') '+cc.nome_responsavel         As Quebra,;
                  SUM( IIF( tipo_transporte='SIMPLES'          , 1,0 )) as qSIMPLES,;
                  SUM( IIF( tipo_transporte='COMPLETO'         , 1,0 )) as qCOMPLETO,;
                  COUNT(1) as qtd ;
FROM              TRANSP  tt ;
Join              CONTRATO cc On tt.fat_codigo=cc.codigo ;
WHERE             (1=1) ;
GROUP By          1,2 ;
ORDER By          qtd desc ;



Select ;
                  LEFT(tt.Fat_codigo,2)       As FILIAL, ;
                  tt.tipo_transporte          As Quebra,;
                  SUM( IIF( km_quant >= 000 AND km_quant <= 015, 1,0 )) as d000_a_015km,;
                  SUM( IIF( km_quant >= 016 AND km_quant <= 025, 1,0 )) as d016_a_025km,;
                  SUM( IIF( km_quant >= 025 AND km_quant <= 050, 1,0 )) as d026_a_050km,;
                  SUM( IIF( km_quant >= 051 AND km_quant <= 100, 1,0 )) as d051_a_100km,;
                  SUM( IIF( km_quant >= 101 AND km_quant <= 150, 1,0 )) as d101_a_150km,;
                  SUM( IIF( km_quant >= 151 AND km_quant <= 250, 1,0 )) as d151_a_250km,;
                  SUM( IIF( km_quant >= 251                    , 1,0 )) as d250_a_999km,;
                  COUNT(1) as qtd ;
FROM              TRANSP  tt ;
LEFT Outer Join   CONTRATO cc On tt.fat_codigo=cc.codigo ;
WHERE             (1=1) ;
GROUP By          1,2 ;
ORDER By          1,2 ;


Select ;
                  LEFT(tt.Fat_codigo,2)       As FILIAL, ;
                  tt.tipo_transporte          As Quebra,;
                  COUNT(1) as qtd ;
FROM              TRANSP  tt ;
LEFT Outer Join   CONTRATO cc On tt.fat_codigo=cc.codigo ;
WHERE             (1=1) ;
GROUP By          1,2 ;
ORDER By          1,2 ;



Select ;
                  LEFT(tt.Fat_codigo,2)       As FILIAL, ;
                  tt.situacao                 As Quebra,;
                  COUNT(1) as qtd ;
FROM              TRANSP  tt ;
LEFT Outer Join   CONTRATO cc On tt.fat_codigo=cc.codigo ;
WHERE             (1=1) ;
GROUP By          1,2 ;
ORDER By          1,2 ;



FUNCTION fTranspSit( nPos )
LOCAL cRet, aSit[6]

nPos = INT(VAL(nPos))
if BETWEEN( nPos , 1,6)

   aSit[1] = 'COTACAO     '
   aSit[2] = 'PENDENTE    '
   aSit[3] = 'EM ANDAMENTO'
   aSit[4] = 'REJEITADO   '
   aSit[5] = 'CANCELADO   '
   aSit[6] = 'FINALIZADO  '
   cRet= aSit[nPos]
ELSE
   cRet =    'Indefinido  '
ENDIF 

RETURN cRet
