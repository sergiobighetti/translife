
** Atend Lib Ultimas 24 horas
tRef = {^2020-01-29 12:00} 
cDtHrFIM = TRANSFORM( TTOC(tRef,1), '@R 9999-99-99 99:99:00' )
cDtHrINI = TRANSFORM( TTOC(( tRef-(24*(60*60)) ),1), '@R 9999-99-99 99:99:00' )


cWhe = 'aa.situacao=2 and aa.idCancelamento=0 and aa.tm_chama between {^'+cDtHrINI+'} and {^'+cDtHrFIM+'}'
*!*   SELECT ;
*!*         'Atend Lib Ultimas 24 horas' as Quebra, ta.resumo as descricao, COUNT(1) as qtd ;
*!*   FROM ATENDIMENTO aa ;
*!*   JOIN TIPOATEND ta on ta.id = aa.codAtendimento ;
*!*   WHERE   &cWhe. ;
*!*   GROUP BY 2



*!*   SELECT ;
*!*         'Atend p/ Tipo Ultimas 24 horas' as Quebra, ta.filtro as descricao, COUNT(1) as qtd ;
*!*   FROM ATENDIMENTO aa ;
*!*   JOIN TIPOATEND ta on ta.id = aa.codAtendimento ;
*!*   WHERE   &cWhe. ;
*!*   GROUP BY 2


SELECT ;
      fl.nome, ta.resumo as descricao, COUNT(1) as qtd ;
FROM ATENDIMENTO aa ;
JOIN TIPOATEND ta on ta.id = aa.codAtendimento ;
JOIN FILIAL fl ON fl.idFilial = aa.idfilial_atend ;
WHERE   &cWhe. ;
GROUP BY 1,2

