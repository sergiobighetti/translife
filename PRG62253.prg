Create Cursor ORIGEM ;
   ( TIPO             C( 1),;
     NOME             C(40),;
     ENDERECO         C(40),;
     COMPLE           C(40),;
     BAIRRO           C(20),;
     CEP              C(10),;
     CIDADE           C(20),;
     ESTADO           C( 2),;
     FONE_RES         C(20),;
     FONE_COM         C(20),;
     PERTO_DE         C(40),;
     ENTRE_RUA        C(40),;
     DT_NASCIME       C( 8),;
     SEXO             C( 9),;
     CIVIL            C(11),;
     CPF              C(14),;
     RG               C(18),;
     CODIGOTIT        C(20),;
     CODIGODEP        C(20),;
     ATEND            N( 1),;
     ACAO             N( 1),;
     DATABASE         C( 8),;
     pg               c(2) )
     

CREATE CURSOR LVBASE ( linha c(230) )
APPEND FROM ? SDF

SELECT ;
      '1' as TIPO ;
     ,UPPER(ALLTRIM(SUBSTR( linha,18, 40 ))) as NOME ;
     ,SPACE(40) as ENDERECO         ;
     ,SPACE(40) as COMPLE           ;
     ,SPACE(20) as BAIRRO           ;
     ,SPACE(10) as CEP              ;
     ,SPACE(20) as CIDADE           ;
     ,SPACE(02) as ESTADO           ;
     ,SPACE(20) as FONE_RES         ;
     ,SPACE(20) as FONE_COM         ;
     ,SPACE(40) as PERTO_DE         ;
     ,SPACE(40) as ENTRE_RUA        ;
     ,DTOS(CTOD(SUBSTR( linha,64, 10 ))) as DT_NASCIME;
     ,SPACE(09) as SEXO             ;
     ,SPACE(11) as CIVIL            ;
     ,PADR('20110802',14) as CPF              ;
     ,SPACE(18) as RG               ;
     ,PADR(SUBSTR( linha,01, 17 ), 20) as CODIGOTIT        ;
     ,SPACE(20) as CODIGODEP        ;
     ,1 as ATEND            ;
     ,1 as ACAO             ;
     ,'20040801' as DATABASE        ;
FROM LVBASE ;
INTO TABLE C:\IMP62253


SCAN all
   cCod = ALLTRIM(SUBSTR( linha,01, 17 ))
   cNom = UPPER(ALLTRIM(SUBSTR( linha,18, 46 )))
   cNas = ALLTRIM( SUBSTR( linha,64, 10 ))
   
   dNas = CTOD(cNas)
ENDSCAN 