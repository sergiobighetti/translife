Close Databases All
Close Tables All
Clear

nIdContrato = 70719

SELECT IIF( RIGHT(ALLTRIM(aa.codigo),2) = '00', '1', '2' ) as TIPO,;
      aa.nome, aa.endereco, aa.complemento as comple, aa.bairro, aa.cep, aa.cidade, aa.uf as ESTADO,;
      aa.fone_residencia as fone_res, aa.fone_comercial as fone_com, aa.perto_de, aa.entre_ruas as entre_rua,;
      DTOS(aa.data_nascimento) as DT_NASCIME , aa.sexo, aa.estado_civil as CIVIL, aa.cpf, aa.rg,;
      bb.codorigem as CODIGOTIT  , IIF( RIGHT(ALLTRIM(aa.codigo),2) = '00','', aa.codorigem ) as CODIGODEP  , IIF(aa.atendimento,1,0) as ATEND, 1 as acao,;
      DTOS(aa.database) as DATABASE    ;
FROM   ASSOCIADO aa ;
JOIN   ASSOCIADO bb ON LEFT(aa.codigo,10)+'00' = bb.codigo AND aa.idcontrato=nIdContrato ;
WHERE  aa.idcontrato=nIdContrato AND  aa.situacao='ATIVO'