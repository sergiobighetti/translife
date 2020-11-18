SELECT aa.idfilial, aa.id, aa.ctrnumero, aa.tm_chama, aa.valorcobranca, aa.tm_retor, aa.situacao, aa.codatendimento, aa.faturamento, CAST(0 as numeric(12,2)) as xVLR;
FROM atendimento aa WHERE aa.tm_chama >= GOMONTH(DATETIME(),-6) AND aa.codatendimento=16 AND aa.valorcobranca=0 AND !EMPTY(aa.tm_retor) AND !DELETED() AND aa.situacao=2;
UNION ALL ;
SELECT aa.idfilial, aa.id, aa.ctrnumero, aa.tm_chama, aa.valorcobranca, aa.tm_retor, aa.situacao, aa.codatendimento, aa.faturamento, CAST(0 as numeric(12,2)) as xVLR ;
FROM hstatend aa WHERE aa.tm_chama >= GOMONTH(DATETIME(),-6) AND aa.codatendimento=16 AND aa.valorcobranca=0 AND !EMPTY(aa.tm_retor) AND !DELETED() AND aa.situacao=2 ;
INTO CURSOR LV_VER READWRITE 


SELECT LV_VER
SCAN all
   vFM( LV_VER.ctrnumero )
   SELECT LV_VER
ENDSCAN 



FUNCTION vFM( nIDC )
*-- fator moderador

Local cCCOP, nSele, dINI, dFIM, cAls, cVQT, cClassif, cMsg, oMsgDestaque, nVlr, lRtn, dXini, i


lRtn  = .F.
nSele = Select()
cCCOP = Sys(2015)

*-- verifica a existencia de FATOR MODERADOR
Select      qtdatend, tipo, classificacao, valorcob, dtinicio ;
FROM        CONTRATO_FM ;
WHERE       idcontrato = nIDC ;
INTO Cursor (cCCOP)

If _Tally > 0 &&-- existe FATOR MODERADOR

   nVlr = &cCCOP..valorcob
   dFIM = LV_VER.tm_chama   && 19/08/2010


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

   *-- data de referencia menos 1 mes        
   If dINI > Ttod(dFIM)   &&2010-09-12  19/08/2010
      If &cCCOP..tipo = 'MENSAL'
         dINI = Gomonth( dINI,  -1 )
      Else
         dINI = Gomonth( dINI, -12 )
      Endif
   Endif

   dINI = Dtot(dINI)


   *--- verifica o historico de atendimentos do contrato
   cAls = HistAtend( nIDC, Datetime(), 'WZREG' )

   If Reccount( cAls ) > 0 &&-- se possui atendimentos anteriores

      cVQT     = Sys(2015)
      cClassif = Alltrim( &cCCOP..classificacao )

      *-- verifica a QUANTIDADE DE ATENDIMENTO que possuem a classificacao especificada no contrato
      *-- e que estejam dentro do periodo para apuracao
      *-- que tenha codigo de atendimento 1 APH

      Select      Count(*) QUANT ;
      FROM        (cAls) ;
      WHERE       Alltrim(Clas_Med) $ cClassif ;
         And DataEvento Between dINI And dFIM  ;
         AND idcancelamento = 0                ; && nao cancelado
         AND situacao =    'Liber.'            ; && liberado
         AND CodAtend = 16 ;
      INTO Cursor (cVQT)

      *-- se a quantidade encontrada MAIOR que a especificada no contrato
      If &cVQT..QUANT >= &cCCOP..qtdatend
      REPLACE LV_VER.xvlr WITH nVlr

      Endif

      Use In ( Select( cVQT ) )

   Endif

   Use In ( Select( cAls ) )

   lRtn = .T.

Endif

Use In ( Select( cCCOP ) )

Select (nSele)

Return lRtn
