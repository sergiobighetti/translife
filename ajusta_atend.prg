CLOSE DATABASES ALL
CLOSE TABLES ALL
SET EXCLUSIVE OFF
SET ESCAPE ON
CLEAR

LOCAL aArq[2]

aArq[1] = '\\dcrpo\bdmdc$\ATENDIMENTO'
aArq[2] = '\\dcrpo\bdmdc$\hstatend'

FOR i=1 TO 2

   ? aArq[i]
   
   USE (aArq[i]) IN 0 ALIAS ATEND
   
   SELECT ATEND
   GO TOP 

   SCAN FOR codatendimento=13
       ?? [.]
       IF EMPTY(medclassificacao)
          IF regclassificacao='CON'
             replace ateclassificacao WITH 'ORIENTACAO'
             replace regclassificacao WITH 'ORIENTACAO'
             ?? [*]
          ENDIF 
       ENDIF 
   ENDSCAN 
   
   USE
   
NEXT    