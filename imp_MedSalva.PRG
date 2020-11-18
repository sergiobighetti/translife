LPARAMETERS cArqTXT

* cArqTxt = 'C:\Users\Sergio\Desktop\UNI_AMERICANA\PF\TUDO_UniAmr_97661_13052010_PF.txt'

Local cOrg, cLay, cTxL, cLinha, i, cVar, nEC
Local nTpFone, cPreFix, cNroFon, cObsFon

cOrg = Sys(2015)
cLay = Sys(2015)
cTxL = Sys(2015)

Create Cursor (cOrg) ;
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
     OBSERVACAO C(200),;
     VALOR      Y,;
     idTIT      i,;
     idDEP      i )

*-- layout MEDISALVA
Create Cursor (cLay) ( de N(4), ate N(4), TIPO C(1), obrig C(1) )

Insert Into (cLay) Values ( 0001, 0001, 'A', 'S' )
Insert Into (cLay) Values ( 0002, 0050, 'A', 'S' )
Insert Into (cLay) Values ( 0052, 0050, 'A', 'S' )
Insert Into (cLay) Values ( 0102, 0008, 'D', 'S' )
Insert Into (cLay) Values ( 0110, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0160, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0210, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0260, 0001, 'A', 'S' )
Insert Into (cLay) Values ( 0261, 0002, 'S', 'S' )
Insert Into (cLay) Values ( 0263, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0293, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0295, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0297, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0299, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0301, 0018, 'A', 'N' )
Insert Into (cLay) Values ( 0319, 0018, 'A', 'N' )
Insert Into (cLay) Values ( 0337, 0030, 'A', 'N' )

Insert Into (cLay) Values ( 0367, 0004, 'N', 'S' )
Insert Into (cLay) Values ( 0371, 0050, 'A', 'S' )
Insert Into (cLay) Values ( 0421, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0471, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0521, 0008, 'D', 'N' )
Insert Into (cLay) Values ( 0529, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0531, 0010, 'N', 'S' )
Insert Into (cLay) Values ( 0541, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0543, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0593, 0010, 'A', 'N' )
Insert Into (cLay) Values ( 0603, 0015, 'A', 'N' )
Insert Into (cLay) Values ( 0618, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0648, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0678, 0002, 'A', 'N' )
Insert Into (cLay) Values ( 0680, 0009, 'A', 'N' )
Insert Into (cLay) Values ( 0698, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0691, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 0741, 0010, 'A', 'N' )
Insert Into (cLay) Values ( 0751, 0015, 'A', 'N' )
Insert Into (cLay) Values ( 0766, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0796, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0826, 0002, 'A', 'N' )
Insert Into (cLay) Values ( 0828, 0009, 'A', 'N' )

Insert Into (cLay) Values ( 0837, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0839, 0004, 'N', 'N' )
Insert Into (cLay) Values ( 0843, 0010, 'N', 'N' )
Insert Into (cLay) Values ( 0853, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0883, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0885, 0004, 'N', 'N' )
Insert Into (cLay) Values ( 0889, 0010, 'N', 'N' )
Insert Into (cLay) Values ( 0899, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0929, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0931, 0004, 'N', 'N' )
Insert Into (cLay) Values ( 0935, 0010, 'N', 'N' )
Insert Into (cLay) Values ( 0945, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 0975, 0002, 'N', 'N' )
Insert Into (cLay) Values ( 0977, 0004, 'N', 'N' )
Insert Into (cLay) Values ( 0981, 0010, 'N', 'N' )
Insert Into (cLay) Values ( 0991, 0030, 'A', 'N' )
Insert Into (cLay) Values ( 1021, 0100, 'A', 'N' )
Insert Into (cLay) Values ( 1121, 0100, 'A', 'N' )
Insert Into (cLay) Values ( 1221, 0008, 'D', 'N' )
Insert Into (cLay) Values ( 1229, 0008, 'D', 'N' )

Insert Into (cLay) Values ( 1237, 0050, 'A', 'N' )
Insert Into (cLay) Values ( 1287, 0008, 'D', 'N' )
Insert Into (cLay) Values ( 1295, 0010, 'A', 'N' )

*-- declara variavais
Select &cLay
Scan All
   cVar = TIPO+Transform(de)+'_a_'+Transform(ate)
   Local &cVar.
Endscan


*-- cursor que recebera o texto
Create Cursor (cTxL) ( lin1 C(240), lin2 C(240), lin3 C(240), lin4 C(240), lin5 C(240), lin6 C(240), lin7 C(240) )
Append From (cArqTxt) Sdf


