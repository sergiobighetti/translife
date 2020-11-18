SELECT   distinct ;
         ;
         bb.nome, ;
         bb.endereco, ;
         bb.complemento, ;
         bb.bairro, ;
         bb.uf, ;
         bb.cep, ;
         bb.codigo codassoc, ;
         'T' tipo, ;
         bb.fone_residencia, ;
         aa.idAssoc I_D ;
         ;
FROM     associado_plano aa ;
JOIN     associado bb ON aa.idAssoc=bb.idAssoc ;
WHERE    bb.situacao='ATIVO' ;
     AND SUBSTR(bb.codigo,11,2)='00' ;
     AND aa.dtInc>={^2008-01-01} ;
     AND bb.idContrato=66299 ;
ORDER BY bb.bairro,  bb.cep
   
