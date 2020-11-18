CLOSE DATABASES all
CLOSE TABLES all
SET ESCAPE ON 
CD c:\desenv\win\vfp9\sca_new



tIni = {^2012-11-01 00:00:00} 
tFim = {^2013-10-31 23:59:59} 

dNasc = GOMONTH( DATE(), (12*21)*-1 )

SELECT     ;
           IIF( substr(aa.codigo,11,2)='00','TIT', 'DEP' ) as TpAssoc ;
         , aa.cep       ;
         , NVL(bb.bairro,SPACE(30)) as BAIRRO_CEP ;
         , ( ( select COUNT(xx.id) ;
                 FROM atendimento xx ;
                WHERE xx.idAssoc   == aa.idAssoc  ;
                  AND xx.tm_chama BETWEEN tIni AND tFim ; 
                  AND xx.situacao  == 2 ;                 && ENCERRADO
                  AND xx.liberacao == 2 ;                 && LIBERADO  
                  AND EMPTY(xx.idcancelamento)   ;        && NAO ESTA CANCELADO
                  AND LEFT(xx.medclassificacao,3) in ('CON', 'URG', 'EME' ) );
             + ;
             ( select COUNT(yy.id) ;
                 FROM hstAtend yy ;
                WHERE yy.idAssoc   == aa.idAssoc  ;
                  AND yy.tm_chama BETWEEN tIni AND tFim ; 
                  AND yy.situacao  == 2 ;          
                  AND yy.liberacao == 2 ;          
                  AND EMPTY(yy.idcancelamento)   ;        && NAO ESTA CANCELADO
                  AND LEFT(yy.medclassificacao,3) in ('CON', 'URG', 'EME' ) )) as QT_ATEND_12_MESES ;
        , aa.nome ;
        , calcIdade( aa.data_nascimento ) as IDADE ;
        , aa.codigo ;
        , cc.tipo_contrato ;
        , aa.fone_residencia as FONE_RES;
        , aa.fone_comercial  as FONE_COM;
        , cc.fone as FONE_CTR1;
        , cc.fax  as FONE_CTR2;
        , cc.email ;
FROM   ASSOCIADO aa    ;
JOIN   CONTRATO cc ON aa.idContrato=cc.idContrato ;
JOIN  "C:\Documents and Settings\Administrador\Desktop\CEP" bb ON bb.cep=ALLTRIM(CHRTRAN(aa.cep,'.-', '')) ;
WHERE  aa.situacao='ATIVO' ;
   AND aa.codigo='01' ;
   ; && AND aa.atendimento=.t. 
   AND !EMPTY(aa.data_nascimento) AND aa.data_nascimento <= dNasc ;
   ; && AND !EMPTY(aa.bairro) 
   ; && AND !EMPTY(aa.fone_residencia) 
   ; && AND !EMPTY(bb.bairro) 
   AND !aa.cep='  ' ;
   AND !aa.cep='00' ;
   AND !aa.cep='99' ;
ORDER BY aa.codigo desc  



*!*       Boulevard
*!*       Higienópolis
*!*       Sumaré
*!*       Alto da Boa Vista
*!*       Vila Santa Terezinha
*!*       Jardim América
*!*       Jardim São Luiz
*!*       Jardim Irajá
*!*       Santa Cruz
*!*       Jardim Laranjeiras
*!*       City Ribeirão
*!*       Jardim Botânico
*!*       Jardim Flórida
*!*       Recreio das Acácias
*!*       Vila Ana Maria
*!*       Jardim João Rossi
*!*       Jardim Nova Aliança
*!*       Jardim Nova Aliança Sul
*!*       Jardim Santa Angela
*!*       Jardim Itamarati
*!*       Quinta da Alvorada
*!*       Country Vilage
