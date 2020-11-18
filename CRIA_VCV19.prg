CLOSE DATABASES all
OPEN DATABASE bdmdc

DELETE VIEW V_BASE_COVIDl9 

* SELECT   * FROM bdmdc!V_BASE_COVIDl9 

create  VIEW V_BASE_COVIDl9 as ;
SELECT    ;
        aa.idFIlial_Atend   as bop_id ;
      , bb.Nome             as bop_nome;
      , aa.CtrNumero        as CTR_ID;
      , aa.CtrResponsavel   as CTR_NOME;
      , aa.tm_chama         as atd_data;
      , YEAR(aa.tm_chama)   as ano;
      , MONTH(aa.tm_chama)  as mes;
      , DAY(aa.tm_chama)    as dia;
      , HOUR(aa.tm_chama)   as hora;
      , CAST( IIF( aa.codAtendimento=22, 1,0) as i ) as CV19_ASSINT;
      , CAST( IIF( aa.codAtendimento=23, 1,0) as i ) as CV19_LEVE;
      , CAST( IIF( aa.codAtendimento=24, 1,0) as i ) as CV19_GRAVE;
      , CAST( IIF( aa.codAtendimento=13, 1,0) as i ) as OMT;
      , ELAPTIME( aa.tm_chama,aa.tm_tarme+':00',.T.)      as TR_TAR ;
      , ELAPTIME(aa.tm_tarme+':00',aa.tm_regul+':00',.T.) as TR_REG ;
FROM  ATENDIMENTO aa ;
JOIN  Filial      bb ON bb.idFilial = aa.idFilial ;
WHERE aa.tm_chama >={^2020-03-01 00:00:00} and  aa.codAtendimento in ( 22,23,24 ) and aa.idCancelamento=0 






create  VIEW V_BASE_COVIDl9_U14D  as ;
      SELECT ;
              padR('Evolucao ultimos 14 dias',50) as EVOLUCAO;
            , aa.bop_id;
            , aa.bop_nome;
            , SUM( aa.CV19_ASSINT+ aa.CV19_LEVE + aa.CV19_GRAVE )     as CORONA_TOTAL;
            , SUM( aa.CV19_ASSINT)                              as CV19_ASSINT;
            , SUM( aa.CV19_LEVE)                              as CV19_LEVE;
            , SUM( aa.CV19_GRAVE)                              as CV19_GRAVE;
            , SUM( aa.OMT)                                      as OMT;
      FROM     BDMDC!V_BASE_COVIDl9 aa;
      WHERE    aa.atd_data between (EVALUATE( '{^'+ TRANSFORM( DTOS(DATE()-14), '@R 9999-99-99') +' 00:00}' )) and datetime() ;
      GROUP BY aa.bop_id, aa.bop_nome;
   UNION all;
      SELECT;
              padR('Evolucao ultimos 14 dias',50)                 as EVOLUCAO;
            , 'ZZ'                                         as bop_id;
            , padR( 'TOTAL Evolucao ultimos 14 dias...',50)          as bop_nome;
            , SUM( aa.CV19_ASSINT+ aa.CV19_LEVE + aa.CV19_GRAVE )    as CORONA_TOTAL;
            , SUM( aa.CV19_ASSINT)                             as CV19_ASSINT;
            , SUM( aa.CV19_LEVE)                             as CV19_LEVE;
            , SUM( aa.CV19_GRAVE)                             as CV19_GRAVE;
            , SUM( aa.OMT)                                     as OMT;
      FROM     BDMDC!V_BASE_COVIDl9 aa;
      WHERE    aa.atd_data between (EVALUATE( '{^'+ TRANSFORM( DTOS(DATE()-14), '@R 9999-99-99') +' 00:00}' )) and datetime()








