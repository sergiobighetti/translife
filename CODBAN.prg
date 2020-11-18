Close Databases All
Close Tables All
Clear

Create Cursor ORIGEM ;
   ( TIPO       C( 1),;
   NOME       C(40),;
   ENDERECO   C(40),;
   COMPLE     C(40),;
   BAIRRO     C(20),;
   CEP        C(10),;
   CIDADE     C(20),;
   ESTADO     C( 2),;
   FONE_RES   C(20),;
   FONE_COM   C(20),;
   PERTO_DE   C(40),;
   ENTRE_RUA  C(40),;
   DT_NASCIME C( 8),;
   SEXO       C( 9),;
   CIVIL      C(11),;
   CPF        C(14),;
   RG         C(18),;
   CODIGOTIT  C(20),;
   CODIGODEP  C(20),;
   ATEND      N( 1),;
   ACAO       N( 1),;
   DATABASE   C( 8),;
   APH        C(90),;
   VALOR      Y,;
   idTIT      I,;
   idDEP      I )


cArqXLS   = GETFILE('DAT','ARQUIVO','Abrir',0,'Informa a planilha')

IF EMPTY(cArqXLS) OR EMPTY(cArqXLS)
   RETURN
ENDIF

CREATE CURSOR LVDAT ( lin1 C(200), lin2 C(200) )
APPEND FROM (cArqXLS) SDF

* 70719 - financial service 0,50
SELECT LVDAT
SCAN all

   linha = lin1+lin2
 
*!*   NOMENCLATURAS E ESPECIFICACOES
*!*   Cod_Cli  - Codigo do Cliente 6 digitos
*!*   DataCa - Data do Cadastro (membro desde) 6 digitos, mmyyyy
*!*   VlSeg - Valor do Seguro 5 digitos - no exemplo 3,90
*!*   Sit - Situacao do Cadastro 1 - Ativo | 2 - Inativo
*!*   Nome Segurado - 40 digitos
*!*   Cpf - 14 digitos
*!*   Endereco - 60 digitos
*!*   Numero - 6 digitos
*!*   Complemento - 40 digitos
*!*   Cidade - 60 digitos
*!*   Bairro - 40 digitos
*!*   Cep - 8 digitos
*!*   Pais - fixo em BRASIL
*!*   Telefone - 16 digitos
*!*   Sexo - 1 - MASC | 2 - FEM
*!*   DtNasc - Data de Nascimento, 8 digitos, yyyymmdd
*!*   RG - 20 digitos
*!*   EstCivil - 1 - CASADO | 2 -SOLTEIRO | 3 - DIVORCIADO | 4 - VIUVO | 5 - OUTROS
*!*   Profissao - 60 digitos

 
   cCod = SUBSTR(linha, 1,6)
   cCpf = SUBSTR(linha,59,14)
   cTipo = '1'

   SELECT ORIGEM
   APPEND BLANK
   replace TIPO       WITH cTipo
   
   cEnd = ALLTRIM(SUBSTR(linha,73,60))
   IF INT(VAL(SUBSTR(linha,136,6))) <> 0
      cEnd = cEnd +', '+TRANSFORM(INT(VAL(SUBSTR(linha,136,6))))
   ENDIF    
   
   replace NOME       WITH ALLTRIM( SUBSTR(linha,19,40) )
   replace ENDERECO   WITH cEnd
   replace COMPLE     WITH ALLTRIM( SUBSTR(linha,139,40) )
   replace BAIRRO     WITH ALLTRIM( SUBSTR(linha,239,40) )
   replace CEP        WITH SUBSTR(linha,279,8)
   replace CIDADE     WITH ALLTRIM( SUBSTR(linha,179,60) )
   replace ESTADO     WITH ''
   replace FONE_RES   WITH ALLTRIM( SUBSTR(linha,293,16) )
   replace FONE_COM   WITH ''
   replace PERTO_DE   WITH ''
   replace ENTRE_RUA  WITH ''
   replace DT_NASCIME WITH SUBSTR(linha,310,8)
   replace SEXO       WITH IIF(SUBSTR(linha,309,1)='M','MASCULINO','FEMININO')
   replace CIVIL      WITH IIF(SUBSTR(linha,338,1)='1', 'CASADO',;
                           IIF(SUBSTR(linha,338,1)='2', 'SOLTEIRO',;
                           IIF(SUBSTR(linha,338,1)='3', 'DIVORCIADO',;
                           IIF(SUBSTR(linha,338,1)='4', 'VIUVO','OUTROS'))))
   
   
   replace CPF        WITH SUBSTR(linha,59,14)
   replace RG         WITH SUBSTR(linha,318,20)
   replace CODIGOTIT  WITH cCod
   replace CODIGODEP  WITH ''
   replace ATEND      WITH 1
   replace ACAO       WITH 1
   replace DATABASE   WITH '20120301'
   replace APH        WITH ''
   
   REPLACE endereco WITH STRTRAN( endereco, '  ', ' ' )
   REPLACE BAIRRO   WITH STRTRAN( BAIRRO, '  ', ' ' )
   REPLACE nome   WITH STRTRAN( nome   , '  ', ' ' )
   ?? ','+TRANSFORM(RECNO())


   SELECT LVDAT
ENDSCAN 

   
