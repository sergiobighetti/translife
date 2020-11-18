CLOSE DATABASES all
CLOSE TABLES all

CD \\dcrpo\bdmdc$

SET EXCLUSIVE OFF 
USE contrato IN 0

SELECT ;
       aa.idempresa,  aa.cnpj,  aa.nomeempresa, ;
       aa.endereco, aa.complemento, aa.fone1, aa.fone2, aa.email,;
       CAST( 0 as integer ) idContrato, ;
       SPACE(60) NomeContrato,;
       ;
       ( SELECT COUNT(*) qtd;
         FROM   ASSOCIADO bb ;
         WHERE  bb.idEmpresa==aa.idEmpresa AND bb.situacao='ATIVO' AND bb.ATENDIMENTO=.t. ) QTD_ATV_C_ATD,;
        aa.database, aa.situacao,  aa.ativacao;
        ;
FROM   EMPRESA  aa ;
WHERE  aa.situacao='ATIVO' ;
INTO CURSOR  CVER READWRITE


SCAN ALL
   nIdE = idEmpresa
   
   SELECT TOP 1 idContrato FROM ASSOCIADO WHERE idEmpresa=nIdE ORDER BY 1 INTO CURSOR VEMPR
   
   SELECT CVER
   replace idContrato WITH VEMPR.idContrato
   =SEEK( VEMPR.idContrato, 'CONTRATO', 'I_D' )
   replace NomeContrato WITH Contrato.nome_responsavel
   

ENDSCAN 

SELECT * FROM cVER ORDER BY NomeContrato, NomeEmpresa
