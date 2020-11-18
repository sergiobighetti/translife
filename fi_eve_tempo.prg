FUNCTION FI_EVE_Tempo( dIni, dFim, dPror )
Local  nTotal, nSubTot1, nSubTot2, nVlrSeg, cSetDec, nValHR

nSubTot1 = ( dFim  - dIni )    && Total normal
IF !EMPTY(dPror)
   nSubTot2 = ( dPror - dFim ) && Total extra
ELSE   
   nSubTot2 = 0
ENDIF
nTotal   = nSubTot1 + nSubTot2
nTotalH  = ( (nTotal/60) / 60 )
IF INT(nTotalH) > nTotalH
   nTotalH = INT(nTotalH) + 1
ELSE
   nTotalH = INT(nTotalH)
ENDIF 

RETURN nTotalH 