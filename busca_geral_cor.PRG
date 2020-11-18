*!*   TRY 

If BSPSQ.situacao='ATIVO'
   RETURN 16777215
Else
   If BSPSQ.situacao='CANCELADO' And BSPSQ.dtcanc <= Date()
      RETURN 14803455
   Else
      RETURN 16777215
   Endif
ENDIF

*!*   CATCH
*!*   ENDTRY