create  VIEW V_BASE_COVIDl9_U24H as ;
      SELECT ;
              PADR('Evolucao p/hora ultimas 24 horas',50) as EVOLUCAO;
            , aa.bop_id;
            , aa.bop_nome;
            , aa.dia;
            , aa.hora;
            , SUM( aa.CV19_ASSINT+ aa.CV19_LEVE + aa.CV19_GRAVE )     as CORONA_TOTAL;
            , SUM( aa.CV19_ASSINT)                              as CV19_ASSINT;
            , SUM( aa.CV19_LEVE)                              as CV19_LEVE;
            , SUM( aa.CV19_GRAVE)                              as CV19_GRAVE;
            , SUM( aa.OMT)                                      as OMT;
      FROM     bdmdc!V_BASE_COVIDl9 aa;
      WHERE    aa.atd_data between (EVALUATE( '{^'+ TRANSFORM( DTOS(DATE()-1), '@R 9999-99-99') +' '+TIME() +'}' )) and datetime() ;
      GROUP BY aa.bop_id, aa.bop_nome, aa.dia, aa.hora
























create  VIEW V_BASE_COVIDl9_U14D as ;
      SELECT ;
              padR('Evolucao ultimos 14 dias',50) as EVOLUCAO;
            , aa.bop_id;
            , aa.bop_nome;
            , SUM( aa.CV19_ASSINT+ aa.CV19_LEVE + aa.CV19_GRAVE )     as CORONA_TOTAL;
            , SUM( aa.CV19_ASSINT)                              as CV19_ASSINT;
            , SUM( aa.CV19_LEVE)                              as CV19_LEVE;
            , SUM( aa.CV19_GRAVE)                              as CV19_GRAVE;
            , SUM( aa.OMT)                                      as OMT;
      FROM     BDMDC!V_BASE_COVIDl9 aa;
      WHERE    aa.atd_data between (EVALUATE( '{^'+ TRANSFORM( DTOS(DATE()-14), '@R 9999-99-99') +' 00:00}' )) and datetime() ;
      GROUP BY aa.bop_id, aa.bop_nome;
   UNION all;
      SELECT;
              padR('Evolucao ultimos 14 dias',50)                 as EVOLUCAO;
            , 'ZZ'                                         as bop_id;
            , padR( 'TOTAL Evolucao ultimos 14 dias...',50)          as bop_nome;
            , SUM( aa.CV19_ASSINT+ aa.CV19_LEVE + aa.CV19_GRAVE )    as CORONA_TOTAL;
            , SUM( aa.CV19_ASSINT)                             as CV19_ASSINT;
            , SUM( aa.CV19_LEVE)                             as CV19_LEVE;
            , SUM( aa.CV19_GRAVE)                             as CV19_GRAVE;
            , SUM( aa.OMT)                                     as OMT;
      FROM     BDMDC!V_BASE_COVIDl9 aa;
      WHERE    aa.atd_data between (EVALUATE( '{^'+ TRANSFORM( DTOS(DATE()-14), '@R 9999-99-99') +' 00:00}' )) and datetime()









































