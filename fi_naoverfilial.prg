FUNCTION fi_NaoVerFilial()
LOCAL cNaoVer 

cNaoVer = ''
If File('ATENDMTO.INI')
   cNaoVer = ReadFileINI( Locfile('ATENDMTO.INI'), 'CERCEA_FILIAL', m.drvnomeusuario)
ENDIF 
RETURN NVL(cNaoVer,'')
