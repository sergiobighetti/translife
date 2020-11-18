** cDir = 'c:\temp\mdc\'

cDir = 'm:\ribeirao\'

cFil = '01'
cCid = 'RP'

SET ESCAPE ON

CLEAR
CLOSE DATABASES ALL

CREATE TABLE 'c:\NEWCART' ;
   (  'Tipo'   C(01),;
      Chave    I,;
      COD_ANT  C(25),;
      COD_NEW  C(15),;
      NOME     C(60),;
      DTBASE   D,;
      TpContr  C(15),;
      TPParc   C(10),;
      Sit      C(10),;
      comcart  C(01),;
      RELCart  C(20),;
      atend    C(01),;
      DIAVC    I,;
      endereco C(40),;
      complmto C(40),;
      bairro   C(20),;
      cep      C(10),;
      cidade   C(20),;
      uf       C(02) )


SELECT NEWCART
* INDEX ON COD_NEW TO ('c:\NEWCART')

SCATTER NAME oRegCART BLANK

USE (cDir+'CONTRATO'   ) IN 0 ALIAS CTR
USE (cDir+'TITULAR'    ) IN 0  ALIAS TIT
USE (cDir+'DEPENDENTE' ) IN 0 ALIAS DEP

SELECT CTR
SET ORDER TO NUMERO_CON
** SET STEP ON 

nSeq_01CL = -1
nSeq_01AS = -1
nSeq_01PE = -1

