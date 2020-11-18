CLOSE TABLES all
CREATE CURSOR LV_VS ( ;
NOME       C(40),;
ENDERECO   C(40),;
COMPLEMENT C(40),;
BAIRRO     C(35),;
CIDADE     C(25),;
UF         C(2),;
CEP        C(10) )


CREATE CURSOR LV_ETQ (linha C(200))
APPEND FROM (GETFILE()) SDF
GO bottom

GO 3
SCAN WHILE !EOF()
clear
   cCod = ALLTRIM(linha)
   cCod = CHRTRAN( cCod, CHR(12), '' )
   
   SKIP 2
   cNome= ALLTRIM(linha)
   SKIP 1
   cEnd= ALLTRIM(linha)
   SKIP 1
   cBai=ALLTRIM(linha)
   SKIP 1

   cCep =   LEFT( linha, 10 )
   cCid = SUBSTR( linha,11,20)
   cUF  = SUBSTR( linha,32,02)
   SKIP 1

INSERT INTO LV_VS (NOME,ENDERECO,BAIRRO,CIDADE,UF,CEP) VALUES (cNome,cEnd,cBai,cCid,cUF,cCep)
   
ENDSCAN 
