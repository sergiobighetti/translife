FUNCTION fi_MAPA_FAT( cFil, cQuebr, cVlRef, cDtRef, dIni, dFim, cAlsRet )
* Mostra o mapa de faturamento dentro do periodo informado 
* Parametros:
* <cFil>    Codigo da filial separado por virgulas Ex: 01,02...  Se passar * é todas
* <cQuebr>  Campo que ira realizar a quebra: TC = Tipo de contrato, FPA= Forma Pgto ARECEBER, FPC = Forma Pgto Contrato
* <VlRef>   Valor que ira prevalecer NF=valor da nota AR = valor do areceber
* <dIni>    data inicio da apuracao
* <dFim>    data Final da apuracao
* [cAlsRet] Alias a ser retornado



Local cWhe, cColunas, cColSum, cNome, i, cSql, cTmpBS, cTmpRst, aAnoMes[1], nSel
LOCAL aOpen[1], x, laClosed[1]

=AUSED( aOpen )

cAlsRet = IIF( TYPE('cAlsRet') ='C', cAlsRet, '' )
nSel    = SELECT()
cWhe    = cDtRef +' BETWEEN {^'+ Transform(Dtos(dIni),'@R 9999-99-99') +'} AND {^'+ Transform(Dtos(dFim),'@R 9999-99-99') +'}'

If cFil   <> '*'
   cWhe = cWhe + ' and aa.idFilial $ "'+ cFil +'"'
Endif
If cVlRef ='NF'
   cVlRef = 'NVL(nf.valorbruto,aa.valor_documento)'
Else
   cVlRef = 'NVL(aa.valor_documento,nf.valorbruto)'
Endif

Do Case
   Case cQuebr = 'TC'
      cQuebr = 'NVL(cc.tipo_contrato,"")'
   Case cQuebr = 'FPC'
      cQuebr = 'NVL(cc.forma_pagamento,"")'
   Case cQuebr = 'FPA'
      cQuebr = 'NVL(aa.forma_pagto,"")'
     
Endcase

cTmpBS  = Sys(2015)
cTmpRst = Sys(2015)

Select ;
                  aa.idFilial                 As FILIAL, ;
                  &cQuebr.                    As Quebra, ;
                  LEFT(Dtos(&cDtRef.),6)      As AnoMes, ;
                  SUM( &cVlRef. )             As VALOR ;
FROM              ARECEBER  aa ;
LEFT Outer Join   CONTRATO cc On aa.idContrato == cc.idContrato ;
LEFT Outer Join   NFISCAL nf On aa.idNF == nf.controle  ;
WHERE             &cWhe. ;
GROUP By          1,2,3 ;
ORDER By          1,2,3 ;
INTO Cursor       (cTmpBS)

Select Distinct AnoMes From (cTmpBS) Into Array aAnoMes

cColunas=''
cColSum =''
For i=1 To Alen(aAnoMes)

   cNome = Substr( 'JanFevMarAbrMaiJunJulAgoSetOutNovDez', (Val(Right( aAnoMes[i],2))*3)-2,3 )
   cColunas = cColunas + ', CAST( SUM( IIF( AnoMes="'+ aAnoMes[i]+ '",VALOR,0)) as N(14,2)) as _'+cNome+ Substr(aAnoMes[i],3,2)
   cColSum  = cColSum  + ',SUM(_'+cNome+ Substr(aAnoMes[i],3,2)+ ') as _'+cNome+ Substr(aAnoMes[i],3,2)

Next

cColunas = cColunas + ', CAST( SUM(VALOR) as N(14,2)) as TotPeriodo'
cColSum  = cColSum  + ', SUM(TotPeriodo) as TotPeriodo'

TEXT TO cSql TEXTMERGE NOSHOW PRETEXT 8
   SELECT FILIAL, Quebra <<cColunas>>
   FROM <<cTmpBs>>
   GROUP BY FILIAL, Quebra
   ORDER BY FILIAL, Quebra
   INTO CURSOR <<cTmpRst>> READWRITE
ENDTEXT
Try
   &cSql.


   TEXT TO cSql TEXTMERGE NOSHOW PRETEXT 8
   INSERT INTO <<cTmpRst>> SELECT 'ZZ' as FIL, "Total..." <<cColSum>> FROM <<cTmpRst>>
   ENDTEXT

   &cSql.

Catch
   _Cliptext = cSql
Endtry


USE IN (SELECT(cTmpBs ))
IF !EMPTY(cAlsRet)
   SELECT * FROM (cTmpRst) INTO CURSOR (cAlsRet)
ENDIF 
USE IN (SELECT(cTmpRst))

For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      IF NOT cAlsRet == laClosed[x,1]
         Use In (laClosed[x,1])
      endif
   Endif
NEXT

SELECT (nSel)

RETURN cAlsRet