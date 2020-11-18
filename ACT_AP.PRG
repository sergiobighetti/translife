close databases all
clear

set escape on
use associado_plano in 0 alias ATUAL
use C:\TEMP\sergio\BDMDC\associado_plano in 0 alias OLD exclusive

select ATUAL
scan all

   if ATUAL.dtinc >={^2005-01-01} AND ATUAL.parcela=10

      cKey = str(ATUAL.idassoc,10)+str( ATUAL.idplano,3)+str(ATUAL.idvend,5)
      if seek( cKey, 'OLD', 'SERGIO' )
         if ATUAL.parcela = OLD.parcela
            ?? [=]
         ELSE
            IF OLD.parcela = 0
               ?? [0]
            ELSE
               ?? [.]
               * replace ATUAL.parcela WITH OLD.parcela
            ENDIF
            
         endif
      else
         ?? [*]
      endif
   endif
   select ATUAL

endscan
