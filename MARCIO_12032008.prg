SELECT     ;
           aa.nome,;
           cc.tipo_contrato,;
           aa.motivocancel,;
           aa.idAssoc,;
           aa.codigo,;
           aa.data_nascimento,;
           aa.dataBase,;
           aa.dataExc,;
           0000 ndep,;
           0000 qtdAtend,;
           aa.fone_comercial,;
           aa.fone_residencia,;
           aa.cidade,;
           aa.bairro,;
           aa.endereco,;
           aa.valor ;
           ;
FROM       ASSOCIADO aa ;
JOIN       CONTRATO  cc ON aa.idContrato == cc.idContrato ;
WHERE      LEFT(cc.tipo_contrato,3) IN ( 'COL','ASS')         ; &&--- somente COL,ASS
  AND      cc.idFilial = '01'                                 ; &&--- somente RP
  AND      SUBSTR(aa.codigo,11,2)   = '00'                    ; &&--- somente TITULAR
  AND      aa.dataExc BETWEEN {^2005-01-01} AND {^2006-12-31} ; &&--- Periodo
  AND      aa.motivocancel <> 'FALECIMENTO'                   ; &&--- menos FALECIDOS
  AND      !EMPTY(aa.fone_comercial+aa.fone_residencia)       ; &&--- somente com TELEFONE
  AND      aa.idContrato NOT IN ( 66299,52246,57055,48910,10980) ;
ORdER BY   aa.cidade, aa.bairro, aa.dataExc ;
INTO CURSO LV_COL READWRITE

SCAN ALL
   
   cCod = LEFT(LV_COL.codigo,10)
   nIdA = LV_COL.idAssoc
   
   SELECT      COUNT(aa.idAssoc) qtd ;
   FROM        ASSOCIADO aa          ;
   WHERE       SUBSTR(aa.codigo,11,2) > '00' AND  aa.codigo = cCod ;
   INTO CURSOR LV_VER
   
   REPLACE LV_COL.ndep WITH LV_VER.qtd
   
   SELECT      SUM(aa.valor) vlr ;
   FROM        ASSOCIADO_PLANO aa ;
   JOIN        ASSOCIADO bb ON aa.idAssoc == bb.idAssoc ;
   WHERE       bb.codigo = cCod ;
   INTO CURSOR LV_VER

   REPLACE LV_COL.valor WITH LV_VER.vlr
   
   *-- verifica os atendimentos
   SELECT      COUNT( aa.tm_Chama ) TOTAL ;
   FROM        atendimento aa ;
   WHERE       aa.pacCodigo=cCod AND aa.idCancelamento=0 AND aa.situacao =2 AND aa.liberacao = 2 ;
   INTO CURSOR LV_VER

   REPLACE LV_COL.qtdAtend WITH LV_COL.qtdAtend + LV_VER.TOTAL 

   *-- verifica os atendimentos
   SELECT      COUNT( aa.tm_Chama ) TOTAL ;
   FROM        hstAtend aa ;
   WHERE       aa.pacCodigo=cCod AND aa.idCancelamento=0 AND aa.situacao =2 AND aa.liberacao = 2 ;
   INTO CURSOR LV_VER
   
   REPLACE LV_COL.qtdAtend WITH LV_COL.qtdAtend + LV_VER.TOTAL 
   
ENDSCAN 



*****************

SELECT     ;
           aa.nome,;
           cc.tipo_contrato,;
           aa.motivocancel,;
           aa.idAssoc,;
           aa.codigo,;
           aa.data_nascimento,;
           aa.dataBase,;
           aa.dataExc,;
           0000 ndep,;
           0000 qtdAtend,;
           aa.fone_comercial,;
           aa.fone_residencia,;
           aa.cidade,;
           aa.bairro,;
           aa.endereco,;
           cc.valor ;
           ;
FROM       ASSOCIADO aa ;
JOIN       CONTRATO  cc ON aa.idContrato == cc.idContrato ;
WHERE      LEFT(cc.tipo_contrato,3) = 'FAM'                   ; &&--- somente FAMILIAR
  AND      cc.idFilial = '01'                                  ; &&--- somente RP
  AND      SUBSTR(aa.codigo,11,2)   = '00'                    ; &&--- somente TITULAR
  AND      aa.dataExc BETWEEN {^2005-01-01} AND {^2006-12-31} ; &&--- Periodo
  AND      aa.motivocancel <> 'FALECIMENTO'                   ; &&--- menos FALECIDOS
  AND      !EMPTY(cc.fone)                                    ; &&--- somente com TELEFONE
  AND      cc.tipo_Parcela = 'MENSAL'                         ; &&--- somente MENSAL
ORdER BY   aa.bairro, aa.dataExc ;
INTO CURSO LV_FAM READWRITE

SCAN ALL
   
   cCod = LEFT(LV_FAM.codigo,10)
   nIdA = LV_FAM.idAssoc
   
   SELECT      COUNT(aa.idAssoc) qtd ;
   FROM        ASSOCIADO aa          ;
   WHERE       SUBSTR(aa.codigo,11,2) > '00' AND  aa.codigo = cCod ;
   INTO CURSOR LV_VER
   
   REPLACE LV_FAM.ndep WITH LV_VER.qtd
   
   SELECT      SUM(aa.valor) vlr ;
   FROM        ASSOCIADO_PLANO aa ;
   JOIN        ASSOCIADO bb ON aa.idAssoc == bb.idAssoc ;
   WHERE       bb.codigo = cCod ;
   INTO CURSOR LV_VER

   REPLACE LV_FAM.valor WITH LV_VER.vlr
   
   *-- verifica os atendimentos
   SELECT      COUNT( aa.tm_Chama ) TOTAL ;
   FROM        atendimento aa ;
   WHERE       aa.pacCodigo=cCod AND aa.idCancelamento=0 AND aa.situacao =2 AND aa.liberacao = 2 ;
   INTO CURSOR LV_VER

   REPLACE LV_FAM.qtdAtend WITH LV_FAM.qtdAtend + LV_VER.TOTAL 

   *-- verifica os atendimentos
   SELECT      COUNT( aa.tm_Chama ) TOTAL ;
   FROM        hstAtend aa ;
   WHERE       aa.pacCodigo=cCod AND aa.idCancelamento=0 AND aa.situacao =2 AND aa.liberacao = 2 ;
   INTO CURSOR LV_VER
   
   REPLACE LV_FAM.qtdAtend WITH LV_FAM.qtdAtend + LV_VER.TOTAL 
   
ENDSCAN 



SELECT aa.*, ' ' EXISTE_ATIVO FROM LV_COL aa ;
UNION ALL             ;
SELECT bb.*, ' ' EXISTE_ATIVO  FROM LV_FAM bb ;
INTO CURSOR LV_JNT READWRITE

SCAN ALL

   cNome = LV_JNT.nome
   
   SELECT      aa.idAssoc ;
   FROM        ASSOCIADO aa ;
   WHERE       aa.nome == cNome AND ;
               aa.codigo='01' AND ;
               aa.situacao='ATIVO' ;
   INTO CURSOR LV_VER
   
   nT = _TALLY 
         
   SELECT LV_JNT
   
   replace EXISTE_ATIVO WITH IIF( nT > 0, 'SIM', '' )
   
ENDSCAN 

SELECT * FROM LV_JNT WHERE EMPTY(EXISTE_ATIVO ) ORDER BY tipo_contrato, bairro, dataExc