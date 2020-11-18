FUNCTION FI_VERMSGINT()

LOCAL cAls, nSel, cUsr, lChamarForm

nSel = SELECT()
cAls = SYS(2015)
cUsr = Alltrim(m.drvnomeusuario)

Select     ;
           aa.msg_id     I_D ;
           ;
           FROM       MSGINT_U aa ;
           JOIN       MSGINT bb On aa.msg_id=bb.msg_id ;
           WHERE      aa.msg_user = cUsr ;
             AND      bb.msg_exp > Date() ;
INTO Curso (cAls)

lChamarForm = ( _Tally > 0 )

USE IN (SELECT(cAls))
SELECT (nSel)


IF lChamarForm
   DO FORM msgint_ver
ENDIF 

SELECT (nSel)