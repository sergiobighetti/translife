FUNCTION fi_TRESP( nId, cFmt )
&& retorna uma objeto com os tempos de resposta
&& nId  = id do atendimento
&& cFmt = FORMATO 'SS' segundo (DEFAULT) Inteiro, 'MM' inteiro, 'HHMMSS' CHAR )
LOCAL oRet, cAJT, cTmp, nTemReg, aOpen[1], laClosed[1], i, x, nSel

=Aused( aOpen )

nSel = SELECT()
cFmt = UPPER( IIF(TYPE('cFmt')='C', cFmt, 'SS' ) )
cAJT = 'A'+ SYS(2015)
cTmp = 'B'+ SYS(2015)

&&__ captura tudo em datetime
&& tenta em ATENDIMENTO
Select     ;
            id ;
          , tm_chama As t_chama ;
          , fiCTOT( tm_chama, tm_tarme)  As t_tarme ;
          , fiCTOT( tm_chama, tm_regul)  As t_regul ;
          , fiCTOT( tm_chama, tm_alarm)  As t_alarm ;
          , fiCTOT( tm_chama, tm_saida)  As t_saida ;
          , fiCTOT( tm_chama, tm_nloca)  As t_nloca ;
          , fiCTOT( tm_chama, tm_sloca)  As t_sloca ;
          , fiCTOT( tm_chama, tm_rnloca) As t_rnloca ;
          , fiCTOT( tm_chama, tm_rsloca) As t_rsloca ;
          , tm_retor  As t_retor ;
FROM        atendimento ;
WHERE       id = nId ;
INTO CURSOR (cAJT) 


nTemReg = _TALLY
IF nTemReg = 0  && caso nao consiga no atendimento, verifica historico de atendimento
   Select ;
      id ;
      , tm_chama As t_chama ;
      , fiCTOT( tm_chama, tm_tarme)  As t_tarme ;
      , fiCTOT( tm_chama, tm_regul)  As t_regul ;
      , fiCTOT( tm_chama, tm_alarm)  As t_alarm ;
      , fiCTOT( tm_chama, tm_saida)  As t_saida ;
      , fiCTOT( tm_chama, tm_nloca)  As t_nloca ;
      , fiCTOT( tm_chama, tm_sloca)  As t_sloca ;
      , fiCTOT( tm_chama, tm_rnloca) As t_rnloca ;
      , fiCTOT( tm_chama, tm_rsloca) As t_rsloca ;
      , tm_retor  As t_retor ;
      FROM      hstatend ;
   INTO CURSOR (cAJT)
   nTemReg = _TALLY
endif 

IF nTemReg > 0 && tendo registro

   && calcula os tempos resposta em SEGUNDOS
   SELECT  ;
             id ;
          , IIF( aa.t_Chama=aa.t_Tarme, 0, fi_TmpRESP(aa.t_Chama,aa.t_Tarme,   'S' )  )           as TR_TARME   ;
          , fi_TmpRESP(aa.t_Saida,aa.t_Retor,'S')                                                 as TR_GASTO   ;
          , fi_TmpRESP(aa.t_Chama,aa.t_Alarm,'S')                                                 as TR_DESP    ;
          , fi_TmpRESP(aa.t_tarme,iif( NOT empty(aa.t_nLoca)  , aa.t_nLoca, aa.t_retor)  ,'S')    as TR_RESP    ;
          , fi_TmpRESP(aa.t_regul,iif( NOT empty(aa.t_Alarm)  , aa.t_Alarm, aa.t_retor)  ,'S')    as TR_ACIONA  ;
          , fi_TmpRESP(aa.t_Alarm,iif( NOT empty(aa.t_saida)  , aa.t_saida,  aa.t_retor) ,'S')    as TR_SAIDABS ;
          , fi_TmpRESP(aa.t_saida,iif( NOT empty(aa.t_nloca)  , aa.t_nloca,  aa.t_retor) ,'S')    as TR_DESLOCA ;
          , fi_TmpRESP(aa.t_nloca,iif( NOT empty(aa.t_sloca)  , aa.t_sloca,  aa.t_retor) ,'S')    as TR_ATEND   ;
          , fi_TmpRESP(aa.t_saida,iif( NOT empty(aa.t_rsloca) , aa.t_rsloca, aa.t_sloca) ,'S')    as TR_EMPENHO ;
          , fi_TmpRESP(aa.t_nLoca,aa.t_sLoca,'S')                                                 as TR_LOCAL   ;
          , fi_TmpRESP(aa.t_sLoca,aa.t_Retor,'S')                                                 as TR_LIBER   ;
          , ( fi_TmpRESP(aa.t_Saida,aa.t_nLoca,'S') ) + ;                             
            ( fi_TmpRESP(aa.t_sLoca,aa.t_Retor,'S') )                                             as TR_TRANS   ;
   FROM  (cAJT) aa ;
   INTO CURSOR (cTmp)

   IF NOT cFmt=='SS'
      oRet = CREATEOBJECT('Empty')
      =ADDPROPERTY( oRet, 'id', nId )
      FOR i=2 TO FCOUNT()
         _Vlr = (EVALUATE(FIELD(i))/60)
         IF cFmt='HHMMSS'
            _Vlr = tstring( _Vlr )
         ENDIF 
         =ADDPROPERTY( oRet, FIELD(i), _Vlr )
      NEXT 
   ELSE
      SCATTER NAME oRet
   ENDIF    

   =ADDPROPERTY( oRet, 'temRegistro', .t. )
   
ELSE  && nao tem registro
   oRet = CREATEOBJECT('Empty')
   =ADDPROPERTY( oRet, 'temRegistro', .f. )
   =ADDPROPERTY( oRet, 'id', nId )
   
endif   

For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
NEXT

SELECT (nSel)

RETURN oRet