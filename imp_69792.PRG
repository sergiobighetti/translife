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
 
For i=4 To 650000

   If Empty(oXls.Cells(i,1).Text)
      Exit
   ENDIF
   
   cCod = UPPER(ALLTRIM(oXls.Cells(i,2).Text))
   cCpf =  UPPER(ALLTRIM(oXls.Cells(i,4).Text))

      cCodTIT = CHRTRAN(cCod, ' DEP', '' )
      cCodTIT = CHRTRAN(cCod, ' ', '' )
      cCodDEP = ''
      cTipo = '1'

   SELECT ORIGEM
   APPEND BLANK
   replace TIPO       WITH cTipo
   
   replace NOME       WITH UPPER(semAcento(ALLTRIM(oXls.Cells(i,1).Text)))
   replace ENDERECO   WITH UPPER(semAcento(ALLTRIM(oXls.Cells(i,5).Text)))
   replace COMPLE     WITH UPPER(semAcento(ALLTRIM(oXls.Cells(i,7).Text)))
   replace BAIRRO     WITH UPPER(semAcento(ALLTRIM(oXls.Cells(i,8).Text)))
   replace CEP        WITH ALLTRIM(oXls.Cells(i,9).Text)
   replace CIDADE     WITH UPPER(semAcento(ALLTRIM(oXls.Cells(i,10).Text)))
   replace ESTADO     WITH ALLTRIM(oXls.Cells(i,11).Text)
   replace FONE_RES   WITH ''
   replace FONE_COM   WITH ''
   replace PERTO_DE   WITH ''
   replace ENTRE_RUA  WITH ''
   TRY 
   replace DT_NASCIME WITH dtos(oXls.Cells(i,3).Value)
   CATCH
   ENDTRY
   replace SEXO       WITH ''
   replace CIVIL      WITH ''
   replace CPF        WITH ALLTRIM(oXls.Cells(i,4).Text)
   replace RG         WITH ''
   replace CODIGOTIT  WITH cCodTIT
   replace CODIGODEP  WITH cCodDEP
   replace ATEND      WITH 1
   replace ACAO       WITH 1
   replace DATABASE   WITH '20110301'
   replace APH        WITH ''
   
   REPLACE endereco WITH STRTRAN( endereco, '  ', ' ' )
   REPLACE BAIRRO   WITH STRTRAN( BAIRRO, '  ', ' ' )
   ?? ','+Transform(i)

Endfor

oXls.Quit
oXls = Null
