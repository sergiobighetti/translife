
*!*	{30/06/2005}
*!*	{10/05/2005}

FUNCTION FI_QUANT_PARCELA( dFatu, dVigo )
LOCAL nQtd
IF !EMPTY( dVigo ) AND ( dVigo <= dFatu )
   nQtd  = 0
   dFatu = DATE( YEAR(dFatu), MONTH(dFatu), DAY(dVigo) )
   DO WHILE !EMPTY( dVigo ) AND dVigo < dFatu
      nQtd = nQtd + 1
      dVigo = GOMONTH( dVigo, 1 )
   ENDDO
   nQtd = nQtd + 1 
ELSE   
   nQtd = 0
ENDIF
RETURN nQtd






