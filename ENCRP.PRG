CLEAR
cFra = 'BLUECHIP'
cRst = encrDOS( cFra )
=STRTOFILE( cRst, 'c:\tst.txt' )




function encrDOS( cFrase, cPass )
local nCtd, nProxLetra, nAscRst, nAscMais, nCodAsc, nAscRst2, cRet, l1Param

l1Param     = ( pCount()=1 )
cPass       = iif( pCount()=1, " ", cPass)
nProxLetra  = 1
cRet        = ""

for nCtd  = 1 to len( alltrim(cFrase) )
   nCodAsc = asc( substr( cPass, nProxLetra, 1 ) )
   if ( nCodAsc < 128 )
      nAscMais = nCodAsc + 128
   else
      nAscMais = nCodAsc
   endif
   if (l1Param)
      nAscRst2 = asc( substr( cFrase, len(alltrim(cFrase)) + 1 - nCtd, 1 ) )
   else
      nAscRst2 = asc( substr( cFrase, nCtd, 1 ) )
   endif
   nAscRst = nAscMais - nAscRst2
   do case
      case nAscRst <= -64 .and. nAscRst >= -95
         nAscRst = abs(nAscRst)
      case nAscRst <= -32 .and. nAscRst >= -63
         nAscRst = 128 - ( abs(nAscRst) - ( abs(nAscRst) - 32) * 2)
      case nAscRst <= 0 .and. nAscRst >= -31
         nAscRst = abs(nAscRst)
      case nAscRst >= 1 .and. nAscRst <= 32
         nAscRst = nAscRst + (32 - nAscRst) * 2
      case nAscRst >= 33 .and. nAscRst <= 64
         nAscRst = nAscRst + ((64 - nAscRst) * 2 + 128)
      case nAscRst >= 65 .and. nAscRst <= 96
         nAscRst = nAscRst + ((96 - nAscRst) * 2 + 128)
      case nAscRst >= 97 .and. nAscRst <= 128
         nAscRst = nAscRst + (128 - nAscRst) * 2
   endcase
   if (nCodAsc == 33)
      if (nAscRst2 >= 34)
         if ( substr(str(nAscRst), len(str(nAscRst)), 1) $ "13579" )
            nAscRst = nAscRst + 2
         endif
      endif
      do case
         case nAscRst2 == 64
            nAscRst = 225
         case nAscRst2 == 96
            nAscRst = 193
         case nAscRst2 == 128
            nAscRst = 33
         case nAscRst2 == 160
            nAscRst = 1
         case nAscRst2 == 192
            nAscRst = 97
         case nAscRst2 == 224
            nAscRst = 65
      endcase
   endif
   cRet = cRet + chr(nAscRst)
   nProxLetra = nProxLetra + 1
   if (nProxLetra > len(cPass))
      nProxLetra = 1
   endif
next
return cRet


