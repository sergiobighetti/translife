LPARAMETERS nID_atd, oReg

LOCAL cTipo

cTipo = IIF( NVL(oReg.idMedico,0) > 0, 'USA', 'USB' )  && se tem medico � USA do contrario USB


RETURN ''