LPARAMETERS cExprSQL AS STRING, cCursor AS STRING
LOCAL nRtn AS INTEGER, cSetEscape AS STRING, cSetTalk AS STRING

nRtn       = 0

IF VERCON() > 0

   IF !( TYPE( 'cCursor' ) = 'C' )
      cCursor = 'TC'+SYS(3)
   ENDIF

   cSetEscape = SET("Escape")

   SET ESCAPE ON
   SET TALK OFF
   
   oMsg = CREATEOBJECT( 'processo', 'Executando instrução SQL...<ESC> aborta' )
   oMsg.Show

   nRtn = SQLEXEC( m.gnConexao, cExprSQL, cCursor )
   IF nRtn <= 0
      =STRTOFILE( CHR(13)+cExprSQL, 'FALHASQL.ERR', .t. )
   ENDIF
   oMsg.release

   SET ESCAPE &cSetEscape

ENDIF

RETURN nRtn
