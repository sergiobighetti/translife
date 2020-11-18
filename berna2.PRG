IF OCCURS( 'LIBROTINA.PRG', UPPER(SET("Procedure")) ) = 0
   SET PROCEDURE TO c:\desenv\win\vfp9\libbase\librotina.prg ADDITIVE 
ENDIF 

cRef = '200701'
dIni = EVALUATE( '{^'+TRANSFORM(cRef,'@R 9999-99')+'-01}' )
dFim = dIni + 32
dFim = dFim - DAY(dFim)

SET TEXTMERGE TO MEMVAR cXXX NOSHOW
SET TEXTMERGE ON

\Pessoa fisica (FAMILIAR,LAR PROTEGIDO)
\
\   *** ATIVOS
\
\                                             FILIAL 01        FILIAL 02        FILIAL 04  
\                                        ================================================


***********************************************************************************************
dFim = {^2007-01-31}
SELECT      ;
            LEFT( aa.codigo, 02 ) FILIAL,;
            COUNT(aa.idAssoc)     QUANT ;
FROM        ASSOCIADO aa ;
JOIN        CONTRATO  bb ON aa.idContrato == bb.idContrato ;
WHERE       aa.atendimento = .t. ;
        AND LEFT(bb.tipo_contrato,3) IN ( 'FAM', 'LAR' ) ;
        AND aa.ativacao <= dFim ;
        AND IIF( !EMPTY(aa.dataExc),  aa.dataExc > dFim, aa.situacao = 'ATIVO' );
GROUP BY    1 ;
ORDER BY    1 ;
INTO CURSOR CDADOS

SELECT      SUM(IIF( FILIAL='01', QUANT, 000000 )) FIL01,;
            SUM(IIF( FILIAL='02', QUANT, 000000 )) FIL02,;
            SUM(IIF( FILIAL='04', QUANT, 000000 )) FIL04 ;
FROM        CDADOS ;
INTO CURSOR CVER

\                    Quantidade de vidas 
\\<<TRANSFORM(FIL01,'99999999999999')>> | <<TRANSFORM(FIL02,'99999999999999')>> | <<TRANSFORM(FIL04,'99999999999999')>>




***********************************************************************************************

DIMENSION aMrt[4,4]
STORE 0 TO aMrt

aMrt[ 1, 1] = 'ANUAL'
aMrt[ 2, 1] = 'MENSAL'
aMrt[ 3, 1] = 'SEMEST'
aMrt[ 4, 1] = 'TRIMES'

SELECT      ;
            aa.idFilial           FILIAL,;
            aa.tipo_parcela       TPPARC,;
            COUNT(aa.idContrato)  QUANT ;
FROM        CONTRATO aa ;
WHERE       aa.situacao = 'ATIVO' ;
        AND LEFT(aa.tipo_contrato,3) IN ( 'FAM', 'LAR' ) ;
GROUP BY    1,2 ;
ORDER BY    1,2 ;
INTO CURSOR CDADOS
SCAN ALL
   
     FOR nPos = 1 TO 4
        IF aMrt[nPos,1] = ALLTRIM(TPPARC)
           EXIT
        ENDIF
     ENDFOR

    IF FILIAL='04'
       aMrt[nPos,3] = aMrt[nPos,3] + QUANT      
    ELSE
       aMrt[nPos,VAL(FILIAL)+1] = aMrt[nPos,3] + QUANT      
    ENDIF
          
   
ENDSCAN 

FOR i = 1 TO 4
    \ 
    \\<<PADL('Quantidade de contratos'+' '+ALLTRIM(aMrt[i,1]), 37)>>  
    \\<<TRANSFORM(aMrt[i,2],'99999999999999')>> | 
    \\<<TRANSFORM(aMrt[i,3],'99999999999999')>> | 
    \\<<TRANSFORM(aMrt[i,4],'99999999999999')>>
    
ENDF 




***********************************************************************************************

\
\
SELECT      ;
            aa.idFilial   FILIAL,;
            SUM(aa.valor) VALOR ;
FROM        CONTRATO aa ;
WHERE       aa.situacao = 'ATIVO' ;
        AND LEFT(aa.tipo_contrato,3) IN ( 'FAM', 'LAR' ) ;
GROUP BY    1 ;
ORDER BY    1 ;
INTO CURSOR CDADOS

SELECT      SUM(IIF( FILIAL='01', VALOR , $0 )) FIL01,;
            SUM(IIF( FILIAL='02', VALOR , $0 )) FIL02,;
            SUM(IIF( FILIAL='04', VALOR , $0 )) FIL04 ;
