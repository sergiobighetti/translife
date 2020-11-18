CLOSE DATABASES all
CLOSE TABLES all

nIdCtrI = 6
nIdCtrF = 6

CREATE CURSOR LV_AAMM ( anoMes C(6) )

dRef = GOMONTH( DATE(), -13 )
dRef = ( dRef - DAY(dRef) +1 )
FOR i = 1 TO 12
   INSERT INTO LV_AAMM VALUES ( LEFT(DTOS( GOMONTH(dRef,i) ),6) )
NEXT 

SELECT       ;
             aa.idContrato    ;
           , NVL(cc.tipo_contrato,     SPACE(15)) as tipo_contrato  ;
           , NVL(cc.nome_responsavel , SPACE(60)) as nome_responsavel ;
           , LEFT(DTOS(aa.data_vencimento),6) as AnoMes;
           , SUM( IIF(aa.origem ='FATURAMENT', aa.valor_documento, 00000000000.00) ) as vFAT_MENSAL ;
           , SUM( IIF(aa.origem<>'FATURAMENT', aa.valor_documento, 00000000000.00) ) as vFAT_Extra ;
           , SUM(aa.valor_documento)                                                 as vFAT_TOTAL ;
FROM         ARECEBER aa ;
LEFT join    CONTRATO cc ON cc.idContrato = aa.idContrato ;
WHERE        aa.idContrato BETWEEN nIDCtrI AND nIDCtrF  and  LEFT(DTOS(aa.data_vencimento),6) IN ( SELECT ANOMES FROM LV_AAMM ) ;
GROUP BY     1,2,3,4;
ORDER BY     1,2,3,4;
INTO CURSOR  LV_FAT 



SELECT      ;
            aa.ctrNumero as idContrato    ;
          , cc.tipo_contrato ;
          , cc.nome_responsavel ;
          , LEFT(DTOS(aa.tm_chama),6)  as AnoMes;
          , SUM(IIF( ta.filtro='TRA', 1, 0 )) as qTRA_TOTAL ;
          , SUM(IIF( ta.filtro='TRA' AND aa.idMedico>0, 1, 0 )) as qTRA_USA ;
          , SUM(IIF( ta.filtro='TRA' AND aa.idMedico=0, 1, 0 )) as qTRA_USB ;
          , SUM(IIF( ta.filtro='APH', 1, 0 )) as qAPH ;
          , SUM(IIF( ta.filtro='OMT', 1, 0 )) as qOMT ;
          , COUNT(1) as qTOTAL_ATEND ;
FROM      ATENDIMENTO aa ;
JOIN      TIPOATEND   ta on ta.id=aa.codAtendimento ;
join      CONTRATO cc ON cc.idContrato = aa.ctrNumero ;
WHERE     aa.ctrNumero BETWEEN nIDCtrI AND nIDCtrF AND   aa.idCancelamento=0 AND aa.situacao=2 AND aa.liberacao =2 ;
GROUP BY  1,2,3,4 ;
UNION ALL ;
SELECT    ;
          aa.ctrNumero as idContrato    ;
        , cc.tipo_contrato ;
        , cc.nome_responsavel ;
        , LEFT(DTOS(aa.tm_chama),6)  as AnoMes;
        , SUM(IIF( ta.filtro='TRA', 1, 0 )) as qTRA_TOTAL ;
        , SUM(IIF( ta.filtro='TRA' AND aa.idMedico>0, 1, 0 )) as qTRA_USA ;
        , SUM(IIF( ta.filtro='TRA' AND aa.idMedico=0, 1, 0 )) as qTRA_USB ;
        , SUM(IIF( ta.filtro='APH', 1, 0 )) as qAPH ;
        , SUM(IIF( ta.filtro='OMT', 1, 0 )) as qOMT ;
        , COUNT(1) as qTOTAL_ATEND ;
FROM      HSTATEND aa ;
JOIN      TIPOATEND   ta on ta.id=aa.codAtendimento ;
join      CONTRATO cc ON cc.idContrato = aa.ctrNumero ;
WHERE     aa.ctrNumero BETWEEN nIDCtrI AND nIDCtrF AND   aa.idCancelamento=0 AND aa.situacao=2 AND aa.liberacao =2 ;
GROUP BY  1,2,3,4 ;
INTO CURSOR LV_ATEND 

SELECT     aa.idContrato, aa.Tipo_Contrato, aa.nome_responsavel, aa.AnoMes ;
         , SUM( aa.qTRA_TOTAL ) as qTRA_TOTAL ;
         , SUM( aa.qTRA_USA ) as qTRA_USA ;
         , SUM( aa.qTRA_USB ) as qTRA_USB ;
         , SUM( aa.qAPH ) as qAPH ;
         , SUM( aa.qOMT ) as qOMT ;
         , SUM( aa.qTOTAL_ATEND ) as qTOTAL_ATEND ;
FROM     LV_ATEND aa ;
GROUP BY 1,2,3,4 ;
ORDER BY 1,2,3,4 ;
INTO CURSOR LV_ATEND 

USE IN (SELECT('ATENDIMENTO'))
USE IN (SELECT('HSTATEND'))
USE IN (SELECT('TIPOATEND'))
USE IN (SELECT('CONTRATO'))
USE IN (SELECT('ARECEBER'))



SELECT    NVL(vf.idContrato,0) as idContrato, NVL(vf.tipo_contrato,SPACE(15)) as tipo_contrato, NVL(vf.nome_responsavel,SPACE(60)) as nome_responsavel, am.AnoMes;
        , NVL(vf.vFAT_MENSAL,0000000000.00) as vFAT_MENSAL, NVL(vf.vFAT_Extra,0000000000.00) as vFAT_Extra, NVL(vf.vFAT_TOTAL,0000000000.00) as vFAT_TOTAL ;
FROM      LV_AAMM am ;
LEFT JOIN LV_FAT  vf ON vf.anoMes = am.anoMes ;
ORDER BY 1,2,3,4 ;
INTO CURSOR LV_RST_FAT


SELECT    NVL(aa.idContrato,0) as idContrato, NVL(aa.tipo_contrato,SPACE(15)) as tipo_contrato, NVL(aa.nome_responsavel,SPACE(60)) as nome_responsavel, am.AnoMes;
        , NVL(aa.qTRA_TOTAL   , 0000000000) as qTRA_TOTAL ;
        , NVL(aa.qTRA_USA     , 0000000000) as qTRA_USA ;
        , NVL(aa.qTRA_USB     , 0000000000) as qTRA_USB ;
        , NVL(aa.qAPH         , 0000000000) as qAPH ;
        , NVL(aa.qOMT         , 0000000000) as qOMT ;
        , NVL(aa.qTOTAL_ATEND , 0000000000) as qTOTAL_ATEND ;
FROM      LV_AAMM   am ;
LEFT JOIN LV_ATEND  aa ON aa.anoMes = am.anoMes ;
ORDER BY 1,2,3,4 ;
INTO CURSOR LV_RST_ATD


USE IN (SELECT('LV_FAT'))
USE IN (SELECT('LV_ATEND'))

