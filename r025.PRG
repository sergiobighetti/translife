LOCAL cTmp1, cTmp2, cWhe, cCondFil, cEng, cTmp

cTmp = SYS(2015)

THISFORM.TituloComplementar = 'Periodo de '+;
   DTOC( THISFORM.txtVcINI.VALUE ) +' até '+;
   DTOC( THISFORM.txtVcFIM.VALUE )


cCondFil = THISFORM.Ctnfilial1.ccondicao

cWhe = STRTRAN( cCondFil, '<??>.', 'APAGAR.' )

cWhe = cWhe + ' AND BANCO.ativo == .t. AND APAGAR.data_Vencimento BETWEEN {^'+ ;
       TRAN( DTOS(THISFORM.txtVcINI.VALUE), [@R 9999-99-99] )+'} AND {^'+;
       TRAN( DTOS(THISFORM.txtVcFIM.VALUE), [@R 9999-99-99] )+'}'

SELECT      APAGAR.idFilial         AS FILIAL,;
            'DESPESA'               AS Tipo,;
            APAGAR.idCta            AS CodConta,;
            PC_CONTA.descricao      AS DescrConta,;
            SUM( APAGAR.Valor_Documento * $1 ) AS Vlr_A,;
            $0                            AS Vlr_P,;
            PC_GRUPO.idGrupo   AS CodGrupo,;
            PC_GRUPO.descricao AS DescrGrupo ;
FROM        APAGAR ;
LEFT OUTER JOIN  BANCO ON APAGAR.idFilial == BANCO.idFilial AND APAGAR.codigo_banco == BANCO.agrupa_portador ;
LEFT OUTER JOIN  CONTA PC_CONTA ON APAGAR.idCta  == PC_CONTA.idCta ;
LEFT OUTER JOIN  CONTA PC_GRUPO ON PC_CONTA.idGrupo == PC_GRUPO.idCta ;
WHERE       &cWhe ;
GROUP BY    1,2 ;
ORDER BY    APAGAR.idFilial, PC_GRUPO.idGrupo, APAGAR.idCta ;
INTO CURSOR CDESP_a


cWhe = STRTRAN( cCondFil, '<??>.', 'APAGAR.' )

cWhe = cWhe + ' AND BANCO.ativo == .t. AND APAGAR.data_Baixa BETWEEN {^'+ ;
       TRAN( DTOS(THISFORM.txtVcINI.VALUE), [@R 9999-99-99] )+'} AND {^'+;
       TRAN( DTOS(THISFORM.txtVcFIM.VALUE), [@R 9999-99-99] )+'}'


SELECT      APAGAR.idFilial AS FILIAL,;
            'DESPESA'        AS Tipo,;
            APAGAR.idCta          AS CodConta,;
            PC_CONTA.descricao      AS DescrConta,;
            $0               AS Vlr_A,;
            SUM( APAGAR.Valor_Documento*$1 ) AS Vlr_P,;
            PC_GRUPO.idGrupo   AS CodGrupo,;
            PC_GRUPO.descricao AS DescrGrupo ;
FROM        APAGAR ;
INNER JOIN  BANCO ON APAGAR.idFilial == BANCO.idFilial AND APAGAR.codigo_banco == BANCO.agrupa_portador ;
INNER JOIN  CONTA PC_CONTA ON APAGAR.idCta   == PC_CONTA.idCta ;
INNER JOIN  CONTA PC_GRUPO ON PC_CONTA.idGrupo == PC_GRUPO.idCta ;
WHERE       &cWhe ;
GROUP BY    1,2 ;
ORDER BY    APAGAR.idFilial,PC_GRUPO.idGrupo, APAGAR.idCta ;
INTO CURSOR CDESP_p


cWhe = STRTRAN( cCondFil, '<??>.', 'BANCO.' )

cWhe = cWhe +' AND BANCO.ativo=.t. AND INLIST(EXTRATO.tipo,4,7) AND EXTRATO.valor < $0 AND EXTRATO.data BETWEEN {^'+ ;
       TRAN( DTOS(THISFORM.txtVcINI.VALUE), [@R 9999-99-99] )+'} AND {^'+;
       TRAN( DTOS(THISFORM.txtVcFIM.VALUE), [@R 9999-99-99] )+'}'

