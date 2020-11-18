SELECT ;
      aa.idAssoc; 
      ,aa.codigo;
      ,aa.nome;
      ,aa.ativacao;
      ,aa.data_nascimento;
      ,aa.endereco;
      ,aa.cep;
      ,aa.bairro;
      ,aa.cidade;
      ,aa.uf;
      ,aa.fone_residencia;
      ,SPACE(6);
      ,aa.cpf;
      ,SPACE(10) cpf_vld;
      ,ee.cnpj;
      ,aa.sexo;
      ,SPACE(70) as NomeMae;
      ,aa.rg;
      ,aa.valor;
      ,'????'  as dtini;
      ,'????'  as IdadeIni;
      ,SPACE(1) as ABC;
FROM   ASSOCIADO aa;
JOIN   EMPRESA ee ON aa.idEmpresa=ee.idEmpresa ;
INTO CURSOR CXXX

SCAN all


ENDSCAN 

