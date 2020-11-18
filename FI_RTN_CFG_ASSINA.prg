Lparameters cOrgem, nTipo

If cOrgem = 'T' && TRANSPORTE
   cRtn = Iif( nTipo = 1, '1. nulo      ',;
          iif( nTipo = 2, '2. CENTRAL   ',;
          iif( nTipo = 3, '3. COBRANÇA  ',;
          iif( nTipo = 4, '4. PESSOAL   ',;
          iif( nTipo = 5, '5. DIRETORIA ',;
          iif( nTipo = 6, '6. FINANCEIRO', '            ' ))))))
ELSE
   cRtn = Iif( nTipo = 1, '1. MARKETING ',;
          iif( nTipo = 2, '2. CENTRAL   ',;
          iif( nTipo = 3, '3. COBRANÇA  ',;
          iif( nTipo = 4, '4. PESSOAL   ',;
          iif( nTipo = 5, '5. DIRETORIA ',;
          iif( nTipo = 6, '6. FINANCEIRO', '            ' ))))))
ENDIF          
         
RETURN cRtn