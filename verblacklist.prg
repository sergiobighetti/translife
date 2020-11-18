LPARAMETERS cWhe, lMsg
LOCAL cSQL, oBlackList, nSele, cCab

lMsg  = IIF( TYPE( 'lMsg' ) = 'L', lMsg, .T. )
nSele = SELECT()
cSQL  = 'SELECT nome,cpf_cnpj,nascimento,mensagem,contrato,beneficiario,atendimento FROM BLACKLIST WHERE '+ cWhe

IF TYPE( 'gnConexao' ) $ 'IN' AND gnConexao > 0
   =SqlRUN( cSQL, 'CLV_BL' ) > 0
ELSE
   cSQL = cSQL + ' INTO CURSOR CLV_BL'
   &cSQL
ENDIF


oBlackList = CREATEOBJECT( 'RELATION' )

oBlackList.ADDPROPERTY( 'nome' )
oBlackList.ADDPROPERTY( 'cpf_cnpj' )
oBlackList.ADDPROPERTY( 'mensagem' )
oBlackList.ADDPROPERTY( 'cpf_cnpj' )
oBlackList.ADDPROPERTY( 'nascimento' )

oBlackList.ADDPROPERTY( 'contrato' )
oBlackList.ADDPROPERTY( 'beneficiario' )
oBlackList.ADDPROPERTY( 'atendimento' )

oBlackList.nome         = ''
oBlackList.mensagem     = ''
oBlackList.cpf_cnpj     = ''
oBlackList.nascimento   = {}
oBlackList.contrato     = .F.
oBlackList.beneficiario = .F.
oBlackList.atendimento  = .F.

IF USED( 'CLV_BL' )
   IF RECCOUNT( 'CLV_BL' ) > 0
      SELECT CLV_BL
      SCATTER NAME oBlackList MEMO
   ENDIF
ENDIF

IF !EMPTY( oBlackList.mensagem )

   IF lMsg
   
      cCab = 'NOME....: '+ ALLTRIM( oBlackList.NOME     ) +CHR(13)+;
             'CPF/CNPJ: '+ ALLTRIM( oBlackList.cpf_cpnj ) +CHR(13)+;
             'NASCIDO.: '+ TRANSFORM( oBlackList.nascimento )+CHR(13)+CHR(13)+;
             oBlackList.mensagem

      MESSAGEBOX( cCab, 16, 'Atenção' )
      
   ENDIF
ENDIF

USE IN ( SELECT( 'CLV_BL' ) )

SELECT (nSele)

RETURN oBlackList
