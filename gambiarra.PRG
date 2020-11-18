CLOSE DATABASES ALL
CLEAR

SELECT ;
       cc.Situacao,;
	    cc.idContrato,;
       cc.Tipo_Contrato,;
   	 cc.Forma_Pagamento,;
   	 MONTH( cc.dataBase ) mes_dtbase,;
   	 MONTH( cc.Ativacao ) mes_ativacao;
   ;
FROM	ASSOCIADO aa ;
JOIN  CONTRATO cc ON aa.idContrato == cc.idContrato ;
WHERE cc.tipo_Contrato='FAM' AND ;
      aa.idAssoc NOT IN ( SELECT xx.idAssoc FROM ASSOCIADO_PLANO xx ;
                          WHERE aa.idAssoc=xx.idAssoc AND INLIST(xx.idPlano,19,20) ) ;
INTO CURSOR CTST


SELECT CLV_PLANO
SCAN ALL 
   nID = idAssoc
    
   SELECT aa.idplanosaude cod, ;
          NVL(bb.descricao,SPACE(30)) descricao ;
   FROM   ASSOCIADO_PSAUDE aa ;
   LEFT OUTER JOIN PLANOSAUDE bb on aa.idplanosaude == bb.PlanoSaude ;
   WHERE aa.idAssoc == nID ;
   ORDER BY bb.descricao ;
   INTO CURSOR cVER
   
   cPS = ''
   SCAN ALL
      cPS = cPS + ', ('+TRANSFORM(cod)+') '+ALLTRIM(descricao)
   ENDSCAN 
   cPS = SUBSTR(cPS,3)

   SELECT CLV_PLANO
   replace PSAUDE WITH cPS
   ?? [.]
ENDSCAN 





*!*	SELECT idContrato;
*!*	FROM   CONTRATO ;
*!*	WHERE  forma_pagamento='PERMUTA' AND situacao='ATIVO' ;
*!*	INTO CURSOR CVER

*!*	SCAN all
*!*	   ?? [.]
*!*	   
*!*	   nID  = idContrato
*!*	   
*!*	   DELETE FROM ARECEBER ;
*!*	   WHERE idContrato=nID AND origem='FATUR' AND;
*!*	         data_vencimento ={^2007-07-10}
*!*	   ?? _TALLY
*!*	   SELECT cVer
*!*	ENDSCAN  




*!*	CLEAR

*!*	SELECT ;
*!*		aa.idAssoc,;
*!*		aa.codigo,;
*!*		aa.nome,;
*!*		aa.fone_comercial,;
*!*		aa.fone_residencia,;
*!*		CAST('' as Memo) PSAUDE;
*!*	   ;
*!*	FROM	ASSOCIADO aa ;
*!*	WHERE	aa.situacao='ATIVO' ;
*!*	   AND  SUBSTR(aa.codigo,11,2)='00' ;
*!*		AND !empty( aa.fone_comercial+aa.fone_residencia) ;
*!*	ORDER BY aa.codigo ;	
*!*	INTO CURSOR CLV_PLANO READWRITE


*!*	SELECT CLV_PLANO
*!*	SCAN ALL 
*!*	   nID = idAssoc
*!*	    
*!*	   SELECT aa.idplanosaude cod, ;
*!*	          NVL(bb.descricao,SPACE(30)) descricao ;
*!*	   FROM   ASSOCIADO_PSAUDE aa ;
*!*	   LEFT OUTER JOIN PLANOSAUDE bb on aa.idplanosaude == bb.PlanoSaude ;
*!*	   WHERE aa.idAssoc == nID ;
*!*	   ORDER BY bb.descricao ;
*!*	   INTO CURSOR cVER
*!*	   
*!*	   cPS = ''
*!*	   SCAN ALL
*!*	      cPS = cPS + ', ('+TRANSFORM(cod)+') '+ALLTRIM(descricao)
*!*	   ENDSCAN 
*!*	   cPS = SUBSTR(cPS,3)

*!*	   SELECT CLV_PLANO
*!*	   replace PSAUDE WITH cPS
*!*	   ?? [.]
*!*	ENDSCAN 
