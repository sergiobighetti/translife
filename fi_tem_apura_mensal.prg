Procedure fi_TEM_APURA_MENSAL()
&& Verifica se ja foi executado a apuracao mensal
Local lRetorno , cRef, Aver[1], x, aOpen[1,2], laClosed[1,2]

lRetorno = .T.

IF m.drvNivelUsuario >= 7

   =Aused( aOpen ) && captura as areas abertas antes do processo

   cRef     = Dtos(( Date() - DAY(DATE()) ))+'235959'  && pega a data do ultimo dia do mes anterior as 23:59:59

   && faz a contagem de registro com a apuracao
   Select Count(*) As qtd From CONTRATO_APURA Where Origem='MENSAL' And aammddhhmm =cRef Into Array Aver

   lRetorno = ( Nvl(Aver[1],0) > 0 )  && ira retorna .t. se ja foi feita a apuracao mensal

   For x=1 To Aused( laClosed )
      If Ascan( aOpen, laClosed[x,1]) = 0
         Use In (laClosed[x,1])
      Endif
   Next

ENDIF

Return lRetorno
