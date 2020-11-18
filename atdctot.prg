Function atdCTOT( tRef, cHora )

Local tRet, tDiff, nTamHR

tRet= Ctot('')
tDiff = 0

cHora = Allt( cHora )

nTamHR = Len(cHora)

If nTamHR = 5

   cHora = Left(cHora,2)+':'+Right(cHora,2)

   cDataHora = LEFT(TTOC(tRef),10)+' '+cHora

   If Isdigit( Left(cHora,2) ) And Isdigit( Substr(cHora,4,2) )  And ;
         BETWEEN( Val(Left(cHora,2)), 00, 23 ) And ;
         BETWEEN( Val(Substr(cHora,4,2)), 00, 59 )

      tRet = CtoT( cDataHora )
   ENDIF
   
   tDiff = ( tRet - tRef )

   If  Abs( tDiff )  >= ((21*60)*60)
      tRet = tRet + 86400


   Endif


Endif

Return tRet
