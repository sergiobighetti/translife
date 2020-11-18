CLEAR

Clos Data All
Close Tables All

Use ? In 0 ALIAS CTODOS
Use c:\desenv\win\vfp9\sca_new\BSPSQ_CTODOS In 0 Exclusive

Select BSPSQ_CTODOS
IF MESSAGEBOX( 'Limpar o arquivo BSPSQ_CTODOS?',32+4+256, 'Atenção' ) = 6
   ZAP
ENDIF

Select CTODOS

Scan All


  IF RECNO() % 5000 = 0
     ?
     ? RECNO()
     ?? '/'
     ?? RECCOUNT()
     ?
  ELSE
     ?? [.]
  ENDIF 

  IF NOT tipo $ '1,2'
     LOOP
  ENDIF
  

   Select BSPSQ_CTODOS
   Append Blank

   Replace CHV_FILIAL With '01'
   Replace CHV_TIPO   With 'CL'
   Replace CHV_NUMERO With '080046'
   Replace CHV_CLASS  With 'CT'
   Replace FANTASIA   With Strtran( Alltrim( Upper( SemAcento(CTODOS.Nome))), '  ', ' ')
   Replace TIPO_CONTR With ''
   Replace SITUACAO   With 'ATIVO'
   Replace Database   With {^2008-01-01}
   Replace Nome       With Strtran( Alltrim( Upper( SemAcento(CTODOS.Nome))), '  ', ' ')
   Replace ENDERECO   With Strtran( Alltrim( Upper( SemAcento(CTODOS.ENDERECO))), '  ', ' ')
   Replace COMPLEMENT With Strtran( Alltrim( Upper( SemAcento(CTODOS.Comple))), '  ', ' ')
   Replace BAIRRO     With Strtran( Alltrim( Upper( SemAcento(CTODOS.BAIRRO))), '  ', ' ')
   Replace CEP        With CTODOS.CEP
   Replace CIDADE     With Strtran( Alltrim( Upper( SemAcento(CTODOS.CIDADE))), '  ', ' ')
   Replace UF         With CTODOS.ESTADO
   Replace DATA_NASCI With V_DATA( CTODOS.DT_NASCIME )
   Replace SEXO       With CTODOS.SEXO
   Replace CPF        With CTODOS.CPF
   Replace RG         With CTODOS.RG
   Replace CODIGO_ANT With ""
   Replace CODORIGEM  With Alltrim(Iif( CTODOS.TIPO='1',CTODOS.CODIGOTIT, CTODOS.CODIGODEP ))
   Replace ATENDIMENT With .T.
   Replace FICHA      With ctodos.PG
   Replace CPD        With TRANSFORM(CTODOS.tipo)
   Replace INICIAIS   With ""
   Replace IDCONTRATO With 66725
   Replace IDASSOC    With 0
   
   Select BSPSQ_CTODOS

ENDSCAN


 
FUNCTION V_DATA( cData )
LOCAL dRet
dRet = {}

IF !EMPTY(cData)
   TRY 
      dRet = Evaluate( '{^'+Transform(cData,'@R 9999-99-99')+'}')
   CATCH
      dRet = {}
   ENDTRY
ENDIF

RETURN dRet


