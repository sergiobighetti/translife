Close Databases All
Close Tables All
Clear
Set Escape On

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


cArqTXT   = Getfile('TXT','PLANILHA','Abrir',0,'Informa a planilha')

If Empty(cArqTXT) Or Empty(cArqTXT)
   Return
Endif


Create Cursor LV_IMP ( linha1 C(200), linha2 C(200), linha3 C(200) )
SELECT LV_IMP 
Append From (cArqTXT) Sdf

Go Top
Skip
Scan While !Eof()

   cLin = Alltrim(linha1+linha2+linha3)
   nCol = Alines( aCol, cLin,.T.,';' )

   @ 10,10 Say Recno()

   *!*       1 Cod Titular;
   *!*       2 Cod Depte;
   *!*       3 DV;
   *!*       4 Nome do Usuario;
   *!*       5 Parentesco;
   *!*       6 Sexo;
   *!*       7 R.G.;
   *!*       8 CPF;
   *!*       9 Data Nascimento;
   *!*      10 Cidade Nascimento;
   *!*      11 UF;
   *!*      12 Estado Civil;
   *!*      13 Data Casamento;
   *!*      14 Situação;
   *!*      15 Dependencia;
   *!*      16 Plano Sassom;
   *!*      17 Data Admissao Plano;
   *!*      18 Data Validade Cartao;
   *!*      19 Data Desativacao Usuario;
   *!*      20 Codigo Desativacao;
   *!*      21 Endereco;
   *!*      22 Complemento;
   *!*      23 Bairro;
   *!*      24 CEP;
   *!*      25 Cidade;
   *!*      26 UF;
   *!*      27 DDD;
   *!*      28 Fone;
   *!*      29 Ramal;
   *!*      30 Processo;

   cEstCivil = Iif( aCol[12] = [0], 'SOLTEIRO(A)',;
      IIF( aCol[12] = [1], 'CASADO(A)',;
      IIF( aCol[12] = [2], 'SEPARADO(A)',;
      IIF( aCol[12] = [3], 'VIUVO(A)',;
      IIF( aCol[12] = [4], 'COMPANHEIR(A)',;
      IIF( aCol[12] = [5], 'DESQUITADO(A)',;
      IIF( aCol[12] = [6], 'DIVORCIADO(A)',;
      IIF( aCol[12] = [7], 'AMASIADO(A)',;
      IIF( aCol[12] = [8], 'COMCUBINO(A)', 'OUTROS')))))))))

   If aCol[2] = '00'
      cCodTit = aCol[1]+'.'+aCol[3]
      cCodDep = ''
   Else
      cCodDep = aCol[1]+'.'+aCol[3]
   Endif


   If aCol[14]='N'
      @ 10,40 Say 'NAO: '+ Transform(Recno())
      Loop
   Endif



   Select ORIGEM
   Append Blank
   Replace TIPO       With Iif( aCol[2]='00', '1', '2' )
   Replace Nome       With aCol[4]
   Replace ENDERECO   With aCol[21]
   Replace Comple     With aCol[22]
   Replace BAIRRO     With aCol[23]
   Replace CEP        With aCol[24]
   Replace CIDADE     With aCol[25]
   Replace ESTADO     With aCol[26]
   Replace FONE_RES   With ''
   Replace FONE_COM   With ''
   Replace PERTO_DE   With ''
   Replace ENTRE_RUA  With ''
   Replace DT_NASCIME With aCol[09]
   Replace SEXO       With Iif(aCol[06]='M','MASCULINO','FEMININO')
   Replace CIVIL      With cEstCivil
   Replace CPF        With aCol[08]
   Replace RG         With aCol[07]
   Replace CODIGOTIT  With cCodTit
   Replace CODIGODEP  With cCodDep
   Replace ATEND      With 1
   Replace ACAO       With 1
   Replace Database   With aCol[17]
   Replace APH        With ''

   SELECT LV_IMP 

Endscan

