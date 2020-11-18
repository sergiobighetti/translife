Function fi_vldGradeHR( id_ATEND, cDiv )
Local cWrn, aOpen[1], laClosed[1], x, nSel, cAJT

nSel = SELECT()

=Aused( aOpen )
cAJT = SYS(2015)
cDiv = Iif(Type('cDiv')='C',cDiv,';' )
cWrn = ''

Select      ;
              id ;
            , tm_chama As tm_chama ;
            , fiCTOT( tm_chama, tm_tarme)  As tm_tarme;
            , fiCTOT( tm_chama, tm_regul)  As tm_regul;
            , fiCTOT( tm_chama, tm_alarm)  As tm_alarm;
            , fiCTOT( tm_chama, tm_saida)  As tm_saida;
            , fiCTOT( tm_chama, tm_nloca)  As tm_nloca;
            , fiCTOT( tm_chama, tm_sloca)  As tm_sloca;
            , fiCTOT( tm_chama, tm_rnloca) As tm_rnloca;
            , fiCTOT( tm_chama, tm_rsloca) As tm_rsloca;
            , tm_retor  As tm_retor ;
            , Iif(idCancelamento>0,tm_retor,Ctot(''))  As t_cancel ;  && iss nao existe em MMED e PREM
            , Ctot('') As  tm_cdfin  ; && iss nao existe em MMED e PREM
            , Ctot('') As  tm_livf   ; && iss nao existe em MMED e PREM
            , idCancelamento ;
FROM        atendimento  ;
WHERE       Id = id_ATEND ;
INTO Cursor (cAJT)

if _tally = 0
   Select      ;
                 id ;
               , tm_chama As tm_chama ;
               , fiCTOT( tm_chama, tm_tarme)  As tm_tarme;
               , fiCTOT( tm_chama, tm_regul)  As tm_regul;
               , fiCTOT( tm_chama, tm_alarm)  As tm_alarm;
               , fiCTOT( tm_chama, tm_saida)  As tm_saida;
               , fiCTOT( tm_chama, tm_nloca)  As tm_nloca;
               , fiCTOT( tm_chama, tm_sloca)  As tm_sloca;
               , fiCTOT( tm_chama, tm_rnloca) As tm_rnloca;
               , fiCTOT( tm_chama, tm_rsloca) As tm_rsloca;
               , tm_retor  As tm_retor ;
               , Iif(idCancelamento>0,tm_retor,Ctot(''))  As t_cancel ;  && iss nao existe em MMED e PREM
               , Ctot('') As  tm_cdfin  ; && iss nao existe em MMED e PREM
               , Ctot('') As  tm_livf   ; && iss nao existe em MMED e PREM
               , idCancelamento ;
   FROM        hstatend  ;
   WHERE       Id = id_ATEND ;
   INTO Cursor (cAJT)
   
endif 

If _Tally > 0

   cWrn =     ';' + Iif( Empty(tm_chama), 'Sem hora de chamado','' ) ;
            + ';' + Iif( Empty(tm_retor), 'Sem hora de retorno','' );
            + ';' + Iif( Nvl(idCancelamento,0) <> 0 And Empty(t_cancel), 'Sem hora de cancelamento','' );
            + ';' + Iif( Empty(tm_tarme), 'Sem hora de TARM', '' );
            + ';' + Iif( Empty(tm_saida) Or Empty(tm_alarm)   Or tm_saida >= tm_alarm, '', 'SAIDA e ALARM' );
            + ';' + Iif( Empty(tm_nloca) Or Empty(tm_saida)   Or tm_nloca >= tm_saida, '', 'NO LOCAL e SAIDA' );
            + ';' + Iif( Empty(tm_sloca) Or Empty(tm_nloca)   Or tm_sloca >= tm_nloca, '', 'SAIDA LOCAL e NO LOCAL' );
            + ';' + Iif( Empty(tm_rnloca) Or Empty(tm_sloca)  Or tm_rnloca>= tm_sloca, '', 'NO LOCAL REMOCAO e SAIDA LOCAL' );
            + ';' + Iif( Empty(tm_rsloca) Or Empty(tm_rnloca) Or tm_rsloca >= tm_rnloca, '', 'NO LOCAL REMOCAO e SAIDA LOCAL REMOCAO' );
            + ';' + Iif( Empty(tm_cdfin) Or Empty(tm_rsloca)  Or tm_cdfin >= tm_rsloca, '', 'SAIDA LOCAL REMOCAO e CHEGADA DESTINO FINAL' );
            + ';' + Iif( Empty(tm_livf) Or Empty(tm_cdfin)    Or tm_livf >= tm_cdfin, '', 'CHEGADA DESTINO FINAL e LIVRE FINAL' )

   cWrn = cWrn + ;
              ';' + Iif( !Empty(tm_regul) And tm_regul >= tm_tarme,   '', 'tm_regul < tm_tarme' );
            + ';' + Iif( Empty(tm_alarm)   Or tm_alarm >= tm_tarme,   '', 'tm_alarm < tm_regul' );
            + ';' + Iif( Empty(tm_saida)   Or tm_saida >= tm_saida,   '', 'tm_saida < tm_alarm' );
            + ';' + Iif( Empty(tm_nloca)   Or tm_nloca >= tm_saida,   '', 'tm_nloca < tm_saida' );
            + ';' + Iif( Empty(tm_sloca)   Or tm_sloca >= tm_nloca,   '', 'tm_sloca < tm_nloca' );
            + ';' + Iif( Empty(tm_rnloca)  Or tm_rnloca >= tm_sloca,  '', 'tm_rnloca < tm_sloca' );
            + ';' + Iif( Empty(tm_rsloca)  Or tm_rsloca >= tm_rnloca, '', 'tm_rsloca < tm_rnloca' );
            + ';' + Iif( Empty(tm_cdfin)   Or tm_cdfin >= tm_rsloca,  '', 'tm_cdfin < tm_rsloca' )

   cWrn = Strtran( cWrn, ';;;', ';', 1, 10 )
   cWrn = Strtran( cWrn, ';;;', ';', 1, 10 )
   cWrn = Strtran( cWrn, ';;' , ';', 1, 10 )
   cWrn = Strtran( cWrn, ';;' , ';', 1, 10 )
   cWrn = Alltrim(cWrn)

   If cWrn == ';'
      cWrn = ''
   Else
      If cWrn <> ';' And Left(cWrn,1) = ';'
         cWrn = Substr(cWrn,2,Len(cWrn) )
      Endif
      cWrn = Strtran( cWrn, ';',  cDiv  )

      If cWrn == cDiv
         cWrn = ''
      Endif
   Endif

ENDIF 

USE IN (SELECT(cAJT))
For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
NEXT
SELECT (nSel)

Return PADR(cWrn,240)
