Lparameters nIDC
*-- fator moderador

Local cCCOP, nSele, dINI, dFIM, cAls, cVQT, cClassif, cMsg, oMsgDestaque, nVlr, lRtn, dXini, i

nIDC =       78371
lRtn  = .F.
nSele = Select()
cCCOP = Sys(2015)

*-- verifica a existencia de FATOR MODERADOR
Select      8 as qtdatend, 'SEMES' tipo, classificacao, valorcob, {^2015-07-01} dtinicio ;
FROM        CONTRATO_FM ;
WHERE       idcontrato = nIDC ;
INTO Cursor (cCCOP)

If _Tally > 0 &&-- existe FATOR MODERADOR


   nVlr = &cCCOP..valorcob
   dFIM = DATETIME()


   If &cCCOP..tipo = 'MENSAL'
   
       
      dINI = Date( Year(dFIM),Month(dFIM),Day(&cCCOP..dtinicio))   
      **** dINI = TTOD(dFIM) - Day(dFIM) + 1
   Else

      dXIni = &cCCOP..dtinicio
      FOR i=1 TO 10000
         LOCAL aVig[i,2]
         aVig[i,1] = dXIni
         aVig[i,2] = GOMONTH(dXIni,12) -1
         IF aVig[i,2] >= TTOD(dFim)
            aVig[i,2] = TTOD(dFim)
            exit
         ENDIF 
         dXini = aVig[i,2]+1
      NEXT 
      dIni = aVig[i,1]

     Endif

   Endif

   *-- data de referencia menos 1 mes        
   If dINI > Ttod(dFIM)   &&2010-09-12  19/08/2010
      If &cCCOP..tipo = 'MENSAL'
         dINI = Gomonth( dINI,  -1 )
      Else
         If &cCCOP..tipo = 'SEMES'
            dINI = Gomonth( dINI, -06 )
         else
            dINI = Gomonth( dINI, -12 )
         ENDIF 
      Endif
   Endif

   dINI = Dtot(dINI)


? dINI
? dFIM 
   Use In ( Select( cAls ) )

   lRtn = .T.

Endif

Use In ( Select( cCCOP ) )

Select (nSele)

