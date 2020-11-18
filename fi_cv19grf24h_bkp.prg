Function FI_cv19GRF24H( cAls )
Local i, x, cBase, cGrf, cHTML, cWhe,cFileHTML, cAlsGRF, nSel, cMenu, nOp 
Local aBOP[1], cCod, cSql, cSubTit, nTotGeralCOR, nTotGeralNSU, xGrf

nSel = Select()
cAlsGRF = Sys(2015)

cWhe = '1=1'
cCod = 'H'

Select Distinct bop_id, bop_nome From (cAls) Where CODIGO=cCod And HORA<900 And &cWhe.  Order By 1 Into Array aBOP

cMenu   = 'ZZ) Todas as bases'
For i =1 To Alen(aBOP,1)
   cMenu   = cMenu   +'|'+aBOP[i,1] +') '+ Alltrim(aBOP[i,2])   
Next

nOp = mnShortCut( cMenu, 'Selecione', .t.,,,12 )
IF nOp <= 0
   RETURN .t.
ENDIF 

IF nOp > 1
   nOp = nOp -1
   cWhe = cWhe + " and BOP_ID=='" +aBOP[nOp ,1]+  "'"
ENDIF 

Select Distinct bop_id, bop_nome From (cAls) Where CODIGO=cCod And HORA<900 And &cWhe.  Order By 1 Into Array aBOP
cSubTit = ''
For i =1 To Alen(aBOP,1)
   cSubTit = cSubTit +', '+ Alltrim(aBOP[i,2])
Next
cSubTit = Substr(cSubTit,2)


TEXT TO cSql TEXTMERGE NOSHOW PRETEXT 8
   SELECT       codigo, xEVO as evolucao, dia, HORA 
          , SUM( CAST( corona_total+OMT as i ) ) as nTotATD 
          , SUM( CAST( corona_total as i ) ) as nTotCOR 
          , SUM( CAST( cv19_assint as i ) ) as cv19_assint
          , SUM( CAST( cv19_leve   as i ) ) as cv19_leve
          , SUM( CAST( cv19_grave  as i ) ) as cv19_grave
          , SUM( CAST( OMT as i ) ) as nTotNSU
   FROM         <<cAls>>
   WHERE        CODIGO='<<cCod>>' and HORA<900 AND <<cWhe>>
   GROUP BY     1,2,3,4
   ORDER BY     1,2,3,4
   INTO CURSOR  <<cAlsGRF>>
ENDTEXT
&cSql.

Sum nTotCOR , nTotNSU To nTotGeralCOR, nTotGeralNSU

nTotGeralCOR = Int(nTotGeralCOR)
nTotGeralNSU = Int(nTotGeralNSU)

Select (cAlsGRF)

cGrf= "['DiaHora', 'CornaVirus', 'OMT' ]"

cBase = ''
Scan All
   xGrf = "['Dia "+ Transform(dia,'@L 99') +' as '+ Transform(HORA,'@L 99')+":00'" + ','+ Transform(nTotCOR)+ ','+ Transform(nTotNSU) + ']'
   cGrf = cGrf + ','+xGrf
Endscan

Go Top
cBase = Transform(Datetime())+') '+ Alltrim(evolucao)+': '+Substr(cBase,2) +' )'


TEXT TO cHTML TEXTMERGE NOSHOW
<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', { packages: ['corechart', 'bar']});
      google.charts.setOnLoadCallback(drawStacked);

      function drawStacked() {
        var data = google.visualization.arrayToDataTable([<<cGrf>>]);

        var options = {
          title: '<<TRANSFORM(DATETIME())>>) <<TRANSFORM(nTotGeralCOR+nTotGeralNSU)>> atendimentos nas ultimas 24 horas sendo <<nTotGeralCOR>> CoronaVirus e <<nTotGeralNSU>> nao suspeitos',
          subtitle: '<<cSubTit>>',
          chartArea: {
            width: '70%'
          },
          isStacked: true,
          height: 800,
          colors: ['#ff4500', '#00d2ff'],
          hAxis: {
            title: '<<cSubTit>>',
            minValue: 0,
          },
          vAxis: {
            title: '24 horas'
          }
        };
        var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <div id="chart_div" style="width: 1200px; height: 800px;"></div>
  </body>
</html>


ENDTEXT

cFileHTML = Addbs(Sys(2023))+Sys(2015)+'.HTML'

=Strtofile( cHTML, cFileHTML,0 )
FI_AbrirComWindows( cFileHTML )

Use In (Select(cAlsGRF ))
Select (nSel)

RETURN .T.