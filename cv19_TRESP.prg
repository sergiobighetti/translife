Function cv19_TRESP
* Retorna o tempo de responsata em minutos
Lparameters nPercDescarte, cWhe
Local nSel, cTmp, aOpen[1], x, laClosed[1], aResp[1], nTotReg, nQtdDesc

=Aused( aOpen )

nSel          = Select()
cWhe          = Iif( Type('cWhe') ='C', cWhe, '1=1' )
nPercDescarte = Iif( Type('nPercDescarte')='N', nPercDescarte, 0 )
cTmp          = Sys(2015)

   Select      aa.tr_reg As TEMPO      ;
   From        bdmdc!v_base_covidl9 aa ;
   Where       &cWhe.                  ;
   Order By    aa.tr_reg               ;
   Into Cursor (cTmp)

Select Avg(TEMPO), Count(1) As QtdReg From (cTmp) Into Array aResp

If nPercDescarte > 0
   nTotReg = aResp[2]
   nQtdDesc = Int(  (nTotReg* (nPercDescarte/100) )/2 )
   If nQtdDesc > 0
      nQtdDesc = (nTotReg-nQtdDesc)
      Select Top (nQtdDesc) * From (cTmp) Order By TEMPO      Into Cursor (cTmp)
      Select Top (nQtdDesc) * From (cTmp) Order By TEMPO Desc Into Cursor (cTmp)
   Endif

Endif

Select Avg(TEMPO), Count(1) As QtdReg From (cTmp) Into Array aResp
nRet = aResp[1]

Use In ( Select(cTmp))
For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
Next

Return nRet