SELECT          BANCO.idFilial AS FILIAL,;
                'DESPESA'                   AS Tipo,;
                INT(4)                      AS CodConta,;
                PADR( 'CPMF, TARIFAS, EVENTUAIS', 40 ) AS DescrConta,;
                $0.00                       AS Vlr_A,;
                SUM(ABS(EXTRATO.valor))*$1             AS Vlr_P,;
                INT(1*0)                    AS CodGrupo,;
                PADR( 'Tipo = Saida a Vista', 40 )  AS DescrGrupo ;
FROM            EXTRATO ;
INNER JOIN      BANCO ON EXTRATO.idBanco == BANCO.agrupa_portador ;
WHERE           &cWhe ;
ORDER BY        1, 2, 7, 3 ;
GROUP BY        1, 2, 7, 3 ;
INTO CURSOR     CTIPO4


SELECT * FROM CDESP_a ;
   UNION ALL ;
   SELECT * FROM CDESP_p ;
   UNION ALL ;
   SELECT * FROM CTIPO4 ;
INTO CURSOR CDESP_x

SELECT      FILIAL, Tipo, CodConta, DescrConta, SUM(Vlr_A) AS Vlr_A, SUM( Vlr_P) AS Vlr_P, CodGrupo, DescrGrupo ;
FROM        CDESP_x ;
ORDER BY    FILIAL, Tipo, CodGrupo, CodConta ;
GROUP BY    FILIAL, Tipo, CodGrupo, CodConta ;
INTO CURSOR CDESP

USE IN ( SELECT( 'CDESP_a' ) )
USE IN ( SELECT( 'CDESP_p' ) )
USE IN ( SELECT( 'CDESP_x' ) )
USE IN ( SELECT( 'CTIPO4'  ) )
USE IN ( SELECT( 'CTIPO5'  ) )

cWhe = STRTRAN( cCondFil, '<??>.', 'ARECEBER.' )

cWhe = cWhe + ' AND BANCO.ativo == .t. AND ARECEBER.data_Vencimento BETWEEN {^'+ ;
       TRAN( DTOS(THISFORM.txtVcINI.VALUE), [@R 9999-99-99] )+'} AND {^'+;
       TRAN( DTOS(THISFORM.txtVcFIM.VALUE), [@R 9999-99-99] )+'}'

SELECT          ARECEBER.idFilial FILIAL,;
                'RECEITA'                   AS Tipo,;
                NVL(ARECEBER.codigo_subconta,0)    AS CodConta,;
                NVL(PC_CONTA.descricao,SPACE(40))  AS DescrConta,;
                SUM(ARECEBER.Valor_Documento )    AS Vlr_A,;
                $0.00                       AS Vlr_P,;
                NVL(PC_GRUPO.idGrupo,0)            AS CodGrupo,;
                NVL(PC_GRUPO.descricao,SPACE(40))  AS DescrGrupo ;
FROM            ARECEBER ;
LEFT OUTER JOIN CONTA PC_CONTA ON ARECEBER.codigo_subconta == PC_CONTA.idCta ;
LEFT OUTER JOIN CONTA PC_GRUPO ON PC_CONTA.idGrupo         == PC_GRUPO.idCta ;
INNER JOIN      BANCO ON ARECEBER.idFilial == BANCO.idFilial AND ARECEBER.codigo_banco == BANCO.agrupa_portador ;
WHERE           &cWhe ;
GROUP BY        1,2 ;
ORDER BY        ARECEBER.idFilial, PC_GRUPO.idGrupo, ARECEBER.codigo_subconta ;
INTO CURSOR     CRECE_a

cWhe = STRTRAN( cCondFil, '<??>.', 'ARECEBER.' )

cWhe = cWhe + ' AND BANCO.ativo == .t. AND bxarec.data_CAIXA BETWEEN {^'+ ;
       TRAN( DTOS(THISFORM.txtVcINI.VALUE), [@R 9999-99-99] )+'} AND {^'+;
       TRAN( DTOS(THISFORM.txtVcFIM.VALUE), [@R 9999-99-99] )+'}'


