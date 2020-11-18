LPARAMETERS nKey, cAlsRTN
LOCAL lFechaAREA, cTipoTIT, cTipoDEP

IF TYPE( 'cAlsRTN' ) = 'C'
   lFechaArea = .f.
ELSE
   cAlsRTN = 'CLV_RST'
   lFechaArea = .t.
ENDIF   

cTipoTIT = 'SUBSTR(tt.codigo,11,2) = "00"'
cTipoDEP = 'SUBSTR(tt.codigo,11,2) # "00"'

SELECT      aa.idPlano as Cod,;
            pp.descricao,;
            ;
            SUM( IIF( &cTipoTIT AND tt.situacao='ATIVO', 00001, 00000 ) ) as TIT_A_QTD,;
            SUM( IIF( &cTipoTIT AND tt.situacao='ATIVO', aa.valor,  $0 ) ) as TIT_A_VLR,;
            ;
            SUM( IIF( &cTipoDEP AND tt.situacao='ATIVO', 00001, 00000 ) ) as DEP_A_QTD,;
            SUM( IIF( &cTipoDEP AND tt.situacao='ATIVO', aa.valor,  $0 ) ) as DEP_A_VLR,;
            ;
            SUM( IIF( &cTipoTIT AND tt.situacao#'ATIVO', 00001, 00000 ) ) as TIT_C_QTD,;
            SUM( IIF( &cTipoTIT AND tt.situacao#'ATIVO', aa.valor,  $0 ) ) as TIT_C_VLR,;
            ;
            SUM( IIF( &cTipoDEP AND tt.situacao#'ATIVO', 00001, 00000 ) ) as DEP_C_QTD,;
            SUM( IIF( &cTipoDEP AND tt.situacao#'ATIVO', aa.valor,  $0 ) ) as DEP_C_VLR ;
            ;
FROM        ASSOCIADO_PLANO aa ;
INNER JOIN  ASSOCIADO       tt ON aa.idAssoc == tt.idAssoc ;
INNER JOIN  PLANOS          pp ON aa.idPlano == pp.plano ;
WHERE       tt.idContrato == nKey AND tt.atendimento=.t.;
GROUP BY    1,2 ;
ORDER BY    1,2 ;
INTO CURSOR CLV_JTA
        
        
SELECT      Cod, Descricao,;
            SUM( TIT_A_QTD )       as ATIVO_TIT_QTD,;
            SUM( TIT_A_VLR )       as ATIVO_TIT_VLR,;
            ;
            SUM( DEP_A_QTD )       as ATIVO_DEP_QTD,;
            SUM( DEP_A_VLR )       as ATIVO_DEP_VLR,;
            ;
            SUM( TIT_A_QTD+DEP_A_QTD ) as ATIVO_TOTAL_QTD,;
            SUM( TIT_A_VLR+DEP_A_VLR ) as ATIVO_TOTAL_VLR,;
            ;
            SUM( TIT_C_QTD )       as CANC__TIT_QTD,;
            SUM( TIT_C_VLR )       as CANC__TIT_VLR,;
            ;
            SUM( DEP_C_QTD )       as CANC__DEP_QTD,;
            SUM( DEP_C_VLR )       as CANC_DEP_VLR,;
            ;
            SUM( TIT_C_QTD+DEP_C_QTD ) as CANC__TOTAL_QTD, ;
            SUM( TIT_C_VLR+DEP_C_VLR ) as CANC__TOTAL_VLR, ;
            ;
            nKey as Contrato ;
            ;
FROM        CLV_JTA ;
ORDER BY    1,2 ;
GROUP BY    1,2 ;
INTO CURSOR (cAlsRTN)

USE IN ( SELECT( 'CLV_TIT' ) )
USE IN ( SELECT( 'CLV_JTA' ) )

IF lFechaArea 

   DO FORM PESQUISA WITH 'SELECT * FROM CLV_RST',,'FI_BNF_DO_PROD(contrato,Cod)','Produtos do Contrato',,.t.
ENDIF

IF lFechaArea 
   USE IN ( SELECT( 'CLV_RST' ) )
ENDIF

RETURN


****************************************************************
FUNCTION FI_BNF_DO_PROD( nCtr, nProd )
* Mostra os associados do contrato <nCtr> com o produto <nProd>
****************************************************************

SELECT          aa.codigo, ;
                IIF(SUBSTR(aa.codigo,11,2)="00", 'TIT', 'DEP' ) as Tipo,;
                aa.NOME, ;
                aa.SITUACAO, ;
                aa.dataBase,;
                aa.dataVigor,;
                IIF( aa.atendimento=.t., 'Sim', 'Nao' ) as Atend, ;
                pl.IdPlano as Produto,;
                pl.Valor   as Valor ;
FROM            ASSOCIADO aa ;
LEFT OUTER JOIN ASSOCIADO_PLANO pl ON aa.idAssoc == pl.idAssoc ;
WHERE           aa.idContrato == nCtr AND pl.idPlano == nProd AND aa.situacao='ATIVO' ;
GROUP BY        aa.idAssoc ;
ORDER BY        2 ;
INTO CURSOR     CLV_RST2

DO FORM PESQUISA WITH 'SELECT * FROM CLV_RST2',,,'Associados do contrato '+ TRANSFORM(nCtr)+' com o produto = '+TRANSFORM(nProd)

USE IN ( SELECT( 'CLV_RST2' ) )

RETURN