FROM        CDADOS ;
INTO CURSOR CVER

\                 Valor de representação 
\\<<TRANSFORM(FIL01,'999,999,999.99')>> | <<TRANSFORM(FIL02,'999,999,999.99')>> | <<TRANSFORM(FIL04,'999,999,999.99')>>







***********************************************************************************************

SELECT          LEFT(bb.codigo,2) FILIAL,;
                aa.idplano        CODPLANO,;  
                pp.descricao      PLANO,;
                SUM(aa.valor)     valor ;
                ;
FROM            ASSOCIADO_PLANO aa ;
JOIN            PLANOS pp ON aa.idPlano == pp.plano ;
JOIN            ASSOCIADO bb ON aa.idAssoc == bb.idAssoc ;
JOIN            CONTRATO cc ON bb.idContrato == cc.idContrato ;
WHERE           bb.situacao = 'ATIVO' ;
            AND bb.atendimento = .t. ;
            AND LEFT(cc.tipo_contrato,3) IN ( 'FAM', 'LAR' ) ;
GROUP by        1,2,3 ;
INTO CURSOR     CDADOS READWRITE


FOR i = 1 TO 3
    cFil = IIF( i = 3, '04', '0'+TRANSFORM(i) )
   SELECT PLANOS
   SCAN ALL
      IF NOT LTAB( 'FILIAL="' +cFil+ '" AND CodPlano='+TRANSFORM(plano), 'CDADOS' )
         INSERT INTO CDADOS ( FILIAL, CODPLANO, PLANO ) VALUES ( cFil, PLANOS.plano, PLANOS.descricao )
      ENDIF
   ENDSCAN 
ENDFOR

SELECT      CODPLANO, PLANO, ;
            SUM(IIF( FILIAL='01', valor, $0 )) FIL01,;
            SUM(IIF( FILIAL='02', valor, $0 )) FIL02,;
            SUM(IIF( FILIAL='04', valor, $0 )) FIL04 ;            
            ;
FROM        CDADOS ;
GROUP BY    1,2 ;
ORDER BY    1,2 ;
INTO CURSOR CVER

SCAN all
   IF FIL01+FIL02+FIL04 = 0
      LOOP
   ENDIF
   \<<PADL(ALLTRIM(PLANO),37)+'   '>>
   \\<<TRANSFORM(FIL01,'999,999,999.99')>> | <<TRANSFORM(FIL02,'999,999,999.99')>> | <<TRANSFORM(FIL04,'999,999,999.99')>>
ENDSCAN 







***********************************************************************************************
SELECT      aa.idFilial             FILIAL,;
            SUM(aa.valor_documento) VALOR;
            ;
FROM        ARECEBER aa ;
JOIN        CONTRATO bb ON aa.idContrato == bb.idContrato ;
WHERE       aa.data_vencimento BETWEEN dIni AND dFim ;
        AND LEFT(bb.tipo_contrato,3) IN ( 'FAM', 'LAR' ) ;
GROUP BY    1 ;
ORDER BY    1 ;
INTO CURSOR CDADOS

SELECT      FILIAL, ;
            SUM(IIF( FILIAL='01', valor, $0 )) FIL01,;
            SUM(IIF( FILIAL='02', valor, $0 )) FIL02,;
            SUM(IIF( FILIAL='04', valor, $0 )) FIL04 ;            
            ;
FROM        CDADOS ;
GROUP BY    1 ;
ORDER BY    1 ;
INTO CURSOR CVER

\
\
\                       Valor faturado  
\\ <<TRANSFORM(FIL01,'999,999,999.99')>> | <<TRANSFORM(FIL02,'999,999,999.99')>> | <<TRANSFORM(FIL04,'999,999,999.99')>>






***********************************************************************************************


SELECT      aa.idFilial             FILIAL,;
            aa.forma_pagto          FORMAPAGAMENTO, ;
            SUM(aa.valor_documento) VALOR;
            ;
FROM        ARECEBER aa ;
JOIN        CONTRATO bb ON aa.idContrato == bb.idContrato ;
WHERE       aa.data_vencimento BETWEEN dIni AND dFim ;
        AND LEFT(bb.tipo_contrato,3) IN ( 'FAM', 'LAR' ) ;
GROUP BY    1,2 ;
ORDER BY    1,2 ;
INTO CURSOR CDADOS READWRITE 


SELECT distinct FORMAPAGAMENTO FROM CDADOS ORDER BY 1 INTO CURSOR CVER

