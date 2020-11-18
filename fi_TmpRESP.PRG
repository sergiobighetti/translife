Function fi_TmpRESP( tDE, tATE, lRtnSec )
LOCAL cRet, nSec 
cRet     = ''
nSec     = 0

If      Not Isnull(tDE) ;
      and Not Isnull(tATE) ;
      and Year(tDE) <> 1900 ;
      and Year(tATE) <> 1900 ;
      and Abs(Year(tATE)-Year(tDE)) < 50

   If lRtnSec = 'S'
      cRet = Tran( tATE-tDE )
   Else
      nSec = tATE-tDE
      cRet = tstring(nSec)
   Endif

Endif

cRet = Allt(cRet)
If Empty(cRet)
   cRet ='0'
ENDIF
IF lRtnSec ='S'
   cRet = INT(VAL(cRet))
ENDIF 

Return cRet