SCAN ALL && WHILE CTR.numero_Contrato < 2000

   nCTR_ID  = CTR.numero_Contrato
   cTpContr = ALLTRIM(CTR.tipo_Contrato)

   IF cTpContr $ 'COLETIVO,ASSOCIAÇÃO,PERMUTA'
   ELSE
      LOOP
   ENDIF  

   cNewTP   = fi_TpContrato( cTpContr )
   cNewCod  = cFil+cNewTP+PADL(nCTR_ID,6,'0' )+'CT'

   oReg = oRegCART

   oReg.tipo    = 'C'
   oReg.Chave   = nCTR_ID
   oReg.COD_ANT = cCid+PADL(nCTR_ID,6,'0')
   oReg.COD_NEW = cNewCod
   oReg.nome    = CTR.nome_Responsavel
   oReg.DTBASE  = CTR.DATABASE
   oReg.TpContr = cTpContr
   oReg.Sit     = CTR.situacao
   oReg.TpParc  = CTR.tipo_Parcela
   oReg.DIAVC   = CTR.dia_Vencimento
   oReg.comcart = IIF(CTR.gera_cart,'S','N')
   oReg.RELCart = ""
   oReg.atend   = ""
   
   oReg.endereco = CTR.endereco
   oReg.complmto = CTR.complemento
   oReg.bairro   = CTR.bairro
   oReg.cep      = CTR.cep
   oReg.cidade   = CTR.cidade
   oReg.uf       = CTR.uf

   
   INSERT INTO NEWCART FROM NAME oReg
   ? [C ]+TRANSFORM(RECNO())+'/'+TRANSFORM(RECCOUNT())
   ?

   IF cTpContr $ 'AREA PROTEGIDA,AREA PRO.BENEM.,AREA PRO.EMPR.,CLIENTE EVENTUAL'
      LOOP
   ENDIF

   nCtdBNF  = 0
   IF cTpContr $ 'COLETIVO,ASSOCIAÇÃO,BENEMÉRITO,PERMUTA'
   
      cMacro = 'nSeq_'+LEFT(cNewCod,4)
      
      IF &cMacro < 0
         &cMacro = nCtr_ID
      ENDIF
      nCtdCOL = &cMacro
      
   ELSE
      nCtdCOL  = 0
   ENDIF

   PTAB( nCTR_ID, 'TIT', 'NUMERO_CON', .T. )
   SELECT TIT
   SCAN WHILE TIT.numero_Contrato == nCTR_ID

      nTIT_ID = TIT.titular
      oReg = oRegCART

      oReg.tipo    = 'T'
      oReg.Chave   = nTIT_ID
      oReg.COD_ANT = TIT.codigo_assoc
      oReg.nome    = TIT.nome
      oReg.DTBASE  = TIT.DATABASE
      oReg.TpContr = cTpContr
      oReg.TpParc  = CTR.tipo_Parcela
      oReg.Sit     = TIT.situacao
      oReg.DIAVC   = CTR.dia_Vencimento
      oReg.comcart = IIF(CTR.gera_cart,'S','N')
      oReg.RELCart = TIT.relCart
      oReg.atend   = IIF(TIT.atendimento,'S','N')
      
      oReg.endereco = TIT.endereco
      oReg.complmto = TIT.complemento
      oReg.bairro   = TIT.bairro
      oReg.cep      = TIT.cep
      oReg.cidade   = TIT.cidade
      oReg.uf       = TIT.uf

      IF cTpContr $ 'FAMILIAR,FUNCIONÁRIO'

         oReg.COD_NEW = cFil+cNewTP+PADL(nCTR_ID,6,'0' )+ TIPOBNF(nCtdBNF)
  
      ELSE 'COLETIVO,ASSOCIAÇÃO,BENEMÉRITO,PERMUTA'

         nCtdBNF  = 0
         oReg.COD_NEW = cFil+cNewTP+PADL(nCtdCOL,6,'0' )+ TIPOBNF(nCtdBNF)

      ENDIF

      nCtdBNF = nCtdBNF + 1
      
      INSERT INTO NEWCART FROM NAME oReg
      
      ?? [T]

      IF PTAB( nTIT_ID, 'DEP', 'TITULAR', .T. )

         SELECT DEP
         SCAN WHILE DEP.titular == nTIT_ID

            nDEP_ID = DEP.ID
            oReg    = oRegCART
            
            oReg.tipo    = 'D'
            oReg.Chave   = nDEP_ID
            oReg.COD_ANT = DEP.codigo_assoc
            oReg.nome    = DEP.nome
            oReg.DTBASE  = DEP.DATABASE
            oReg.TpContr = cTpContr
            oReg.TpParc  = CTR.tipo_Parcela
            oReg.Sit     = DEP.situacao
            oReg.DIAVC   = CTR.dia_Vencimento
            oReg.comcart = IIF(CTR.gera_cart,'S','N')
            oReg.RELCart = DEP.relCart
            oReg.atend   = IIF(DEP.atendimento,'S','N')

            oReg.endereco = TIT.endereco
            oReg.complmto = TIT.complemento
            oReg.bairro   = TIT.bairro
            oReg.cep      = TIT.cep
            oReg.cidade   = TIT.cidade
            oReg.uf       = TIT.uf

            IF cTpContr $ 'FAMILIAR,FUNCIONÁRIO'

               oReg.COD_NEW = cFil+cNewTP+PADL(nCTR_ID,6,'0' )+ TIPOBNF(nCtdBNF)

            ELSE 'COLETIVO,ASSOCIAÇÃO,BENEMÉRITO,PERMUTA'

               oReg.COD_NEW = cFil+cNewTP+PADL(nCtdCOL,6,'0' )+ TIPOBNF(nCtdBNF)


            ENDIF

            INSERT INTO NEWCART FROM NAME oReg
            ?? [d]
            
            nCtdBNF = nCtdBNF + 1

         ENDSCAN
         
         IF nCtdBNF > 99
            =STRTOFILE( cNewCod+CHR(13)+CHR(10), 'C:\NEWCART.ERR', .t. )
         ENDIF

      ENDIF

      SELECT TIT
      nCtdCOL = nCtdCOL + 1
      &cMacro = nCtdCOL

   ENDSCAN

   SELECT CTR

ENDSCAN


FUNCTION TIPOBNF( nCtd )
LOCAL cRtn, cLetra, cStr
IF nCtd < 100
   cRtn = PADL(nCtd,2,'0')
ELSE
   cStr   = RIGHT( TRANSFORM(nCtd), 2 )
   cLetra = CHR( 65 + VAL(LEFT(cStr,1)) )
   cRtn = cLetra+RIGHT(cStr,1)
ENDIF
RETURN cRtn