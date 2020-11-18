LPARAMETERS nKey, cAlsRTN
LOCAL lFechaAREA, cWheTIT, cWheDEP

IF TYPE( 'cAlsRTN' ) = 'C'
   lFechaArea = .f.
ELSE
   cAlsRTN = 'CLV_RST'
   lFechaArea = .t.
ENDIF   


cWheTIT = 'SUBS(t.codigo,11,2)="00"'
cWheDEP = 'SUBS(t.codigo,11,2)#"00"'

SELECT      idPlano as Cod,;
            p.descricao,;
            ;
            SUM( IIF( &cWheTIT AND t.situacao='ATIVO', 00001, 00000 ) ) as TIT_A_QTD,;
            SUM( IIF( &cWheTIT AND t.situacao='ATIVO', a.valor,  $0 ) ) as TIT_A_VLR,;
            ;
            SUM( IIF( &cWheDEP AND t.situacao='ATIVO', 00001, 00000 ) ) as DEP_A_QTD,;
            SUM( IIF( &cWheDEP AND t.situacao='ATIVO', a.valor,  $0 ) ) as DEP_A_VLR,;
            ;
            SUM( IIF( &cWheTIT AND t.situacao#'ATIVO', 00001, 00000 ) ) as TIT_C_QTD,;
            SUM( IIF( &cWheTIT AND t.situacao#'ATIVO', a.valor,  $0 ) ) as TIT_C_VLR,;
            ;
            SUM( IIF( &cWheTIT AND t.situacao='ATIVO', 00001, 00000 ) ) as DEP_C_QTD,;
            SUM( IIF( &cWheDEP AND t.situacao='ATIVO', a.valor,  $0 ) ) as DEP_C_VLR ;
            ;
FROM        ASSOCIADO_PLANO a ;
INNER JOIN  ASSOCIADO t ON a.idAssoc == t.idAssoc ;
INNER JOIN  PLANOS  p ON a.idPlano == p.plano ;
WHERE       t.idContrato == nKey AND t.situacao = 'ATIVO' AND t.atendimento=.t.;
GROUP BY    1 ;
ORDER BY    1 ;
INTO CURSOR CLV_JTA
        
SELECT      Cod, Descricao,;
            TIT_A_QTD        as ATIVO_TIT_QTD,;
            TIT_A_VLR        as ATIVO_TIT_VLR,;
            ;
            DEP_A_QTD        as ATIVO_DEP_QTD,;
            DEP_A_VLR        as ATIVO_DEP_VLR,;
            ;
            ( TIT_A_QTD+DEP_A_QTD ) as ATIVO_TOTAL_QTD,;
            ( TIT_A_VLR+DEP_A_VLR ) as ATIVO_TOTAL_VLR,;
            ;
            TIT_C_QTD        as CANC__TIT_QTD,;
            TIT_C_VLR        as CANC__TIT_VLR,;
            ;
            DEP_C_QTD        as CANC__DEP_QTD,;
            DEP_C_VLR        as CANC_DEP_VLR,;
            ;
            ( TIT_C_QTD+DEP_C_QTD ) as CANC__TOTAL_QTD, ;
            ( TIT_C_VLR+DEP_C_VLR ) as CANC__TOTAL_VLR, ;
            ;
            nKey as Contrato ;
            ;
FROM        CLV_JTA ;
ORDER BY    1 ;
GROUP BY    1 ;
INTO CURSOR (cAlsRTN)

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

SELECT          a.CODIGO, ;
                a.NOME, ;
                a.SITUACAO, ;
                a.dataBase,;
                a.dataVigor,;
                IIF( a.atendimento=.t., 'Sim', 'Nao' ) as Atend, ;
                pl.IdPlano as Produto,;
                pl.Valor   as Valor ;
FROM            ASSOCIADO a ;
LEFT OUTER JOIN ASSOCIADO_PLANO pl ON a.idAssoc == pl.idAssoc;
WHERE           a.idContrato == nCtr AND pl.idPlano == nProd AND a.situacao='ATIVO' ;
GROUP BY        a.idAssoc ;
ORDER BY        1 ;
INTO CURSOR     CLV_RST2

DO FORM PESQUISA WITH 'SELECT * FROM CLV_RST2',,,'Associados do contrato '+ TRANSFORM(nCtr)+' com o produto = '+TRANSFORM(nProd)

USE IN ( SELECT( 'CLV_RST2' ) )

RETURN

*************************************************************************
PROCEDURE estat_Valor
LPARAMETERS nKey, cAlsRtn
*************************************************************************
LOCAL lFechaAREA

IF TYPE( 'cAlsRTN' ) = 'C'
   lFechaArea = .f.
ELSE
   cAlsRTN = 'CLV_RST'
   lFechaArea = .t.
ENDIF   

SELECT       T.idAssoc AS Chave, ;
             T.situacao, ;
             T.atendimento, ;
             IIF( SUBSTR( T.codigo, 11, 2 ) = '00', 'TIT', 'DEP' ) TIPO,;
             SUM( pl.valor ) AS valor ;
FROM         ASSOCIADO T ;
INNER JOIN   ASSOCIADO_PLANO pl ON T.idAssoc == pl.idAssoc ;
WHERE        T.idContrato == nKey ;
GROUP BY     T.idAssoc ;
INTO CURSOR  CTIT ;

SELECT       Tipo,;
             T.situacao,;
             T.valor      AS VlrInd,;
             COUNT(*)     AS Quantidade,;
             SUM(T.valor) AS valor ;
FROM         CTIT T ;
GROUP BY     2, 3 ;
INTO CURSOR  (cAlsRtn) READWRITE

USE IN ( SELECT( 'CTIT' ) )

IF lFechaArea 
   USE IN ( SELECT( cAlsRtn ) )
ENDIF

RETURN