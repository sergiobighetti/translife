CLOSE DATABASES all
SET EXCLUSIVE OFF 

SELECT     ;
             ff.nome FILIAL ;
           , SUM( IIF( ta.filtro='OMT' AND EMPTY(aa.tm_retor) and IIF( !empty(aa.RegClassificacao), aa.RegClassificacao, aa.AteClassificacao )='ORIENTACAO',1,0) ) as OMT_Aguardando ;
           , SUM( IIF( ta.filtro='APH' AND EMPTY(aa.tm_retor) and empty(LEFT(aa.tm_Alarm,2)),1,0 )) as APH_Aguardando ;
           , SUM( IIF( ta.filtro='TRA' AND EMPTY(aa.tm_retor) and aa.tm_chama<=DATETIME() AND  empty(LEFT(aa.tm_Alarm,2)),1,0 )) as TRA_Aguardando ;
           , SUM( IIF( ta.filtro='TRA' AND EMPTY(aa.tm_retor) and aa.tm_chama >DATETIME() AND  empty(LEFT(aa.tm_Alarm,2)),1,0 )) as TRA_Agenda ;
           ;
           , SUM( IIF( ta.filtro='APH' AND aa.liberacao= 2 AND !empty(LEFT(aa.tm_Alarm,2)) AND EMPTY(aa.tm_retor),1,0 )) as APH_EmAndamento ;
           , SUM( IIF( ta.filtro='TRA' AND aa.liberacao= 2 AND !empty(LEFT(aa.tm_Alarm,2)) AND EMPTY(aa.tm_retor) AND aa.idMedico>0,1,0 )) as USA_Empenhada ;
           , SUM( IIF( ta.filtro='TRA' AND aa.liberacao= 2 AND !empty(LEFT(aa.tm_Alarm,2)) AND EMPTY(aa.tm_retor) AND aa.idMedico=0,1,0 )) as USB_Empenhada ;
           ;
FROM         atendimento aa ;
JOIN         FILIAL ff ON ff.idFilial=aa.idfilial_atend ;
JOIN         TIPOATEND ta ON ta.id = aa.codAtendimento ;
WHERE      !EMPTY(aa.idfilial_atend)  ;
           AND aa.situacao = 1 ;
           AND aa.idcancelamento= 0;
GROUP BY   1 

* OMT,APH,TRA,AD

SELECT ;
         ff.nome FILIAL ;
       , SUM( IIF(tipo_transporte='COMPL',1,0) ) as AG_TRA_COMPLETO ;
       , SUM( IIF(tipo_transporte='SIMPL',1,0) ) as AG_TRA_SIMPLES ;
FROM TRANSP tr ;
JOIN FILIAL ff ON ff.idfilial = tr.idFilial ;
WHERE tr.data_transporte > DATETIME() AND tr.data_transporte <= (DATETIME()+86400) ;
and tr.situacao = '2' ;
GROUP BY 1


SELECT ff.nome as filial, ev.idEvento, ev.prev_inicio, ev.eve_nome, ev.eve_local, ev.eve_cid, ev.qtd_medico, ev.qtd_tecnico, ev.qtd_motorista, ev.prev_termino ;
FROM EVENTO ev ;
JOIN FILIAL ff ON ff.idfilial = ev.idFilial ;
WHERE ev.situacao = '2' AND ev.prev_inicio  > DATETIME()  AND ev.prev_inicio <= (DATETIME()+(86400*3)) ;
