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
 
For i=2 To 650000

   If Empty(oXls.Cells(i,1).Text)
      Exit
   ENDIF

   dNasc = ALLTRIM(oXls.Cells(i,14).Text)
   TRY 
      dNasc = DTOS( ctod( dNasc ) )
   CATCH
      dNasc = ALLTRIM(oXls.Cells(i,14).Text)
   FINALLY

   ENDTRY


   SELECT ORIGEM
   APPEND BLANK
   replace TIPO       WITH ALLTRIM(oXls.Cells(i,2).Text)
   replace NOME       WITH SEMACENTO( ALLTRIM(oXls.Cells(i,3).Text), .T. )
   replace ENDERECO   WITH SEMACENTO( ALLTRIM(oXls.Cells(i,4).Text), .T. )
   replace COMPLE     WITH SEMACENTO( ALLTRIM(oXls.Cells(i,5).Text), .T. )
   replace BAIRRO     WITH SEMACENTO( ALLTRIM(oXls.Cells(i,6).Text), .T. )
   replace CEP        WITH ALLTRIM(oXls.Cells(i,7).Text)
   replace CIDADE     WITH SEMACENTO( ALLTRIM(oXls.Cells(i,8).Text), .T. )
   replace ESTADO     WITH ALLTRIM(oXls.Cells(i,9).Text)
   replace FONE_RES   WITH ALLTRIM(oXls.Cells(i,10).Text)
   replace FONE_COM   WITH ALLTRIM(oXls.Cells(i,11).Text)
   replace PERTO_DE   WITH ALLTRIM(oXls.Cells(i,12).Text)
   replace ENTRE_RUA  WITH ALLTRIM(oXls.Cells(i,13).Text)
   replace DT_NASCIME WITH dNasc 
   replace SEXO       WITH ALLTRIM(oXls.Cells(i,15).Text)
   replace CIVIL      WITH ALLTRIM(oXls.Cells(i,16).Text)
   replace CPF        WITH CHRTRAN( ALLTRIM(oXls.Cells(i,17).Text), CHR(9), '' )
   replace RG         WITH CHRTRAN( ALLTRIM(oXls.Cells(i,18).Text), CHR(9), '' )
   replace CODIGOTIT  WITH CHRTRAN( ALLTRIM(oXls.Cells(i,19).Text), CHR(9), '' )
   replace CODIGODEP  WITH CHRTRAN( ALLTRIM(oXls.Cells(i,20).Text), CHR(9), '' )
   replace ATEND      WITH IIF( val(oXls.Cells(i,21).Text) = 0, 1, val(oXls.Cells(i,21).Text) )
   replace ACAO       WITH IIF( VAL(oXls.Cells(i,22).Text) = 0, 1, VAL(oXls.Cells(i,22).Text) )
   replace DATABASE   WITH ALLTRIM(oXls.Cells(i,23).Text)
   replace APH        WITH ALLTRIM(oXls.Cells(i,24).Text)
   
   @ 10,10 say  'linha... ' + Transform(i)

Endfor

oXls.Quit
oXls = Null
