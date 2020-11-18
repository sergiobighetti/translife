Function fiCTOT( tRef, cHora  )
&& Retorna datetime
&& Com base em tRet, gera o DateTime para a cHora
&& Usado para montar os tempos do atendimento
&& Exemplo fiCTOT( tm_chama, '99:99' )
Local tDiff, nTamHR, cDataHora, tRet

tDiff = 0
tRet  = Ctot('')

cHora = Ltrim( Rtrim( cHora ) )
nTamHR = Nvl( Len(cHora), 0 )

If !Empty(tRef)

   If nTamHR = 5
   
      cHora     = Left(cHora,2)+':'+Right(cHora,2)
      cDataHora = Transform(Dtos(tRef),"@R 9999-99-99") +' '
      cDataHora = cDataHora + cHora

      If Isdigit( Left(cHora,2) ) And Isdigit( Substr(cHora,4,2) ) ;
         and Between( Substr( cHora,1,2),'00','23' ) ;
         and Between( Substr( cHora,4,2),'00','59' )

         Try
            tRet = Evaluate('{^'+ cDataHora +'}' )
            tDiff =  ( tRef - tRet )
            If Abs( tDiff )  >= 75600 && (21horas)
               tRet = tRet + 86400 &&-- add 1 dia
            Endif
         Catch
         Endtry

      Endif
   Endif

Endif

Return tRet
