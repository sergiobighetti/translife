CD \\dcrpo\bdmdc$
CLOSE DATABASES ALL
TRY 
   USE CONTRATO_LANCAMENTO EXCLUSIVE
   IF FSIZE( 'ORIGEM' ) = 0
      ALTER TABLE CONTRATO_LANCAMENTO ADD COLUMN origem c(10)
   ENDIF 
CATCH
    MESSAGEBOX( 'N�o foi possivel abrir com exclusividade o arquivo', 16, 'Aten��o' )
ENDTRY
CLOSE DATABASES all
