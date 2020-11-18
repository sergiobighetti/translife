*==========================================================================
FUNCTION tstring(Arg1,lTamanhoFixo)
*==========================================================================
   LOCAL nHr, nMn, nSg, cRt, cSinal
   
   lTamanhoFixo = IIF( TYPE('lTamanhoFixo')='L', lTamanhoFixo, .f. )
   
   cSinal = IIF(NVL(Arg1,0)<0, '-', IIF(lTamanhoFixo,' ', '') )
   Arg1 = ABS(Arg1)

   nHr = INT( MOD( Arg1 / 3600, 24 ) )
   nMn = INT( MOD( Arg1 / 60, 60 ) )
   nSg = INT( MOD( Arg1, 60 ) )
   cRt = PADL(nHr,2,[0])+ [:]+ PADL( nMn, 2, [0] )+[:]+ PADL(nSg,2,[0])

   RETURN cSinal+cRt

ENDFUNC