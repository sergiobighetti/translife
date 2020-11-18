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


cArqXLS   = GETFILE('XLS','PLANILHA','Abrir',0,'Informa a planilha')

IF EMPTY(cArqXLS) OR EMPTY(cArqXLS)
   RETURN
ENDIF

oXls = Createobject( 'Excel.Application' )
oXls.Workbooks.Open( cArqXLS )
oXls.DisplayAlerts = .F.
oXls.Visible = .F.

For i=2 To 3000

   If Empty(oXls.Cells(i,1).Text)
      exit
   ENDIF

      cCodT =  TRANSFORM(oXls.Cells(i,1).Value)

   SELECT ORIGEM
   APPEND BLANK
   replace TIPO       WITH '1'
   replace NOME       WITH ALLTRIM(oXls.Cells(i,2).Text)
   replace ENDERECO   WITH ''
   replace COMPLE     WITH ''
   replace BAIRRO     WITH ''
   replace CEP        WITH ''
   replace CIDADE     WITH ''
   replace ESTADO     WITH ''
   replace FONE_RES   WITH ''
   replace FONE_COM   WITH ''
   replace PERTO_DE   WITH ''
   replace ENTRE_RUA  WITH ''
   replace DT_NASCIME WITH ''
   replace SEXO       WITH ''
   replace CIVIL      WITH ''
   replace CPF        WITH ''
   replace RG         WITH ''
   replace CODIGOTIT  WITH cCodT
   replace CODIGODEP  WITH ''
   replace ATEND      WITH 1
   replace ACAO       WITH 1
   replace DATABASE   WITH DTOS(DATE())
   replace APH        WITH ''
   
   ?? ','+Transform(i)

Endfor

oXls.Quit
oXls = Null
