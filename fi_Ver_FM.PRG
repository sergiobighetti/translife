FUNCTION fi_Ver_FM( nIDC, tChamado )
*-- fator moderador

Local cCCOP, nSele, dINI, dFIM, cAls, cVQT, cClassif, cMsg, oMsgDestaque, nVlr, dXini, i, oReg

nSele = Select()
cCCOP = Sys(2015)

*-- verifica a existencia de FATOR MODERADOR
Select      qtdatend As FM_qtdAtend, tipo As FM_Tipo, classificacao As FM_classificacao, valorcob As FM_valor, dtinicio As FM_Inicio, regra As FM_regra ;
FROM        CONTRATO_FM ;
WHERE       idcontrato = nIDC ;
INTO Cursor (cCCOP)

Scatter Name oReg Memo
=ADDPROPERTY( oReg, 'Tem_FM', .f. )

oReg.Tem_FM = (Reccount( cCCOP ) > 0)
Use In (Select(cCCOP))

If oReg.Tem_FM 

   tChamado = IIF( TYPE('tChamado')='D', DTOT(tChamado), tChamado )

   =ADDPROPERTY( oReg, 'FM_idContrato', nIDC )
   =ADDPROPERTY( oReg, 'tReferencia',   tChamado )

   nVlr = oReg.FM_valor

   dFIM = ( tChamado - 1 )  && atendimentos anteriores

   If oReg.FM_Tipo = 'MENSAL'

      dINI = Date( Year(dFIM),Month(dFIM),Day(oReg.FM_Inicio))

   Else

      dXini = oReg.FM_Inicio
      For i=1 To 10000
         Local aVig[i,2]
         aVig[i,1] = dXini
         aVig[i,2] = Gomonth(dXini,12) -1
         If aVig[i,2] >= Ttod(dFIM)
            aVig[i,2] = Ttod(dFIM)
            Exit
         Endif
         dXini = aVig[i,2]+1
      Next
      dINI = aVig[i,1]

   Endif

   *-- data de referencia menos 1 mes
   If dINI > Ttod(dFIM)   
      If oReg.FM_Tipo = 'MENSAL'
         dINI = Gomonth( dINI,  -1 )
      Else
         If oReg.FM_Tipo = 'SEMES'
            dINI = Gomonth( dINI, -06 )
         Else
            dINI = Gomonth( dINI, -12 )
         Endif
      Endif
   Endif

   dINI = Dtot(dINI)

   =AddProperty( oReg, 'AP_dIni', dINI )
   =AddProperty( oReg, 'AP_dFim', dFIM )
   =AddProperty( oReg, 'AP_qtdatend', 0  )

   *--- verifica o historico de atendimentos do contrato
   cAls = HistAtend( nIDC, Datetime(), 'WZREG' )

   If Reccount( cAls ) > 0 &&-- se possui atendimentos anteriores

      cVQT     = Sys(2015)
      cClassif = Alltrim( oReg.FM_classificacao)

      *-- verifica a QUANTIDADE DE ATENDIMENTO que possuem a classificacao especificada no contrato
      *-- e que estejam dentro do periodo para apuracao
      *-- que tenha codigo de atendimento 1 APH

      Select      TPUND, Count(*) QUANT ;
      FROM        (cAls) ;
      WHERE       Alltrim(Clas_Med) $ cClassif ;
         And DataEvento Between dINI And dFIM  ;
         AND idcancelamento = 0                ; && nao cancelado
         And situacao =    'Liber.'            ; && liberado
         And CodAtend = 16 ;
      GROUP BY   TPUND ;
      INTO Cursor (cVQT)
     
      nTotAtend = 0 
      SCAN ALL
         oReg.AP_qtdatend = oReg.AP_qtdAtend + QUANT 
         IF !EMPTY(TPUND)
            =AddProperty( oReg, 'AP_qtdAtend_'+ALLTRIM(TPUND), QUANT  )
         ENDIF
      ENDSCAN 

      Use In ( Select( cVQT ) )

   ENDIF
   
   IF NOT PEMSTATUS( oReg, 'AP_qtdAtend_USA',5 ) 
      ADDPROPERTY(  oReg, 'AP_qtdAtend_USA', 0 )
   ENDIF 
   
   IF NOT PEMSTATUS( oReg, 'AP_qtdAtend_USB',5 ) 
      ADDPROPERTY(  oReg, 'AP_qtdAtend_USB', 0 )
   ENDIF 

   Use In ( Select( cAls ) )


Endif

Select (nSele)

Return oReg
 