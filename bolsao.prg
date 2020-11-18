CD \\dcrpo\bdmdc$
CLOSE DATABASES all
CLOSE TABLES all
CLEAR
SET ESCAPE ON 
SET EXCLUSIVE OFF 

*-- ultimos 12 meses
dRefFIM = DATETIME()
dRefINI = GOMONTH( dRefFIM, -12 )


SELECT ;
       aa.idcontrato,;
       aa.tipo_contrato,;
       bb.idEmpresa,;
       ee.cnpj,;
       ee.NomeEmpresa,;
       ;
       SUM( (SELECT SUM(zz.valor) ;
             FROM   ASSOCIADO_PLANO zz ;
             WHERE  zz.idAssoc == bb.idAssoc ) ) VLR_EMPRESA,;
       ;
       SUM( IIF(bb.atendimento=.t.,1,0) ) QTD_VIDAS,;
       ;
       SUM( ( ( select COUNT(xx.id) ;
           FROM   atendimento xx ;
           WHERE  xx.ctrnumero == bb.idContrato  ;
             AND  xx.tm_chama BETWEEN dRefINI AND dRefFIM ;
             AND  xx.pacCodigo = bb.codigo ;
              AND xx.situacao  == 2 ;                 && ENCERRADO
              AND xx.liberacao == 2 ;                 && LIBERADO  
              AND EMPTY(xx.idcancelamento) ) ;        && NAO ESTA CANCELADO
         + ;
         ( select COUNT(yy.id) ;
           FROM   hstAtend yy ;
           WHERE  yy.ctrnumero == bb.idContrato  ;
              AND yy.tm_chama BETWEEN dRefINI AND dRefFIM ;
              AND yy.pacCodigo = bb.codigo ;
              AND yy.situacao  == 2 ;          
              AND yy.liberacao == 2 ;          
              AND EMPTY(yy.idcancelamento) ) ) ) AS QTD_ATEND ;
         ;
         ,CAST( '' as D ) as data_Vencimento ;
         ,$0 as valor_documento ;
         ;
FROM   ASSOCIADO bb ;
JOIN   CONTRATO aa on bb.idContrato == aa.idContrato ;
JOIN   EMPRESA ee on bb.idEmpresa == ee.idEmpresa ;
WHERE     aa.idFilial='01' AND ;
          aa.situacao='ATIVO' AND ;
          bb.situacao='ATIVO' AND ;
          ee.situacao='ATIVO' AND ;
          aa.tipo_contrato='ASSOC' ;
GROUP BY  1,2,3,4 ;
ORDER  BY 1,2,3,4 ;
INTO CURSOR CLVX READWRITE 





SELECT ;
       aa.idcontrato,;
       aa.tipo_contrato,;
       bb.idEmpresa,;
       SPACE(14) as cnpj,;
       SPACE(50) as NomeEmpresa,;
       ;
       SUM( (SELECT SUM(zz.valor) ;
             FROM   ASSOCIADO_PLANO zz ;
             WHERE  zz.idAssoc == bb.idAssoc ) ) VLR_EMPRESA,;
       ;
       SUM( IIF(bb.atendimento=.t.,1,0) ) QTD_VIDAS,;
       ;
       SUM( ( ( select COUNT(xx.id) ;
           FROM   atendimento xx ;
           WHERE  xx.ctrnumero == bb.idContrato  ;
             AND  xx.tm_chama BETWEEN dRefINI AND dRefFIM ;
             AND  xx.pacCodigo = bb.codigo ;
              AND xx.situacao  == 2 ;                 && ENCERRADO
              AND xx.liberacao == 2 ;                 && LIBERADO  
              AND EMPTY(xx.idcancelamento) ) ;        && NAO ESTA CANCELADO
         + ;
         ( select COUNT(yy.id) ;
           FROM   hstAtend yy ;
           WHERE  yy.ctrnumero == bb.idContrato  ;
              AND yy.tm_chama BETWEEN dRefINI AND dRefFIM ;
              AND yy.pacCodigo = bb.codigo ;
              AND yy.situacao  == 2 ;          
              AND yy.liberacao == 2 ;          
              AND EMPTY(yy.idcancelamento) ) ) ) AS QTD_ATEND ;
         ;
         ,CAST( '' as D ) as data_Vencimento ;
         ,$0 as valor_documento ;
         ;
