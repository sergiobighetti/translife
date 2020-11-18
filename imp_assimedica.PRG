Create Cursor TMP (;
   CODIGO C(20),;
   NOME   C(40),;
   ENDERECO C(40),;
   BAIRRO   C(25),;
   CEP      C(10),;
   CIDADE   C(25),;
   UF       C(2),;
   NASC     C(10),;
   TIPO     C(1) )


Create Cursor IMP ( LIN C(240))
Append From ? Sdf

BROWSE


Scan All

   cCod  = Alltrim( Substr( LIN, 1, 21) ) && "053.72.000027-05     "
   cNome = Alltrim( Substr( LIN, 22,41) ) && "DANIEL MARCOS DE ANDRADE                 "
   cEnd  = Alltrim( Substr( LIN, 63,41) ) && "R JOAQUIM NOVAES, 146                    "
   cBai  = Alltrim( Substr( LIN,104,21) ) && "CENTRO               "
   cCep  = Alltrim( Substr( LIN,125,11) ) && "13052180   "
   cCid  = Alltrim( Substr( LIN,136,21) ) && "CAMPINAS             "
   cUF   = Alltrim( Substr( LIN,157, 3) ) && "SP "
   cNas  = Alltrim( Substr( LIN,160,11) ) && "11/03/1997 "
   cNas  = Right(cNas,4) +Substr(cNas,4,2) +Left(cNas,2)
   cTip  = Alltrim( Substr( LIN,171   ) ) && "TITULAR"

   cTip  = Iif( Left(cTip,1)='T', '1', Iif(Left(cTip,1)='D', '2', Left(cTip,1)))

   Insert Into TMP Values ( cCod, cNome, cEnd, cBai, cCep, cCid, cUF, cNas, cTip )

Endscan



Create Cursor ORIGEM ;
   ( TIPO       C( 1),;
   NOME       C(40),;
   ENDERECO   C(40),;
   COMPLE     C(40),;
   BAIRRO     C(20),;
   CEP        C(10),;
   CIDADE     C(20),;
   ESTADO     C( 2),;
   FONE_RES   C(20),;
   FONE_COM   C(20),;
   PERTO_DE   C(40),;
   ENTRE_RUA  C(40),;
   DT_NASCIME C( 8),;
   SEXO       C( 9),;
   CIVIL      C(11),;
   CPF        C(14),;
   RG         C(18),;
   CODIGOTIT  C(20),;
   CODIGODEP  C(20),;
   ATEND      N( 1),;
   ACAO       N( 1),;
   DATABASE   C( 8),;
   APH        C(90),;
   VALOR      Y,;
   idTIT      I,;
   idDEP      I )

cCodTIT =''
cCodDEP= ''
Select * From TMP Order By CODIGO Into Cursor TMP
Scan All

   cCodigo = Alltrim(CODIGO)
   cCodDEP = ''
   If TIPO='1'
      cCodTIT = cCodigo
   Else
      cCodDEP = cCodigo
   Endif

   *!*   11.1 – Como remuneração pelos serviços de APH (atendimento pré-hospitalar),orientação médica por telefone e
   *!*          transportes inter-hospitalares para todas as vidas da carteira da CONTRATANTE nas cidades de Campinas ,
   *!*          Souzas, Barão Geraldo, Sumaré, Hortolândia e Valinhos a CONTRATANTE pagará a CONTRATADA o valor mensal de R$ 0,76
   *!*          (setenta e seis centavos) por vida.
   *!*   11.2 – Como remuneração pelos serviços de orientação médica por telefone para todas as vidas da carteira da CONTRATANTE nas
   *!*          cidades de Americana, Amparo, Arthur Nogueira, Capivari, Cosmópolis, Itapira, Itatiba, Mogi-Guaçú, Mogi-Mirim, Monte Mor,
   *!*          Nova Odessa, Pedreira, Salto, Santa Bárbara D’Oeste e Vinhedo a CONTRATANTE pagará a CONTRATADA o valor mensal de R$ 0,45
   *!*          (quarenta e cinco centavos) por vida.
   *!*   4.7    A CONTRATADA disponibilizará para a CONTRATANTE, por mera liberalidade, sem qualquer custo para a CONTRATANTE, até 4 (quatro)
   *!*          Transportes Urbanos Simples (motorista e técnico de enfermagem) por semana, mais 4 (quatro) transportes completos por mês,
   *!*          se o caso clínico exigir (motorista e técnico de enfermagem e médico), dentro e/ou entre as cidades de Campinas, Sousas,
   *!*          Barão Geraldo, Sumaré, Hortolândia, Valinhos de forma acumulativa pelo período de 90(noventa) dias.

   If Alltrim(CIDADE) $ "CAMPINAS,SOUZAS,BARAO GERALDO,SUMARE,HORTOLANDIA,VALINHOS"
      nVlr=0.76
      cAPH = 'APH'
   Else
      nVlr=0.45
      cAPH = 'OMT'
   Endif

   Insert Into ORIGEM ;
      ( TIPO, Nome, ENDERECO, BAIRRO, CEP, CIDADE, ESTADO, DT_NASCIME, CODIGOTIT, CODIGODEP, ATEND, ACAO, VALOR, APH ) ;
      VALUES ;
      (TMP.TIPO, TMP.Nome, TMP.ENDERECO, TMP.BAIRRO,TMP.CEP, TMP.CIDADE, TMP.UF, TMP.NASC, cCodTIT,cCodDEP, 1, 1, nVlr, cAPH )

Endscan

SELECT ORIGEM
cPut = PUTFILE( 'Arquivo', 'Assimed.DBF', 'DBF' )
COPY TO (cPut) 

