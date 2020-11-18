Local nSel, cTmp, cSql, cCod, nCtd
Local aOpen[1], x, laClosed[1]

=Aused( aOpen )

nSel = Select()
cTmp = Sys(2015)


TEXT  TO cSql TEXTMERGE NOSHOW PRETEXT 8
SELECT * FROM bdmdc!v_base_covidl9_por_ctr ORDER BY BOP_ID, CTR_ID, ANO, MES INTO CURSOR <<cTmp>>
ENDTEXT

&cSql.

If _Tally > 0

    Do Form c:\desenv\win\vfp9\libbase\PESQUISA With 'SELECT * FROM '+cTmp ,,,'MAPA: CORONA VIRUS', [IIF(CTR_ID=999999,16777088,16777215)]

Endif

Use In ( Select(cTmp))
For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
Next

Select (nSel)
