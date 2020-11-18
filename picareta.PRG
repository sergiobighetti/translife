CLOSE DATABASES ALL
CLOSE TABLES ALL

*!*   SET STEP ON 
*!*   Select * From atendimento Where ctrnumero=66398 AND situacao=2 Into Cursor C_att
*!*   Select * From hstatend Where ctrnumero=66398    AND situacao=2  Into Cursor C_hst 
*!*   Select * From C_att Union All Select * From C_hst Into Cursor xjunto


Select * From atendimento Where ctrnumero=66398 AND situacao=2 Into Cursor junto READWRITE 
Select * From hstatend Where ctrnumero=66398    AND situacao=2  Into Cursor C_hst 

SELECT C_HST
SCAN ALL
   SCATTER NAME oReg MEMO 
   SELECT junto 
   APPEND BLANK 
   GATHER NAME oReg
   SELECT C_HST
ENDSCAN 


SELECT JUNTO 
*APPEND FROM DBF('C_att')
*Select * From C_att Union All Select * From C_hst Into Cursor junto


SELECT * FROM JUNTO WHERE 1=2 INTO CURSOR CNEW READWRITE
SELECT JUNTO
SCAN all

   IF (recno()%2)=0
      nAno=0
   ELSE
      nAno=1
   ENDIF
   replace tm_Chama WITH DATETIME( 2009+nAno, MONTH(tm_Chama), DAY(tm_Chama), HOUR(tm_Chama), MINUTE(tm_Chama), SEC(tm_Chama) )
   replace tm_retor WITH DATETIME( 2009+nAno, MONTH(tm_retor), DAY(tm_retor), HOUR(tm_retor), MINUTE(tm_retor), SEC(tm_retor) )
   
ENDSCAN 



SELECT aa.codigo, aa.nome, aa.idassoc, aa.endereco, aa.sexo ;
FROM ASSOCIADO aa ;
WHERE aa.idcontrato=66398 AND ;
      aa.atendimento=.t. AND ;
      aa.situacao='ATIVO' AND ;
      aa.codigo NOT IN (SELECT xx.paccodigo FROM junto xx) ;
ORDER BY aa.endereco, aa.bairro, aa.cidade, aa.nome, aa.codigo ;      
INTO CURSOR CASSOC

GO TOP IN CASSOC

nX = 1
CLEAR

SELECT JUNTO
DO WHILE !EOF('JUNTO')
  
   ?? TRANSFORM(nX)
   IF nX > 5
      EXIT
   ENDIF

   IF JUNTO.idhipotesediag > 0 OR !EMPTY(JUNTO.resumoatendimento)
      SKIP IN JUNTO 
      IF EOF()
         GO TOP 
      ENDIF
      
      LOOP
   ENDIF

   SCATTER NAME oReg MEMO 
    
   
   oReg.pacCodigo = CASSOC.codigo
   oReg.pacNome   = CASSOC.nome
   oReg.pacendereco= CASSOC.endereco
   oReg.idAssoc   = CASSOC.idAssoc
   oReg.pacSexo   = CASSOC.sexo
   oReg.tm_Chama  = oReg.tm_Chama - (86400*nX)
   IF !EMPTY(oReg.tm_retor)
      oReg.tm_retor= oReg.tm_retor- (86400*nX)
   endif
   
   
   SELECT CNEW
   APPEND BLANK
   GATHER NAME oReg MEMO
    
   SKIP 2 IN CASSOC 
   IF EOF( 'CASSOC')
      GO TOP IN CASSOC
   ENDIF
   
   SELECT JUNTO
   SKIP
   
   IF EOF()
      nX = nX + 1 
      ? 
      ?
      GO TOP 
   ENDIF
enddo 


SELECT * FROM CNEW INTO CURSOR CGRAVA

SELECT CGRAVA


SCAN ALL
?? RECNO()

   SCATTER NAME oReg MEMO FIELDS EXCEPT Id
   SELECT ATENDIMENTO
   APPEND BLANK
   GATHER NAME oREG MEMO FIELDS EXCEPT Id
   
   SELECT CGRAVA
ENDSCAN    

CLOSE DATABASES all



      
