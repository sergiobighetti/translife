CD C:\temp\mdc

IF OCCURS('MEDICAR',SET("Classlib") ) = 0
   SET CLASSLIB TO c:\desenv\win\vfp8\sca\MEDICAR.VCX ADDITIVE
ENDIF

IF OCCURS('LIBBASE',SET("Classlib") ) = 0
   SET CLASSLIB TO c:\desenv\win\vfp8\libbase\LIBBASE.VCX ADDITIVE
ENDIF

IF OCCURS('LIBROTINA', SET("Procedure") ) = 0
   SET PROCEDURE TO c:\desenv\win\vfp8\libbase\LIBROTINA ADDITIVE
ENDIF   

PUBLIC drvNivelUsuario, drvNomeUsuario, drvGrupoUsuario
m.drvNivelUsuario = 9
m.drvGrupoUsuario = 1
m.drvNomeUsuario  = 'SERGIO'

cSetPath = "SET PATH TO "+ SET("Path") +";c:\temp\mdc;c:\temp\mdc\DADOS;c:\temp\mdc\FRM;c:\temp\mdc\LIBS;c:\temp\mdc\PRG"

&cSetPath