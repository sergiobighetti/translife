cFca   = '01MOTORISTA'
nKM    = 20  && quantidade de KM percorrido
tSBase = {^2005-09-01 07:00}
tCDst1 = {^2005-09-01 08:15}
tSDst1 = {^2005-09-01 08:30}
tCDst2 = {//::} && {^2005-09-01 14:00}
tSDst2 = {//::} && {^2005-09-01 14:35}
tRBase = {^2005-09-01 19:00}
CLEAR

? Calc_Equipe( cFca, nKM, tSBase, tCDst1, tSDst1, tCDst2, tSDst2, tSDst2  )

FUNCTION CALC_EQUIPE
LPARAMETERS ;
cFilFuncao as String  ,;  && FILIAL_funcao a ser calculada (MEDICO,ENFERMEIRO,MOTORISTA)
nQtdKM     as integer ,;  && quantidade de KM
tSaidaBase as Datetime,;  && dataHora saida da base
tChegaDst1 as Datetime,;  && dataHora chegada ao 1o destino
tSaidaDst1 as Datetime,;  && dataHora saida ao 1o destino
tChegaDst2 as Datetime,;  && dataHora chegada ao 2o destino
tSaidaDst2 as Datetime,;  && dataHora saida ao 1o destino
tRetorBase as Datwetime    && horario de retorno a base

local cLV_BS, cLV_PG, cSetDec, nValor, cHrSaida, cWhe, nHrParadaReal

cSetDec = SET("Decimals")
SET DECIMALS TO 6

cLV_BS   = 'T_'+sys(2015)  && area para base
cLV_PG   = 'T_'+sys(2015)  && area para tab pagamento
nValor   = $0
cQtdKM   = padl( nQtdKM, 3, '0' )
nHrTotal = 0    && total de horas do transporte

cHrSaida = STRTRAN( TTOHHMM( tSaidaBase ), ':', '' )

nQtdHP_s = 0 && total em segundos da hr parada
IF !EMPTY(tSaidaDst1)
   nQtdHP_s = nQtdHP_s + ( tSaidaDst1-tChegaDst1 ) 
ENDIF
IF !EMPTY(tSaidaDst2)
    nQtdHP_s = nQtdHP_s +( tSaidaDst2-tChegaDst2 )  
ENDIF

cWhe = ' Pgeqp_cfg.fil_tipo = "'+ cFilFuncao +'" and ' +;
       'BETWEEN( "'+cQtdKM  +'", Pgeqp_cfg.km_de, Pgeqp_cfg.km_ate ) AND ' +;
       'BETWEEN( "'+cHrSaida+'", Pgeqp_cfg.hr_de, Pgeqp_cfg.hr_ate )'

select      Pgeqp.hr_parada     ,;
            Pgeqp.extra_de00a06 ,;
            Pgeqp.extra_de06a99 ,;
            Pgeqp_cfg.hr_de     ,;
            Pgeqp_cfg.hr_ate    ,;
            Pgeqp_cfg.fixo      ,;
            Pgeqp_cfg.valor_km   ;
from        Pgeqp_cfg ;
join        Pgeqp on Pgeqp_cfg.fil_tipo == Pgeqp.IDfilial+Pgeqp.tipo ;
where       &cWhe ;
order by    Pgeqp_cfg.hr_de ;
into cursor (cLV_PG)

nHORA_P   = VAL(STR(&cLV_PG..hr_parada)) 
nVlrHrP_s = ( VAL(STR(&cLV_PG..hr_parada)) /3600.000000 )

if _tally = 1
  
   nHrParadaReal = ROUND( nQtdHP_s * nVlrHrP_s, 2 )
   IF nHrParadaReal < &cLV_PG..hr_parada
      nHrParadaReal = &cLV_PG..hr_parada
   endif

   nValor = &cLV_PG..fixo                       + ; && valor fixo
            ( nQtdKM   * &cLV_PG..valor_km  )   + ; && valor p/ km
            nHrParadaReal                       + ; && valor hora parada
            iif( nHrTotal <= 6,;                    && valor extra
                &cLV_PG..extra_de00a06, ;
                &cLV_PG..extra_de06a99 )

endif

SET DECIMALS TO &cSetDec.

RETURN nValor





function FI_Incr_Base( cCursor, cTipo, dI, dF )
* cCursor: nome do cursor a incrementar registros
*   cTipo: TRANSP (Transporte), HRPARA ( Hora Parada )
*      dI: DateHora Inicial
*      dF: DataHora Final
local dFinal, nQtdTempo, nIncSeg, lInicio

dI      = datetime( year(dI), month(dI), day(dI), hour(dI), minute(dI), 00 )
dF      = datetime( year(dF), month(dF), day(dF), hour(dF), minute(dF), 59 )
dFinal  = dF
lInicio = .t.

do while (dFinal-dI > 0)

   if between( minute(dI), 01, 59 ) and lInicio
      nIncSeg = 0
      do while .t.
         dF = dI + nIncSeg             && Incremente 1 segundo
         if dF>dFinal or minute(dF)=59 && se chegou ao destino1 ou minuto = 59
            exit
         endif
         nIncSeg = nIncSeg + 1
      enddo
      lInicio = .f.
   else
      dF = dI + 3541       && incrementa 1 hora a data final (dF)
      if dF > dFinal       && se chegou ao paramentro final
         dF = dFinal       && vale o paramentro final
      endif
   endif
   dF = datetime( year(dF), month(dF), day(dF), hour(dF), minute(dF), 59 )
   nQtdTempo = ( dF - dI )

   insert into ( cCursor ) ;
      values ( cTipo, dtos(dI),;
      strtran(TTOHHMM(dI),':',''),;
      strtran(TTOHHMM(dF),':',''),;
      nQtdTempo, $0 )

   dI  = datetime( year(dF), month(dF), day(dF), hour(dF), minute(dF), 59 )
   dI  = dI + 1

enddo
RETURN .T.
ENDFUNC 