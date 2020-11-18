CLOSE DATABASES all
CD \\192.168.0.200\bdmdc$
SELECT  controle FROM \\dcrpo\bdmdc$\areceber WHERE data_cadastro >= {^2015-04-29 08:00:00} and origem='FATURAMENT' INTO CURSOR xVER
COUNT TO x 
? x


REPLACE  data_cadastro WITH {^2015-05-01 19:02:00} ;
       , data_emissao  with {^2015-05-01} for data_cadastro >= {^2015-04-29 08:00:00} and origem='FATURAMENT'
? _TALLY       