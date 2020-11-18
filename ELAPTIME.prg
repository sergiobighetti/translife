*==========================================================================
FUNCTION ELAPTIME( Arg1, Arg2, lRtnSec )
* Arg1 = Hora incial
* Arg2 = Hora final
* lRtnSec = (.f. Retorna em minuto, .t. Retorna em segundos)
*==========================================================================
   LOCAL _Rtn, cHI, cHF, nSecI, nSecF, nMin

   IF TYPE( 'Arg1' ) = 'T'
      cHI = STRTRAN( STR(HOUR(Arg1),2)+':'+STR(MINUTE(Arg1),2)+':'+STR(SEC(Arg1),2), ' ', '0' )
   ELSE
      cHI = Arg1
   ENDIF

   IF TYPE( 'Arg2' ) = 'T'
      cHF = STRTRAN( STR(HOUR(Arg2),2)+':'+STR(MINUTE(Arg2),2)+':'+STR(SEC(Arg2),2), ' ', '0' )
   ELSE
      cHF = Arg2
   ENDIF

   nSecI = IIF( TYPE('cHI') = 'N', cHI, SECS(cHI) )
   nSecF = IIF( TYPE('cHF') = 'N', cHF, SECS(cHF) )

   _Rtn = tstring( IIF( cHF < cHI , 86400.0, 0) + nSecF - nSecI )

   IF PCount() = 3
      if left(_rtn,1)='-'
		nMin = ( VAL( SUBSTR(_Rtn,2,2) ) * 60 ) + VAL( SUBS(_Rtn,5,2) )
	  else
         nMin = ( VAL( LEFT(_Rtn   ,2) ) * 60 ) + VAL( SUBS(_Rtn,4,2) )
      endif
      _Rtn = INT( nMin )
   ENDIF

   RETURN _Rtn
ENDFUNC
