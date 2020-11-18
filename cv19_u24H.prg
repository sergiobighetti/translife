Local nSel, cTmp, cSql, cCod, nCtd
Local aOpen[1], x, laClosed[1]

=Aused( aOpen )

nSel = Select()
cTmp = Sys(2015)

TEXT  TO cSql TEXTMERGE NOSHOW PRETEXT 8
         SELECT
                  aa.*
         FROM     bdmdc!V_BASE_COVIDl9_U24H  aa
         UNION ALL
         SELECT aa.EVOLUCAO, aa.bop_id, 'Z90) EVOLUCAO DA BASE '+rtrim(aa.bop_nome)+ ' ultimas 24h'  as bop_nome, 90 as dia, 900 as hora
            , SUM( aa.corona_total ) as corona_total
            , SUM( aa.cv19_assint  ) as cv19_assint
            , SUM( aa.cv19_leve    ) as cv19_leve
            , SUM( aa.cv19_grave   ) as cv19_grave
            , SUM( aa.omt          ) as omt
         FROM     bdmdc!V_BASE_COVIDl9_U24H  aa
         GROUP BY aa.evolucao, aa.bop_nome, aa.bop_id
         UNION ALL
         SELECT aa.EVOLUCAO,  'ZZ' as bop_id, 'Z99) EVOLUCAO TODAS AS BASES ultimas 24h'  as bop_nome, 99 as dia,  999 as hora
            , SUM( aa.corona_total ) as corona_total
            , SUM( aa.cv19_assint  ) as cv19_assint
            , SUM( aa.cv19_leve    ) as cv19_leve
            , SUM( aa.cv19_grave   ) as cv19_grave
            , SUM( aa.omt          ) as omt
         FROM     bdmdc!V_BASE_COVIDl9_U24H  aa
         GROUP BY aa.evolucao
         INTO CURSOR <<cTmp>>
ENDTEXT

&cSql.
Select * From (cTmp) Order By  BOP_ID, dia, hora Into Cursor (cTmp)


If _Tally > 0

   Select *, EVOLUCAO As xEVO, 'H' As CODIGO From (cTmp) Into Cursor lvANLSCVl9 Readwrite

   Do Form c:\desenv\win\vfp9\libbase\PESQUISA With 'SELECT * FROM '+cTmp ,,'FI_cv19GRF24H("lvANLSCVl9")','Ultimas 24 horas', [IIF(hora =900,16777088,16777215)]

Endif

Use In ( Select('lvANLSCVl9') )


Use In ( Select(cTmp))
For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
Next


Select (nSel)
