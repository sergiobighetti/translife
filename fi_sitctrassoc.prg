FUNCTION fi_SitCtrAssoc( nIdCtr, nidAssoc, cTipoRet )
LOCAL cSitCtr, cSitAssoc, cRet, nPos

cSitCtr   = ''
cSitAssoc = ''
cRet      = ''

cTipoRet = IIF(TYPE('cTipoRet')='C', cTipoRet, '' )

IF USED( 'CONTRATO' )
   nPos = RECNO('CONTRATO')
   IF SEEK( nIdCtr, 'CONTRATO', 'I_D' )
      cSitCtr = CONTRATO.situacao
      IF CONTRATO.motivocancel= 'FINANCEIRO'
         cSitCtr = 'BLOQUEADO'
      ENDIF
   ENDIF
   TRY
      GO nPos IN CONTRATO
   CATCH
   ENDTRY
ENDIF

IF USED( 'ASSOCIADO' ) AND nidAssoc>0
   nPos = RECNO('ASSOCIADO')
   IF SEEK( nidAssoc, 'ASSOCIADO', 'IDASSOC' )
      cSitAssoc = ASSOCIADO.situacao
      IF CONTRATO.motivocancel = 'FINANCEIRO'
         cSitAssoc = 'BLOQUEADO'
      ENDIF
      TRY
         GO nPos IN ASSOCIADO
      CATCH
      ENDTRY
   ENDIF
ENDIF

IF EMPTY(cTipoRet)
   IF !EMPTY(cSitAssoc)
      cRet = cSitAssoc

   ELSE
      IF !EMPTY(cSitCtr )
         cRet = cSitCtr
      ENDIF
   ENDIF
ELSE
   cRet = IIF(cTipoRet='C', cSitCtr , cSitAssoc )
ENDIF
IF EMPTY(cRet)
   cRet = BSPSQ.situacao
ENDIF
RETURN cRet