SELECT          ARECEBER.idFilial AS FILIAL,;
                'RECEITA'                   AS Tipo,;
                NVL(ARECEBER.codigo_subconta,0)   AS CodConta,;
                NVL(PC_CONTA.descricao,SPACE(40))  AS DescrConta,;
                $0.00                       AS Vlr_A,;
                SUM(bxarec.VLR_RECEBIDO)*$1      AS Vlr_P,;
                NVL(PC_GRUPO.idGrupo,  0)          AS CodGrupo,;
                NVL(PC_GRUPO.descricao,SPACE(40))  AS DescrGrupo ;
FROM            bxarec a ;
LEFT OUTER JOIN ARECEBER ON bxarec.controle == ARECEBER.controle ;
LEFT OUTER JOIN CONTA PC_CONTA  ON ARECEBER.codigo_subconta == PC_CONTA.idCta ;
LEFT OUTER JOIN CONTA PC_GRUPO  ON PC_CONTA.idGrupo  == PC_GRUPO.idCta ;
INNER JOIN      BANCO ON  ARECEBER.idFilial == BANCO.idFilial AND bxarec.portador == BANCO.agrupa_portador ;
WHERE           &cWhe ;
ORDER BY        1, 2, 7, 3 ;
GROUP BY        1, 2, 7, 3 ;
INTO CURSOR     CRECE_r

cWhe = STRTRAN( cCondFil, '<??>.', 'BANCO.' )

cWhe = cWhe + ' AND BANCO.ativo == .t. AND INLIST(extrato.tipo,2,8) AND !( LEFT(extrato.historico,7)="TRANSF." AND LEFT(extrato.documento,1)="T" ) AND extrato.valor>$0 AND extrato.data BETWEEN {^'+ ;
       TRAN( DTOS(THISFORM.txtVcINI.VALUE), [@R 9999-99-99] )+'} AND {^'+;
       TRAN( DTOS(THISFORM.txtVcFIM.VALUE), [@R 9999-99-99] )+'}'

SELECT          BANCO.idFilial AS FILIAL,;
                'RECEITA'                   AS Tipo,;
                INT(2)                    AS CodConta,;
                PADR( 'OUTROS CREDITOS', 40 ) AS DescrConta,;
                $0.00                       AS Vlr_A,;
                SUM(EXTRATO.valor)*$1             AS Vlr_P,;
                INT(1*0)                    AS CodGrupo,;
                PADR( 'Tipo = Entrada a Vista', 40 )  AS DescrGrupo ;
FROM            EXTRATO ;
INNER JOIN      BANCO bco ON EXTRATO.idBanco == bco.agrupa_portador ;
WHERE           &cWhe ;
ORDER BY        1, 2, 7, 3 ;
GROUP BY        1, 2, 7, 3 ;
INTO CURSOR     CTIPO2

SELECT * FROM CRECE_a ;
   UNION ALL ;
   SELECT * FROM CRECE_r ;
   UNION ALL ;
   SELECT * FROM CTIPO2 ;
INTO CURSOR CRECE_x

SELECT      FILIAL, Tipo, CodConta, DescrConta, SUM(Vlr_A) AS Vlr_A, SUM(Vlr_P) AS Vlr_P, CodGrupo, DescrGrupo ;
FROM        CRECE_x ;
ORDER BY    FILIAL, Tipo, CodGrupo, CodConta ;
GROUP BY    FILIAL, Tipo, CodGrupo, CodConta ;
INTO CURSOR CRECE

USE IN ( SELECT( 'CRECE_a' ) )
USE IN ( SELECT( 'CRECE_r' ) )
USE IN ( SELECT( 'CTIPO2'  ) )
USE IN ( SELECT( 'CTIPO6'  ) )
USE IN ( SELECT( 'CRECE_x' ) )

SELECT * FROM CRECE UNION ALL SELECT * FROM CDESP INTO CURSOR R25
SELECT R25

IF THISFORM.cboTipo.LISTINDEX > 1
   IF THISFORM.cboTipo.LISTINDEX = 2
      SET FILTER TO Tipo = 'RECEITA'
   ELSE
      SET FILTER TO Tipo = 'DESPESA'
   ENDIF
ENDIF

USE IN ( SELECT( 'CRECE' ) )
USE IN ( SELECT( 'CDESP' ) )
gLdrvR025 = ( THISFORM.chk1aCol.VALUE = 1 )

RETURN 'R25'