FROM   ASSOCIADO bb ;
JOIN   CONTRATO aa on bb.idContrato == aa.idContrato ;
LEFT OUTER JOIN   EMPRESA ee on bb.idEmpresa == ee.idEmpresa ;
WHERE     aa.idFilial='01' AND ;
          aa.situacao='ATIVO' AND ;
          bb.situacao='ATIVO' AND ;
          aa.tipo_contrato<>'ASSOC' ;
GROUP BY  1,2,3,4 ;
ORDER  BY 1,2,3,4 ;
INTO CURSOR CLVY 




SELECT ;
       aa.idcontrato,;
       aa.tipo_contrato,;
       CAST(0 as integer) idEmpresa,;
       SPACE(14) as cnpj,;
       SPACE(50) as NomeEmpresa,;
       ;
       $0 VLR_EMPRESA,;
       ;
       0000 as QTD_VIDAS,;
       ;
       SUM( ( ( select COUNT(xx.id) ;
           FROM   atendimento xx ;
           WHERE  xx.ctrnumero == aa.idContrato  ;
             AND  xx.tm_chama BETWEEN dRefINI AND dRefFIM ;
             AND  xx.pacCodigo = aa.codigo ;
              AND xx.situacao  == 2 ;                 && ENCERRADO
              AND xx.liberacao == 2 ;                 && LIBERADO  
              AND EMPTY(xx.idcancelamento) ) ;        && NAO ESTA CANCELADO
         + ;
         ( select COUNT(yy.id) ;
           FROM   hstAtend yy ;
           WHERE  yy.ctrnumero == aa.idContrato  ;
              AND yy.tm_chama BETWEEN dRefINI AND dRefFIM ;
              AND yy.pacCodigo = aa.codigo ;
              AND yy.situacao  == 2 ;          
              AND yy.liberacao == 2 ;          
              AND EMPTY(yy.idcancelamento) ) ) ) AS QTD_ATEND ;
         ;
         ,CAST( '' as D ) as data_Vencimento ;
         ,$0 as valor_documento ;
         ;
FROM   CONTRATO aa ;
WHERE     aa.idFilial='01' AND ;
          aa.situacao='ATIVO' AND ;
          aa.tipo_contrato='AREA' ;
GROUP BY  1,2,3,4 ;
ORDER  BY 1,2,3,4 ;
INTO CURSOR CLVZ

*--------
SELECT * FROM CLVX UNION ALL SELECT * FROM CLVY UNION ALL SELECT * FROM CLVZ INTO CURSOR CLV1 READWRITE 
*--------



SELECT CLV1
GO TOP 
SCAN ALL
   ?? [.]
   nIdC = CLV1.idContrato
   SELECT TOP  1 ;
                aa.data_vencimento ;
               ,aa.valor_documento  ;
   FROM        ARECEBER aa ;
   WHERE       aa.idContrato=nIdC AND aa.origem='FAT' ;
   ORDER BY    aa.data_vencimento DESC ;
   INTO CURSOR TMP
   
   IF _TALLY > 0
      SELECT CLV1
      replace data_vencimento WITH TMP.data_vencimento
      replace valor_documento WITH TMP.valor_documento
   ENDIF 
   SELECT CLV1
ENDSCAN 





  
SET ENGINEBEHAVIOR 70

