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
 
cArq = GETFILE()

IF !EMPTY(cArq)
   APPEND FROM (cArq) SDF
   cSav = PUTFILE('','','DBF')
   
   IF !EMPTY( cSav)
      COPY TO (cSav) 
   ENDIF
ENDIF 
