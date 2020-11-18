Function FI_R021_CALC( nV1, nV2, nRound )
   Local nRet

   nV1 = Nvl( nV1, 0 )
   nV2 = Nvl( nV2, 0 )
   If Type( 'nRound' ) <> 'N'
      nRound = 4
   Endif

   Try
      nRet = Round( ( (nV1/nV2) * 100), nRound )
   Catch
      nRet = 0
   Endtry

Return nRet