SELECT ;
                   cc.idcontrato    ,;
                   aa.idfilial      ,;
                   cc.tipo_contrato  ,;
                   aa.nome_responsavel  ,;
                   cc.NomeEmpresa,;
                   NVL(ta.agr_nome,SPACE(40)) as agrup,;
                   NVL(ee.endereco     ,aa.endereco   ) as endereco    ,;
                   NVL(ee.complemento  ,aa.complemento) as complemento ,;
                   NVL(ee.bairro       ,aa.bairro     ) as bairro      ,;
                   NVL(ee.cidade       ,aa.cidade     ) as cidade      ,;
                   NVL(ee.uf           ,aa.uf         ) as uf          ,; 
                   NVL(ee.cep          ,aa.cep        ) as cep         ,;
                   NVL(ee.fone1        ,aa.fone       ) as fone1       ,;
                   NVL(ee.fone2        ,aa.fax        ) as fone2       ,;
                   cc.cnpj  ,;
                   SUM(cc.vlr_Empresa)  ,;
                   aa.vendedor  ,;
                   cc.qtd_vidas  ,;
                   aa.valor as VLR_CONTRATO ,;
                   NVL(ee.database,aa.database) as database  ,;
                   NVL(ee.ativacao,aa.ativacao) as ativacao  ,;
                   aa.dia_vencimento  ,;
                   aa.forma_pagamento ,;
                   cc.qtd_atend  as ATEND_ULT_12m;
                   ;
                   ,data_Vencimento as FAT_Ultimo ;
                   ,valor_documento as FAT_Valor  ;
                   ;
FROM              CLV1 cc ;
JOIN              CONTRATO aa on cc.idContrato==aa.idContrato ;
LEFT OUTER JOIN   EMPRESA  ee on cc.idEmpresa ==ee.idEmpresa ;
LEFT OUTER JOIN   TIPOAGRUP ta ON aa.agrupamento == ta.agr_id ;
WHERE             aa.idFilial='01' ;
              AND aa.situacao='ATIVO'  ;
              AND LEFT(cc.tipo_contrato,3) IN ('COL', 'ASS', 'ARE' ) ;
GROUP  BY      cc.idContrato, cc.idEmpresa  ;
ORDER  BY         aa.tipo_contrato, ee.bairro  














*!*   SELECT ;
*!*          aa.idcontrato,;
*!*          aa.idfilial ,;
*!*          aa.tipo_contrato  ,;
*!*          aa.nome_responsavel  ,;
*!*          aa.endereco  ,;
*!*          aa.complemento  ,;
*!*          aa.bairro  ,;
*!*          aa.cidade  ,;
*!*          aa.uf  ,; 
*!*          aa.cep  ,;
*!*          aa.fone  ,;
*!*          aa.fax  ,;
*!*          aa.cnpj  ,;
*!*          aa.valor  ,;
*!*          aa.vendedor  ,;
*!*          aa.nrovidas  ,;
*!*          aa.datavigor  ,;
*!*          aa.database  ,;
*!*          aa.ativacao  ,;
*!*          aa.data_cadastro ,;
*!*          aa.dia_vencimento  ,;
*!*          aa.forma_pagamento ,;
*!*          ;
*!*          ( ( select COUNT(xx.id) ;
*!*              FROM   atendimento xx ;
*!*              WHERE  xx.ctrnumero == aa.idContrato  ;
*!*                 AND xx.situacao  == 2 ;                 && ENCERRADO
*!*                 AND xx.liberacao == 2 ;                 && LIBERADO  
*!*                 AND EMPTY(xx.idcancelamento) ) ;        && NAO ESTA CANCELADO
*!*            + ;
*!*            ( select COUNT(yy.id) ;
*!*              FROM   hstAtend yy ;
*!*              WHERE  yy.ctrnumero == aa.idContrato  ;
*!*                 AND yy.situacao  == 2 ;          
*!*                 AND yy.liberacao == 2 ;          
*!*                 AND EMPTY(yy.idcancelamento) ) ) QTD_ATEND ;
*!*          ;
*!*   FROM   CONTRATO aa ;
*!*   WHERE  aa.idFilial='01' AND ;
*!*          aa.situacao='ATIVO' AND ;
*!*          aa.tipo_contrato='AREA' ;
*!*   ORDER  BY aa.tipo_contrato, aa.bairro 
