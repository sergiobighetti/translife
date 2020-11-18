Function FI_cv19GRAFICO( cAls )
Local i, x, cBase, cGrf, cHTML, cWhe,cFileHTML, cAlsGRF, nSel, cCod, nTR, cTR

nSel = Select()
cAlsGRF = Sys(2015)

For x=1 To 4

   cWhe = '(1=1)'
   cCod = Chr(64+x)

   Select       codigo, xEVO As evolucao, bop_id, bop_nome, ;
                corona_total, cv19_leve, cv19_grave, cv19_assint, omt, totatend ;
   FROM         (cAls)  ;
   WHERE         codigo=cCod And bop_id<>'ZZ' And &cWhe. ;
   INTO Cursor  (cAlsGRF)

   Select (cAlsGRF)

   cGrf= "['Base', 'Assint+Leve+Grave', 'Assintomatico', 'Leve', 'Grave', 'OMT', 'TotAtend'],"
   cBase = ''
   Scan All
      cBase = cBase +',Bs'+bop_id+'='+ Alltrim(bop_nome)
      TEXT TO xGrf TEXTMERGE NOSHOW
['<<"Bs"+bop_id>>', <<INT(corona_total)>>, <<INT(cv19_assint)>>, <<INT(cv19_leve)>>, <<INT(cv19_grave)>>, <<INT(omt)>>, <<INT(TotAtend)>>],
      ENDTEXT
      cGrf = cGrf + xGrf
   Endscan
   Go Top


   nTR = cv19_TRESP('aa.tr_reg<500',5)  && somente regulacao valida com descater de 5% TOP UP
   cTR = tstring( INT(VAL(  CHRTRAN(TRANSFORM(nTR),'.,','')   )) )
   
   cBase = Transform(Datetime()) +')'+  Alltrim(&cAlsGRF..evolucao)+': '+Substr(cBase,2) +' )'


   TEXT TO cHTML TEXTMERGE NOSHOW
<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawVisualization);

      function drawVisualization() {
        // Some raw data (not necessarily accurate)
        var data = google.visualization.arrayToDataTable([
<<cGrf>>
        ]);

        var options = {
          title : '<<cBase>>',
          colors: ['#0000FF',  '#87CEFA', '#FFFF00', '#ff4500', '#E6E6FA', '#FF8C00'],
          vAxis: {title: 'Quantidade'},

          hAxis: {title: 'Classificacao'},
                slantedText: true,
                slantedTextAngle: 90,
                seriesType: 'bars',
                series: {5: {type: 'line'}}        };

        var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
        chart.draw(data, options);

      }
    </script>
  </head>
  <body>
    <div id="chart_div" style="width: 1400px; height: 700px;"></div>
    <div class="a">
         <b> O tempo médio de atendimento pelo(s) reguladore(s) é de <<cTR>> minutos </b>
     </div>
  </body>
</html>
   ENDTEXT

   cFileHTML = Addbs(Sys(2023))+Sys(2015)+'.HTML'

   =Strtofile( cHTML, cFileHTML,0 )
   FI_AbrirComWindows( cFileHTML )
Next

Use In (Select(cAlsGRF ))
Select (nSel)

Return .T.
