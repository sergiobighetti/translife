LOCAL dRef
CLOSE DATABASES all
CLOSE TABLES all
CD \\memrp\bdmdc$
SET EXCLUSIVE OFF



dRef = DATE()

SELECT       ;
             LEFT( aa.codigo, 2 ) FIL,;
             aa.situacao,;
             aa.codigo,;
             aa.nome,;
             aa.database DTBASE,;
             aa.dataExc  DTCANC,;
             IIF( aa.situacao='CANC', (aa.dataexc-aa.dataBase), dRef-aa.dataBase ) DIAS_PERM,;
             PADR(CALCIDADE(aa.DataBase, IIF(aa.situacao='CANC',aa.dataExc, dRef ), 'EXTENSOR' ),10) TEMPO_VIDA,;
             aa.idContrato,;
             cc.tipo_contrato,;
             cc.nome_responsavel,;
             aa.idassoc ;
             ;
FROM         associado aa ;
JOIN         contrato  cc ON aa.idContrato == cc.idContrato ;
WHERE        IIF( !EMPTY(aa.dataExc), aa.dataExc>={^2006-01-01}, .t. ) AND aa.atendimento = .t. ;
INTO CURSOR  CBASE



SELECT      situacao,;
            FIL,;
            tipo_contrato,;
            MAX(DIAS_PERM) MAX_DIAS,;
            MIN(DIAS_PERM) MIN_DIAS,;
            AVG(DIAS_PERM) MED_DIAS ;
FROM        CBASE ;
WHERE       DIAS_PERM BETWEE 0 AND 5110 AND fil = '01' ;
GROUP BY    1,2,3 ;
ORDER BY    1,2,3           


