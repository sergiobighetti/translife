CLOSE DATABASES all
cAlsGRF = 'TST'
cTit ='TITYKI'
tRef    = {^2020-07-01 00:00:00}
tRefINI = DTOT( TTOD(tRef)-90 )
tRefFIM = tRef






      SELECT ;
              padl('XXXX',50) as EVOLUCAO ;
            , MONTH(aa.tm_chama) as mes ;
            , DAY( aa.tm_chama)  as dia ;
            , SUM( IIF(INLIST(ta.filtro,'TRA'), 1, 0 ) ) as TOTAL;
            , SUM( IIF(ta.RESUMO='TC', 1,0) )                            as TC ;
            , SUM( IIF(ta.RESUMO='TS', 1,0) )                            as TS ;
            , SUM( IIF(ta.RESUMO='TCI', 1,0) )        as TCI ;
            , SUM( IIF(ta.RESUMO='TCS', 1,0) )        AS TSI ;
      FROM     atendimento aa ;
      JOIN     filial ff ON ff.idfilial= aa.idfilial_atend ;
      JOIN     tipoAtend ta ON ta.id=aa.codAtendimento ;
      WHERE    ta.filtro='TRA' AND aa.tm_chama between tRefINI  and tRefFIM ;
      GROUP BY 1,2,3 ;
      INTO CURSOR (cAlsGRF)
      

cData = "['Dia/Mes', 'TS', 'TC', 'TSI','TCI', 'TOTAL']"
SELECT (cAlsGRF)
SCAN all
   cData = cData +CHR(13)+",['"+ PADL(dia,2,'0')+'/'+PADL(mes,2,'0')+"', "
   cData = cData + TRANSFORM(INT(TS )) +", "
   cData = cData + TRANSFORM(INT(TC )) +", "
   cData = cData + TRANSFORM(INT(TSI)) +", "
   cData = cData + TRANSFORM(INT(TCI)) +", "
   cData = cData + TRANSFORM(INT(TOTAL)) +"]"
ENDSCAN 


TEXT TO cHTML TEXTMERGE NOSHOW
<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawVisualization);

      function drawVisualization() {
        // Some raw data (not necessarily accurate)
        var data = google.visualization.arrayToDataTable([<<cData>>]);

        var options = {
          title : '<<cTit>>',
          vAxis: {title: 'Quantidade'},
          hAxis: {title: 'Dia/Mês'},
          seriesType: 'bars',
          series: {4: {type: 'line'},}
        };

        var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <div id="chart_div" style="width: 1800px; height: 800px;"></div>
  </body>
</html>


ENDTEXT

cFileHTML = Addbs(Sys(2023))+Sys(2015)+'.HTML'

=Strtofile( cHTML, cFileHTML,0 )

 FI_AbrirComWindows( cFileHTML )























*!*         SELECT ;
*!*                 padl('XXXX',50) as EVOLUCAO ;
*!*               , MONTH(aa.tm_chama) as mes ;
*!*               , DAY( aa.tm_chama)  as dia ;
*!*               , SUM( IIF(INLIST(ta.filtro,'APH', 'TRA', 'OMT' ), 1, 0 ) ) as TOTAL;
*!*               , SUM( IIF(ta.filtro='APH',1,0) )                           as APH ;
*!*               , SUM( IIF(ta.filtro='TRA' AND aa.idMedico=0, 1,0) )        as TRA_USB ;
*!*               , SUM( IIF(ta.filtro='TRA' AND aa.idMedico>0, 1,0) )        as TRA_USA ;
*!*               , SUM( IIF(ta.filtro='OMT', 1,0) )                          as OMT ;
*!*         FROM     atendimento aa ;
*!*         JOIN     filial ff ON ff.idfilial= aa.idfilial_atend ;
*!*         JOIN     tipoAtend ta ON ta.id=aa.codAtendimento ;
*!*         WHERE    1=1 AND aa.tm_chama between tRefINI  and tRefFIM ;
*!*         GROUP BY 1,2,3 ;
*!*         INTO CURSOR (cAlsGRF)
*!*         

*!*   cData = "['Dia/Mes', 'OMT', 'APH', 'TRA.USB','TRA.USA', 'TOTAL']"
*!*   SELECT (cAlsGRF)
*!*   SCAN all
*!*      cData = cData +CHR(13)+",['"+ PADL(dia,2,'0')+'/'+PADL(mes,2,'0')+"', "
*!*      cData = cData + TRANSFORM(INT(OMT )) +", "
*!*      cData = cData + TRANSFORM(INT(APH )) +", "
*!*      cData = cData + TRANSFORM(INT(TRA_USB )) +", "
*!*      cData = cData + TRANSFORM(INT(TRA_USA )) +", "
*!*      cData = cData + TRANSFORM(INT(TOTAL)) +"]"
*!*   ENDSCAN 


*!*   TEXT TO cHTML TEXTMERGE NOSHOW
*!*   <html>
*!*     <head>
*!*       <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
*!*       <script type="text/javascript">
*!*         google.charts.load('current', {'packages':['corechart']});
*!*         google.charts.setOnLoadCallback(drawVisualization);

*!*         function drawVisualization() {
*!*           // Some raw data (not necessarily accurate)
*!*           var data = google.visualization.arrayToDataTable([<<cData>>]);

*!*           var options = {
*!*             title : '<<cTit>>',
*!*             vAxis: {title: 'Quantidade'},
*!*             hAxis: {title: 'Dia/Mês'},
*!*             seriesType: 'bars',
*!*             series: {4: {type: 'line'},}
*!*           };

*!*           var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
*!*           chart.draw(data, options);
*!*         }
*!*       </script>
*!*     </head>
*!*     <body>
*!*       <div id="chart_div" style="width: 1800px; height: 800px;"></div>
*!*     </body>
*!*   </html>


*!*   ENDTEXT

*!*   cFileHTML = Addbs(Sys(2023))+Sys(2015)+'.HTML'

*!*   =Strtofile( cHTML, cFileHTML,0 )
*!*   *!*   Declare Integer BringWindowToTop In user32 Integer
*!*   *!*   Declare Integer SetWindowText In user32 Integer,String
*!*   *!*   Declare Integer Sleep In kernel32 Integer

*!*   *!*      apie=Newobject("internetexplorer.application")
*!*   *!*      With apie
*!*   *!*         .Navigate(cFileHTML )
*!*   *!*         .Width=Sysmetric(1)
*!*   *!*         .Height=Sysmetric(2)-30
*!*   *!*         .Left=0
*!*   *!*         .Top=0
*!*   *!*          .menubar=0
*!*   *!*         .StatusBar=0
*!*   *!*         .Toolbar=0
*!*   *!*        * Sleep(1000) &&pass transitionnings
*!*   *!*         =SetWindowText(.HWnd,"google map intinerário: "+cFileHTML )
*!*   *!*         =BringWindowToTop(.HWnd)
*!*   *!*         .Visible=.T.
*!*   *!*      Endwith


*!*    FI_AbrirComWindows( cFileHTML )

*!*   Use In (Select(cAlsGRF ))
