Function FI_TRANSP_CALC( nID )
* Recalcula o atendimento

Local nTotal, nTotEQP, cTmp, nSel, oReg, oInfATD
Local aOpen[1], x, laClosed[1]

nSel    = Select()
cTmp    = SYS(2015)

=Aused( aOpen )


Select       km_quant, valor_inicial, pedagio, extras, hrp_quant, hrp_valor ;
           , desconto, acrescimo, Cast( 0 As N(12,2) ) As vEquipe, Cast( 0 As N(12,2) ) As vTotalFinal  ;
           , detalhe, 00000000 As qMinMEDICO, tipo_transporte ;
From         TRANSP Where idTransp=nID Into Cursor (cTmp)

Scatter Name oReg Memo

oInfATD = fi_INFATD( nID,'*')
If oReg.tipo_transporte='COMPLETO'
   oReg.qMinMEDICO = ELAPTIME(oInfATD.tm_saida+':00',oInfATD.tm_Retor,.F.)
Endif

nTotEQP = 0.00
cTmp    = Sys(2015)

Select valor_real, valor From TRANSP_EQUIPE Where idTransp=nID Into Cursor (cTmp)
If _Tally > 0
   Select(cTmp)
   Scan All
      If &cTmp..valor_real > 0
         nTotEQP= nTotEQP+ &cTmp..valor_real
      Else
         nTotEQP= nTotEQP+ &cTmp..valor
      Endif
   Endscan
Endif
Use In (Select(cTmp))

oReg.vEquipe      = nTotEQP
oReg.vTotalFinal  = oReg.valor_inicial - oReg.desconto + oReg.acrescimo

If oReg.hrp_quant > 0                 && se tem QUANTIDADE DE HORAS PARADAS
   oReg.vTotalFinal= oReg.vTotalFinal+ oReg.hrp_valor   && Soma a hora parada
Endif

If oReg.qMinMEDICO > 0

   nRegra = OCCURS( '<calctr>', oReg.detalhe )

   If Occurs( '<vMedico>', oReg.detalhe ) > 0

      nVlrMED = Strextract( oReg.detalhe, '<vMedico>', '</vMedico>',nRegra )
      nVlrMED = Chrtran( nVlrMED , ',', Set("Point") )
      nVlrMED = Chrtran( nVlrMED , '.', Set("Point") )
      nVlrMED = Val(nVlrMED)

      oReg.vTotalFinal = oReg.vTotalFinal + (oReg.qMinMEDICO * nVlrMED)

   Endif

Endif

For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
NEXT

Select (nSel)

Return oReg