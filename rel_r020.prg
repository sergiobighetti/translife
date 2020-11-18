LPARAMETERS cFldName
LOCAL nRtn, cCtrl

IF cDrv3pto = '*'
   nRtn = &cFldName
ELSE
   cCtrl = PADL( contrato, 6, '0' )
   IF cCtrl $ cDrv3pto
      nRtn = 0
   ELSE
      nRtn = &cFldName
   ENDIF
ENDIF

RETURN nRtn