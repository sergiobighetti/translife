FUNCTION FI_TRIA_ABRE( cCampo, cNome)
LOCAL cWhe, cVer, nSel

nSel = SELECT()
cWhe = "aa."+cCampo+"='"+ cNome +"'"
cVer = SYS(2015) 
WAIT WINDOW  "Consultando "+ cWhe +" ... aguarde " NOWAIT NOCLEAR 

SELECT      ; 
             aa.nome ;
            ,aa.codigo ;
            ,aa.situacao ;
            ,IIF(aa.atendimento=.t.,'SIM','NAO') as Atend ;
            ,aa.cpf, aa.rg, aa.data_nascimento, aa.endereco ;
            ,aa.idContrato ;
            ,cc.nome_responsavel ;
            ,cc.tipo_contrato ;
            ,aa.idAssoc ;
FROM        ASSOCIADO aa ;
JOIN        CONTRATO cc ON aa.idContrato=cc.idContrato ;
WHERE       &cWhe. AND !DELETED() ;
INTO CURSOR (cVer)

WAIT CLEAR 

IF _TALLY > 0
  DO FORM pesquisa 
ENDIF 

USE IN (SELECT(cVer))
SELECT (nSel)

RETURN