create  VIEW V_BASE_COVIDl9_POR_CTR as ;
SELECT ;
xx.*   ;
FROM ( ; 
      select ;
               BOP_ID, BOP_NOME, CTR_ID,CTR_NOME, ano, mes ;
               , CAST( NVL( SUM( IIF( dia=01, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d01;
               , CAST( NVL( SUM( IIF( dia=02, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d02;
               , CAST( NVL( SUM( IIF( dia=03, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d03;
               , CAST( NVL( SUM( IIF( dia=04, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d04;
               , CAST( NVL( SUM( IIF( dia=05, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d05;
               , CAST( NVL( SUM( IIF( dia=06, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d06;
               , CAST( NVL( SUM( IIF( dia=07, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d07;
               , CAST( NVL( SUM( IIF( dia=08, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d08;
               , CAST( NVL( SUM( IIF( dia=09, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d09;
               , CAST( NVL( SUM( IIF( dia=10, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d10;
               , CAST( NVL( SUM( IIF( dia=11, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d11;
               , CAST( NVL( SUM( IIF( dia=12, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d12;
               , CAST( NVL( SUM( IIF( dia=13, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d13;
               , CAST( NVL( SUM( IIF( dia=14, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d14;
               , CAST( NVL( SUM( IIF( dia=15, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d15;
               , CAST( NVL( SUM( IIF( dia=16, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d16;
               , CAST( NVL( SUM( IIF( dia=17, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d17;
               , CAST( NVL( SUM( IIF( dia=18, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d18;
               , CAST( NVL( SUM( IIF( dia=19, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d19;
               , CAST( NVL( SUM( IIF( dia=20, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d20;
               , CAST( NVL( SUM( IIF( dia=21, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d21;
               , CAST( NVL( SUM( IIF( dia=22, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d22;
               , CAST( NVL( SUM( IIF( dia=23, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d23;
               , CAST( NVL( SUM( IIF( dia=24, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d24;
               , CAST( NVL( SUM( IIF( dia=25, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d25;
               , CAST( NVL( SUM( IIF( dia=26, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d26;
               , CAST( NVL( SUM( IIF( dia=27, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d27;
               , CAST( NVL( SUM( IIF( dia=28, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d28;
               , CAST( NVL( SUM( IIF( dia=29, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d29;
               , CAST( NVL( SUM( IIF( dia=30, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d30;
               , CAST( NVL( SUM( IIF( dia=31, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d31;
               , CAST( NVL( SUM( CV19_ASSINT+CV19_LEVE+CV19_GRAVE ), 0 ) as i )               as TOT_ASINT_LEVE_GRAVE;
               , CAST( NVL( SUM( OMT ), 0 ) as i )                                 as TOT_OMT;
      FROM   BDMDC!V_BASE_COVIDl9;
      group by BOP_ID, BOP_NOME, CTR_ID,CTR_NOME, ano, mes ;
      UNION ALL;
      select ;
               BOP_ID, BOP_NOME, 999999 as CTR_ID, 'Todos os contratos...' as CTR_NOME, ano, mes;
               , CAST( NVL( SUM( IIF( dia=01, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d01;
               , CAST( NVL( SUM( IIF( dia=02, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d02;
               , CAST( NVL( SUM( IIF( dia=03, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d03;
               , CAST( NVL( SUM( IIF( dia=04, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d04;
               , CAST( NVL( SUM( IIF( dia=05, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d05;
               , CAST( NVL( SUM( IIF( dia=06, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d06;
               , CAST( NVL( SUM( IIF( dia=07, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d07;
               , CAST( NVL( SUM( IIF( dia=08, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d08;
               , CAST( NVL( SUM( IIF( dia=09, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d09;
               , CAST( NVL( SUM( IIF( dia=10, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d10;
               , CAST( NVL( SUM( IIF( dia=11, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d11;
               , CAST( NVL( SUM( IIF( dia=12, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d12;
               , CAST( NVL( SUM( IIF( dia=13, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d13;
               , CAST( NVL( SUM( IIF( dia=14, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d14;
               , CAST( NVL( SUM( IIF( dia=15, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d15;
               , CAST( NVL( SUM( IIF( dia=16, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d16;
               , CAST( NVL( SUM( IIF( dia=17, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d17;
               , CAST( NVL( SUM( IIF( dia=18, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d18;
               , CAST( NVL( SUM( IIF( dia=19, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d19;
               , CAST( NVL( SUM( IIF( dia=20, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d20;
               , CAST( NVL( SUM( IIF( dia=21, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d21;
               , CAST( NVL( SUM( IIF( dia=22, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d22;
               , CAST( NVL( SUM( IIF( dia=23, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d23;
               , CAST( NVL( SUM( IIF( dia=24, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d24;
               , CAST( NVL( SUM( IIF( dia=25, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d25;
               , CAST( NVL( SUM( IIF( dia=26, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d26;
               , CAST( NVL( SUM( IIF( dia=27, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d27;
               , CAST( NVL( SUM( IIF( dia=28, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d28;
               , CAST( NVL( SUM( IIF( dia=29, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d29;
               , CAST( NVL( SUM( IIF( dia=30, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d30;
               , CAST( NVL( SUM( IIF( dia=31, CV19_ASSINT+CV19_LEVE+CV19_GRAVE, 0 ) ), 0 ) as i ) as d31;
               , CAST( NVL( SUM( CV19_ASSINT+CV19_LEVE+CV19_GRAVE ), 0 ) as i )               as TOT_ASINT_LEVE_GRAVE;
               , CAST( NVL( SUM( OMT ), 0 ) as i )                                 as TOT_OMT;
      FROM   BDMDC!V_BASE_COVIDl9;
      group by BOP_ID, BOP_NOME,  ano, mes ;
) xx