FOR i = 1 TO 3
   cFil = IIF( i = 3, '04', '0'+TRANSFORM(i) )
   SELECT CVER
   SCAN ALL
      IF NOT LTAB( 'FILIAL="' +cFil+ '" AND FORMAPAGAMENTO="'+TRANSFORM(FORMAPAGAMENTO)+'"', 'CDADOS' )
         INSERT INTO CDADOS ( FILIAL, FORMAPAGAMENTO ) VALUES ( cFil, CVER.FORMAPAGAMENTO )
      ENDIF
   ENDSCAN 
ENDFOR  
        
SELECT      FORMAPAGAMENTO,;
            SUM(IIF(FILIAL='01',valor,$0)) FIL01,;
            SUM(IIF(FILIAL='02',valor,$0)) FIL02,;
            SUM(IIF(FILIAL='04',valor,$0)) FIL04 ;
FROM        CDADOS ;
GROUP BY    1 ;
ORDER BY    1 ;
INTO CURSOR CVER

\
SCAN all
   \<<PADL(ALLTRIM(FORMAPAGAMENTO),37)+'  '>>
   \\ <<TRANSFORM(FIL01,'999,999,999.99')>> | <<TRANSFORM(FIL02,'999,999,999.99')>> | <<TRANSFORM(FIL04,'999,999,999.99')>>
ENDSCAN 





***********************************************************************************************


SELECT      aa.idFilial             FILIAL,;
            bb.dia_vencimento       DIAVC, ;
            SUM(aa.valor_documento) VALOR;
            ;
FROM        ARECEBER aa ;
JOIN        CONTRATO bb ON aa.idContrato == bb.idContrato ;
WHERE       aa.data_vencimento BETWEEN dIni AND dFim ;
        AND LEFT(bb.tipo_contrato,3) IN ( 'FAM', 'LAR' ) ;
GROUP BY    1,2 ;
ORDER BY    1,2 ;
INTO CURSOR CDADOS READWRITE


SELECT distinct DIAVC FROM CDADOS ORDER BY 1 INTO CURSOR CVER

FOR i = 1 TO 3
   cFil = IIF( i = 3, '04', '0'+TRANSFORM(i) )
   SELECT CVER
   SCAN ALL
      IF NOT LTAB( 'FILIAL="' +cFil+ '" AND DIAVC='+TRANSFORM(DIAVC), 'CDADOS' )
         INSERT INTO CDADOS ( FILIAL, DIAVC) VALUES ( cFil, CVER.DIAVC )
      ENDIF
   ENDSCAN 
ENDFOR  

SELECT      DIAVC,;
            SUM(IIF(FILIAL='01',valor,$0)) FIL01,;
            SUM(IIF(FILIAL='02',valor,$0)) FIL02,;
            SUM(IIF(FILIAL='04',valor,$0)) FIL04 ;
FROM        CDADOS ;
GROUP BY    1 ;
ORDER BY    1 ;
INTO CURSOR CVER

\
SCAN all
   \<<PADL(' dia vcto: '+TRAN(DIAVC,'99'),37)+'  '>>
   \\ <<TRANSFORM(FIL01,'999,999,999.99')>> | <<TRANSFORM(FIL02,'999,999,999.99')>> | <<TRANSFORM(FIL04,'999,999,999.99')>>
ENDSCAN 




***********************************************************************************************

SELECT      TOP 25 ;
            aa.idContrato           IDCONTRATO,;
            bb.tipo_parcela         TPPARC,;
            bb.tipo_Contrato        TPCONTR, ;
            aa.idFilial             FILIAL,;
            bb.nome_responsavel     N_O_M_E,;
            bb.nrovidas             VIDAS,;
            aa.valor_documento      VALOR;
            ;
FROM        ARECEBER aa ;
JOIN        CONTRATO bb ON aa.idContrato == bb.idContrato ;
WHERE       aa.data_vencimento BETWEEN dIni AND dFim ;
        AND LEFT(bb.tipo_contrato,3) IN ( 'FAM', 'LAR' ) ;
        AND bb.tipo_parcela ='MENSAL' ;
ORDER BY    aa.valor_documento DESC ;
INTO CURSOR CVER




\
\
\ **** TOP 25 MENSAL p/ VALOR FATURADO
\FIL NOME                                                        VIDAS      VALOR FAT.
\=== ========================================================== =======  ==============
SCAN ALL
   \<<FILIAL>>  <<N_O_M_E>> <<TRANSFORM(VIDAS,'99999')>> <<TRANSFORM(VALOR,'999,999,999.99')>>
ENDSCAN 






SET TEXTMERGE OFF
SET TEXTMERGE TO


CLOSE DATABASES all
CLOSE TABLES 
CLEAR
_ClipText = cXXX