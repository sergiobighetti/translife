SET DATE BRITISH
SET Escape ON
SET EXCLUSIVE OFF 
CLOSE DATABASES all


dIni = GOMONTH( DATE(), -12 )

SELECT       aa.idFilial                        as FIL_ID ;
           , cc.tipo_contrato                   as TpContr ;
           , aa.idContrato                      as idContrato ;
           , cc.nome_responsavel                as xContrato ;
           , LEFT(DTOS(aa.data_vencimento),6)   as anoMes ;
           , aa.data_vencimento                 as dVcto ;
           , aa.valor_documento                 as vVencNoMes ;
           , IIF( ISNULL(rr.controle), aa.valor_documento, CAST( 0 as Y )) as vNaoPago ;
           , NVL(rr.vRECEBIDO,0)                as vRecebido ;
           , IIF( LEFT(DTOS(aa.data_vencimento),6)= LEFT(DTOS(rr.dtBaixa),6), NVL(rr.vRECEBIDO,0) , CAST(0 as N(12,2)) ) as vReceNoMes ;
           , IIF( LEFT(DTOS(aa.data_vencimento),6)<>LEFT(DTOS(rr.dtBaixa),6), NVL(rr.vRECEBIDO,0) , CAST(0 as N(12,2)) ) as vReceForaDoMes ;
           , TTOD(NVL(rr.dtBaixa,CTOT('')))     as dBaixa ;
           , IIF( ISNULL(rr.dtBaixa),(DATE()-aa.data_vencimento), ( aa.data_vencimento - TTOD(rr.dtBaixa)) ) as qDiaAtr ;
           , aa.situacao ;
FROM        ARECEBER aa ;
LEFT JOIN   CONTRATO cc ON cc.idContrato == aa.idContrato;
LEFT JOIN   ( SELECT bx.controle, SUM(bx.vlr_Recebido) as vRECEBIDO, MAX(bx.data_baixa) as dtBaixa FROM bxarec bx group by 1 ) as rr ON rr.controle=aa.controle;
WHERE       aa.data_vencimento >= dIni  ; && AND aa.situacao='LIQ'
INTO CURSOR LV_AR



SELECT    anoMes ;
        , SUM(vVencNoMes)      as vVencNoMes  ;
        , SUM(vNaoPago)        as vNaoPago    ;
        , COUNT(1)             as qVencNoMes  ;
        , SUM(vRecebido)       as vRecebido   ;
        , SUM(vReceNoMes)      as vReceNoMes  ;
        , SUM(vReceForaDoMes ) as vReceForaDoMes  ;
        , SUM( IIF( qDiaAtr < 0 , 1, 0 )) as qAtrazo ;
        , SUM( IIF( qDiaAtr < 0 AND BETWEEN( qDiaAtr, -15, -1 ), 1, 0 ) ) as qPgAtrazo_ate15d ;
        , SUM( IIF( qDiaAtr < 0 AND qDiaAtr  < -15, 1, 0 ))               as qPgAtrazo_MaisQ16d ;
FROM    LV_AR ;
GROUP BY 1 ;
INTO CURSOR LV_RST


SELECT    SUM(vVencNoMes)      as vVencNoMes  ;
        , SUM(vNaoPago)        as vNaoPago    ;
        , COUNT(1)             as qVencNoMes  ;
        , SUM(vRecebido)       as vRecebido   ;
        , SUM(vReceNoMes)      as vReceNoMes  ;
        , SUM(vReceForaDoMes ) as vReceForaDoMes  ;
        , AVG(qAtrazo)         as qAtrazo;
        , AVG(qPgAtrazo_ate15d ) as qPgAtrazo_ate15d ;
        , AVG(qPgAtrazo_MaisQ16d ) as qPgAtrazo_MaisQ16d  ;
FROM    LV_RST ;
INTO CURSOR LV_TOT

SCATTER NAME oTot


SELECT    anoMes ;
        , CAST( vVencNoMes as N(14,2))  vVencNoMes ;
        , qVencNoMes  ;
        , CAST( vNaoPago    as N(14,2))  vNaoPago    ;
        , CAST( ((vVencNoMes/oTot.vVencNoMes)*100) AS n(6,2) ) as pVencNoMes ;
        , CAST( vRecebido as N(14,2)) AS vRecebido  ;
        , CAST( ((vRecebido/vVencNoMes)*100) AS N(6,2))  as pRecebido ;
        , CAST( vReceNoMes AS n(14,2)) AS vReceNoMes ;
        , CAST( ((vReceNoMes /vVencNoMes)*100) AS N(6,2))  as pRecNoMes ;
        , CAST(vReceForaDoMes AS N(14,2)) AS vReceForaDoMes  ;
        , CAST( 100-((vReceNoMes /vVencNoMes)*100) AS n(6,2)) as pReceForaDoMes   ;
        , CAST( ((qAtrazo/qVencNoMes )*100) AS N(6,2)) pAtrazo ;
        , AVG(qAtrazo) as qAtrazo ;
        , AVG(qPgAtrazo_ate15d ) as qPgAtrazo_ate15d ;
        , AVG(qPgAtrazo_MaisQ16d ) as qPgAtrazo_MaisQ16d ;
FROM    LV_RST;
GROUP BY 1 ;
INTO CURSOR LV_FIM
BROWSE 