Select (cTxL)
Scan All

   *-- monta linha
   cLinha = &cTxL..lin1+&cTxL..lin2+&cTxL..lin3+&cTxL..lin4+&cTxL..lin5+&cTxL..lin6+&cTxL..lin7

   If Empty(cLinha)
      Exit
   Endif

   *-- carrega variaveis
   Select &cLay
   Scan All
      cVar = TIPO+Transform(de)+'_a_'+Transform(ate)
      &cVar. = semAcento(Substr( cLinha, de, ate))
   Endscan

   *-- inclui no layout medicar
   Select (cOrg)
   Append Blank

   Replace  Nome        With Upper( Alltrim(a52_a_50) )
   Replace  DT_NASCIME  With Right(d102_a_8,4)+Substr(d102_a_8,3,2)+Left(d102_a_8,2)
   Replace  SEXO        With Iif(a260_a_1='M','MASCULINO','FEMININO')
   cEnd = Strtran( Alltrim(a543_a_50)+' '+Alltrim(a593_a_10)+' '+Alltrim(a603_a_15), '  ', ' ' )
   Replace  ENDERECO    With Upper( Left(cEnd,40)   )
   Replace  Comple      With Upper(Substr(cEnd,41))
   Replace  BAIRRO      With Upper(Alltrim(a618_a_30))
   Replace  CEP         With Alltrim(a680_a_9)
   Replace  CIDADE      With Upper(Alltrim(a648_a_30))
   Replace  ESTADO      With Upper(Alltrim(a678_a_2))
   Replace  CPF         With Chrtran( Alltrim(a319_a_18),'-/.','' )
   Replace  RG          With Chrtran( Alltrim(a301_a_18),'-/.','' )
   Replace  CODIGOTIT   With Alltrim( a1237_a_50 )
   Replace  CODIGODEP   With Alltrim( a371_a_50 )
   Replace  ACAO        With Iif( a1_a_1='I', 1, Iif( a1_a_1='A', 2, Iif( a1_a_1='E',3,0)))
   Replace  ATEND       With 1
   Replace  OBSERVACAO  With Alltrim(a471_a_50)
   nEC = Int(Val(s261_a_2))

   Replace  CIVIL ;
      With  Iif( nEC = 1, 'SOLTEIRO',    Iif( nEC = 2, 'CASADO',;
      IIF( nEC = 3, 'DIVORCIADO',  Iif( nEC = 4, 'DIVORCIADO',;
      IIF( nEC = 5, 'COMPANHEIRO', Iif( nEC = 6, 'OUTROS',;
      IIF( nEC = 7, 'OUTROS',      Iif( nEC = 8, 'VIUVO', 'OUTROS' ))))))))

   Replace  Database ;
      With Right(d1287_a_8,4)+Substr(d1287_a_8,3,2)+Left(d1287_a_8,2)

   Local aFones[4,4]
   aFones[1,1] = Int(Val(n837_a_2))
   aFones[1,2] = Right(Alltrim(n839_a_4),3)
   aFones[1,3] = Tran(Int(Val(n843_a_10)))
   aFones[1,4] = Alltrim(a853_a_30)
   *--
   aFones[2,1] = Int(Val(n883_a_2))
   aFones[2,2] = Right(Alltrim(n885_a_4),3)
   aFones[2,3] = Tran(Int(Val(n889_a_10)))
   aFones[2,4] = Alltrim(a899_a_30)
   *--
   aFones[3,1] = Int(Val(n929_a_2))
   aFones[3,2] = Right(Alltrim(n931_a_4),3)
   aFones[3,3] = Tran(Int(Val(n935_a_10)))
   aFones[3,4] = Alltrim(a945_a_30)
   *--
   aFones[4,1] = Int(Val(n975_a_2))
   aFones[4,2] = Right(Alltrim(n977_a_4),3)
   aFones[4,3] = Tran(Int(Val(n981_a_10)))
   aFones[4,4] = Alltrim(a991_a_30)
   *--

   *-- ajusta telefones
   For i=1 To 4

      nTpFone = Int(Val(n837_a_2))
      cPreFix = Right(Alltrim(n839_a_4),3)
      cNroFon = Alltrim(n843_a_10)
      cObsFon = Alltrim(a853_a_30)

      If Inlist(aFones[i,1], 2,5 )
         If Empty(FONE_RES)
            Replace FONE_RES With '('+ aFones[i,2] +')'+aFones[i,3]
         Endif
      Else
         If Empty(FONE_COM)
            Replace FONE_COM With '('+ aFones[i,2] +')'+aFones[i,3]
         Endif
      Endif
   Next

   Select (cTxL)

Endscan

*-- ajusta CODIGO e TIPO
Select (cOrg)
Replace CODIGODEP With Iif(CODIGOTIT==CODIGODEP,'',CODIGODEP) All
Replace TIPO With Iif( !Empty(CODIGODEP) And !CODIGOTIT==CODIGODEP, '2','1' ) All


Use In (Select(cLay))
Use In (Select(cTxL))
