CLEAR
CLOSE TABLES ALL
CLOSE DATABASES ALL

USE ASSOCIADO

SCAN ALL
   ?? [.]
   IF '�' $ NOME
     REPLACE NOME WITH STRTRAN(NOME,'�','A')
     ?? [N]
   ENDIF
   IF '�' $ ENDERECO 
      REPLACE ENDERECO WITH STRTRAN(ENDERECO ,'�','A')
     ?? [E]
   ENDIF 
   IF '�' $ BAIRRO
      REPLACE BAIRRO   WITH STRTRAN(BAIRRO,'�','A') 
      ?? [B]
   ENDIF
ENDSCAN 