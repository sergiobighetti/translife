CLOSE DATABASES all
CLOSE TABLES all

CLEAR

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
     DATABASE         C( 8) ) 
 
cArq = GETFILE()


IF !EMPTY(cArq)
   CREATE CURSOR LV_TXT ( linha1 C(240),linha2 C(240) )
   SELECT LV_TXT
   APPEND FROM (cArq) SDF


   SCAN all
   
      cLin = linha1+linha2
      
      cCodigo = subs( cLin, 001, 018)
      cnome   = subs( cLin, 019, 058)
      ccpf    = subs( cLin, 059, 072)
      cend    = subs( cLin, 073, 132)
      cnro    = subs( cLin, 133, 138)
      ccomple = subs( cLin, 139, 178)
      ccid    = subs( cLin, 179, 238)
      cbairro = subs( cLin, 239, 278)
      ccep    = LEFT( subs( cLin, 279, 286 ),8 )
      cpais   = subs( cLin, 287, 292 )
      cfone1  = ALLTRIM(LEFT(subs( cLin, 293, 308 ),16))
      cfone2  = subs( cLin, 309, 337 )

      SELECT ORIGEM 
      APPEND BLANK

      replace TIPO             WITH '1'    
      replace NOME             WITH cnome  
      replace ENDERECO         WITH ALLTRIM(cend)+', '+TRANSFORM(VAL(cnro))   
      replace COMPLE           WITH ccomple 
      replace BAIRRO           WITH cbairro
      replace CEP              WITH ccep    
      replace CIDADE           WITH ccid
      replace ESTADO           WITH 'SP'
      replace FONE_RES         WITH cfone1
      replace FONE_COM         WITH cfone2
      replace CPF              WITH ccpf
      replace CODIGOTIT        WITH cCodigo
      replace ATEND            WITH 1
      replace ACAO             WITH 1
      SELECT LV_TXT

      
   ENDSCAN 

ENDIF 
