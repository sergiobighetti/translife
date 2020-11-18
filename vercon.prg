LOCAL _Rtn, cSetTalk, cSetEscape, oMsg

IF !( TYPE( 'gnConexao' ) $ 'IN'  )
   PUBLIC gnConexao
   m.gnConexao = 0
ENDIF

IF m.gnConexao <= 0

   cSetEscape = SET("Escape")

   SET TALK OFF
   SET ESCAPE ON
   oMsg = CREATEOBJECT( 'processo', 'Conectando ao banco ... Aguarde' )
   oMsg.Show
   m.gnConexao = SQLCONNECT( 'FMDC', '' )
   oMsg.release

   SET ESCAPE &cSetEscape 

ENDIF   

_Rtn = m.gnConexao

RETURN _Rtn
