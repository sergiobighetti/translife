CLOSE DATABASES all
CLOSE TABLES all
SET ESCAPE ON 
CD c:\desenv\win\vfp9\sca_new

t12Ini = {^2012-04-01 00:00:00} 
t12Fim = {^2013-03-31 23:59:59} 

t24Ini = {^2011-04-01 00:00:00} 
t24Fim = {^2012-03-31 23:59:59} 


dNasc = DATE() && GOMONTH( DATE(), (12*21)*-1 )

SELECT     ;
           IIF( substr(aa.codigo,11,2)='00','TIT', 'DEP' ) as TpAssoc ;
         , ( ( select COUNT(xx.id) ;
                 FROM atendimento xx ;
                WHERE xx.idAssoc   == aa.idAssoc  ;
                  AND xx.tm_chama BETWEEN t12Ini AND t12Fim ; 
                  AND xx.situacao  == 2 ;                 && ENCERRADO
                  AND xx.liberacao == 2 ;                 && LIBERADO  
                  AND EMPTY(xx.idcancelamento)   ;        && NAO ESTA CANCELADO
                  AND LEFT(xx.medclassificacao,3) in ('CON', 'URG', 'EME' ) );
             + ;
             ( select COUNT(yy.id) ;
                 FROM hstAtend yy ;
                WHERE yy.idAssoc   == aa.idAssoc  ;
                  AND yy.tm_chama BETWEEN t12Ini AND t12Fim ; 
                  AND yy.situacao  == 2 ;          
                  AND yy.liberacao == 2 ;          
                  AND EMPTY(yy.idcancelamento)   ;        && NAO ESTA CANCELADO
                  AND LEFT(yy.medclassificacao,3) in ('CON', 'URG', 'EME' ) )) as QT_ATEND_12_MESES ;
                  ;
                  ;
                  ;
         , ( ( select COUNT(xx.id) ;
                 FROM atendimento xx ;
                WHERE xx.idAssoc   == aa.idAssoc  ;
                  AND xx.tm_chama BETWEEN t24Ini AND t24Fim ; 
                  AND xx.situacao  == 2 ;                 && ENCERRADO
                  AND xx.liberacao == 2 ;                 && LIBERADO  
                  AND EMPTY(xx.idcancelamento)   ;        && NAO ESTA CANCELADO
                  AND LEFT(xx.medclassificacao,3) in ('CON', 'URG', 'EME' ) );
             + ;
             ( select COUNT(yy.id) ;
                 FROM hstAtend yy ;
                WHERE yy.idAssoc   == aa.idAssoc  ;
                  AND yy.tm_chama BETWEEN t24Ini AND t24Fim ; 
                  AND yy.situacao  == 2 ;          
                  AND yy.liberacao == 2 ;          
                  AND EMPTY(yy.idcancelamento)   ;        && NAO ESTA CANCELADO
                  AND LEFT(yy.medclassificacao,3) in ('CON', 'URG', 'EME' ) )) as QT_ATEND_24_MESES ;
        , aa.nome ;
        , calcIdade( aa.data_nascimento ) as IDADE_HOJE ;
        , aa.codigo ;
        , cc.tipo_contrato ;
FROM   ASSOCIADO aa    ;
JOIN   CONTRATO cc ON aa.idContrato=cc.idContrato ;
WHERE  aa.situacao='ATIVO' ;
   AND aa.codigo='01' ;
   AND aa.atendimento=.t. ;
ORDER BY aa.codigo desc  




