Function FI_cv19GRAFICO( cAls )
Local i, x, cBase, cGrf, cHTML, cWhe,cFileHTML, cAlsGRF, nSel, cCod, nTR, cTR, cHTML_BS, cHtm, cDiv

nSel = Select()
cAlsGRF = Sys(2015)
   TEXT TO cHTML_BS TEXTMERGE NOSHOW
<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
    
      __cHTML__
      
    </script>
  </head>
  <body>
    <b>O tempo médio de atendimento pelo(s) reguladore(s) é de __TMP__ minutos</b>
    __cDiv__
  </body>
</html>
   ENDTEXT


cDiv = ''
cHtm = ''
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

      <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
      <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawVisualization<<x>>);

      function drawVisualization<<x>>() {
        var data = google.visualization.arrayToDataTable([ <<cGrf>> ]);

        var options = {
          title : '<<cBase>>',
          colors: ['#0000FF',  '#87CEFA', '#FFFF00', '#ff4500', '#E6E6FA', '#FF8C00'],
          vAxis: {title: 'Quantidade'},
          hAxis: {title: 'Classificacao'},
                slantedText: true,
                slantedTextAngle: 90,
                seriesType: 'bars',
                series: {5: {type: 'line'}}        };

        var chart = new google.visualization.ComboChart(document.getElementById('chart_div<<x>>'));
        chart.draw(data, options);

      }
    </script>
   ENDTEXT
   cDiv = cDiv +CHR(13) +'<<div id="chart_div'+TRANSFORM(x)+'"  style="width: 1400px; height: 700px;"></div>'
   cHtm = cHtm +CHR(13) +cHTML

NEXT

cHTML_BS = STRTRAN( cHTML_BS , '__cHTML__', cHtm )
cHTML_BS = STRTRAN( cHTML_BS , '__cDiv__',  cDiv )
cHTML_BS = STRTRAN( cHTML_BS , '__TMP__',   cTR )


cFileHTML = Addbs(Sys(2023))+Sys(2015)+'.HTML'

_Cliptext = cHTML_BS

=Strtofile( cHTML_BS, cFileHTML,0 )
FI_AbrirComWindows( cFileHTML )

Use In (Select(cAlsGRF ))
Select (nSel)

Return .T.
