CLOSE DATABASES all
CLOSE TABLES all

USE atendimento IN 0

SELECT ;
   aa.* ;
FROM HSTATEND aa ;
WHERE ctrNumero=69359 ;
  AND LEFT(DTOS(tm_chama),6)='201106' INTO CURSOR hst READWRITE 
  
  
SCAN all
   
   SCATTER FIELDS EXCEPT id MEMO NAME oReg   
   
     
   cDt = '2012'+ SUBSTR( TTOC(tm_chama,1),5)
   oReg.tm_chama = EVALUATE( '{^'+ TRANSFORM(cDt,'@R 9999-99-99 99:99:99') +'}' )

   cDt = '2012'+ SUBSTR( TTOC(tm_retor,1),5)
   oReg.tm_retor = EVALUATE( '{^'+ TRANSFORM(cDt,'@R 9999-99-99 99:99:99') +'}' )
   
   SELECT atendimento
   APPEND BLANK 
   GATHER NAME oReg MEMO 
   
ENDSCAN    
      
  
