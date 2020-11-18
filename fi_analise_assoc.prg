FUNCTION FI_ANALISE_ASSOC( cWhe, cApura, cAlsRet )
*LPARAMETERS cWhe, cApura, cAlsRet
* cWhe = Condição
* cApura: A) Situacao geral                        
*         B) ATIVO(s)                              
*         C) PERMANENCIA EM DIAS DOS ATIVO(s)      
*         D) CIDADE DOS ATIVO(s)                   
*         E) CIDADE/BAIRRO DOS ATIVO(s)            
*         F) CANCELADO(s) MOTIVO                   
*         G) PERMANENCIA EM DIAS DOS CANCELADOS(s) 
*         H) CIDADE DOS CANCELADO(s)               
*         I) CIDADE/BAIRRO  DOS CANCELADO(s)               
*         J) SEXO ATIVO(s)
*         K) SEXO CANCELADO(s)
*         L) FAIXA ETARIA ATIVO(s)
*         M) FAIXA ETARIA CANCELADO(s)
* cAlsRet - alias de retorno



Local cWhe, i, nSel,  cSql, cTmpBS, nqATIVO, nQCANC, nvATIVO, nvCANC
LOCAL aOpen[1], x, laClosed[1]

nSel = SELECT()

=AUSED( aOpen )
cWhe    = IIF( TYPE('cWhe')    = 'C', cWhe, '(1=1)' ) 
cAlsRet = IIF( TYPE('cAlsRet') = 'C', cAlsRet, 'RST_'+SYS(2015) )
cApura  = UPPER( IIF( TYPE('cApura')  = 'C', cApura, '*' ) )
nqATIVO = 0
nqCANC  = 0

nVATIVO = 0
nVCANC  = 0

cAls_A = 'A_'+SYS(2015)
cAls_B = 'B_'+SYS(2015)
cAls_C = 'C_'+SYS(2015)
cAls_D = 'D_'+SYS(2015)
cAls_E = 'E_'+SYS(2015)
cAls_F = 'F_'+SYS(2015)
cAls_G = 'G_'+SYS(2015)
cAls_H = 'H_'+SYS(2015)
cAls_I = 'I_'+SYS(2015)
cAls_J = 'J_'+SYS(2015)
cAls_K = 'K_'+SYS(2015)
cAls_L = 'L_'+SYS(2015)
cAls_M = 'M_'+SYS(2015)


SELECT     ;
            aa.situacao as quebra, COUNT(*) as qtd ; 
FROM        ASSOCIADO aa ;
JOIN        CONTRATO cc ON cc.idContrato = aa.idContrato ;
WHERE       &cWhe. ; 
GROUP BY 1  ; 
INTO CURSOR LV_ANALISE

LOCATE FOR quebra = 'ATIVO'
IF FOUND()
   nqATIVO = qtd
ENDIF 
LOCATE FOR quebra = 'CANC'
IF FOUND()
   nqCANC = qtd
ENDIF 


SELECT    aa.idAssoc, SUM(pp.valor) as vValor ;
FROM      ASSOCIADO_PLANO pp ;
JOIN      ASSOCIADO aa ON aa.idAssoc=pp.idAssoc ;
JOIN      CONTRATO cc ON cc.idContrato = aa.idContrato ;
WHERE     &cWhe. ;
GROUP BY  1 ;
INTO CURSOR LV_VERVALOR

SELECT     ;
            aa.situacao as quebra, SUM(NVL(bb.vValor,000000000.00)) as vlr ; 
FROM        ASSOCIADO aa ;
JOIN        CONTRATO cc ON cc.idContrato = aa.idContrato ;
LEFT JOIN   LV_VERVALOR bb ON bb.idAssoc = aa.idAssoc ;
WHERE       &cWhe.; 
GROUP BY 1  ; 
INTO CURSOR LV_ANALISE


LOCATE FOR quebra = 'ATIVO'
IF FOUND()
   nvATIVO = vlr
ENDIF 
LOCATE FOR quebra = 'CANC'
IF FOUND()
   nvCANC = vlr
ENDIF 



IF cApura == '*' OR 'M' $ cApura OR 'L' $ cApura 

   SELECT     ;
               aa.situacao, IIF( EMPTY(aa.data_nascimento) OR aa.data_nascimento>DATE(), 'ZZZ', CalcIdade( aa.data_nascimento, DATE(), 'AAA' ) ) as IDADE, COUNT(1) as qtd ; 
   FROM        ASSOCIADO aa ;
   JOIN        CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE       &cWhe.; 
   GROUP BY    1,2  ; 
   INTO CURSOR LV_ANALISE

   IF cApura == '*' OR 'L' $ cApura 
      SELECT    'ATIV) Idade entre 000 e 009' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIVO' and idade between '000' and '009' ;
      UNION ALL ;
      SELECT    'ATIV) Idade entre 010 e 019' as quebra, SUM(qtd) as qtd;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIV' and idade between '010' and '019' ;
      UNION ALL ;
      SELECT    'ATIV) Idade entre 020 e 029' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIV' and idade between '020' and '029' ;
      UNION ALL ;
      SELECT    'ATIV) Idade entre 030 e 039' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIV' and idade between '030' and '039' ;
      UNION ALL ;
      SELECT    'ATIV) Idade entre 040 e 049' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIV' and idade between '040' and '049' ;
      UNION ALL ;
      SELECT    'ATIV) Idade entre 050 e 059' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIV' and idade between '050' and '059' ;
      UNION ALL ;
      SELECT    'ATIV) Idade entre 060 e 069' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIV' and idade between '060' and '069' ;
      UNION ALL ;
      SELECT    'ATIV) Idade entre 070 e 079' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIV' and idade between '070' and '079' ;
      UNION ALL ;
      SELECT    'ATIV) Idade entre 080 e 999' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIV' and idade between '080' and '999' ;
      UNION ALL ;
      SELECT    'ATIV) Idade inconsistente  ' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='ATIV' and idade ='ZZZ' ;
      INTO CURSOR (cAls_L)

      SELECT       *, PADR( REPLICATE( '|', ((qtd/(nqATIVO) )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/(nqATIVO))*100),'999.99%'))+')' ,100 )  as xGrf ;
      FROM        (cAls_L);
      INTO CURSOR (cAls_L)

   ENDIF 

   IF cApura == '*' OR 'M' $ cApura 
      SELECT    'CANC) Idade entre 000 e 009' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade between '000' and '009' ;
      UNION ALL ;
      SELECT    'CANC) Idade entre 010 e 019' as quebra, SUM(qtd) as qtd;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade between '010' and '019' ;
      UNION ALL ;
      SELECT    'CANC) Idade entre 020 e 029' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade between '020' and '029' ;
      UNION ALL ;
      SELECT    'CANC) Idade entre 030 e 039' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade between '030' and '039' ;
      UNION ALL ;
      SELECT    'CANC) Idade entre 040 e 049' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade between '040' and '049' ;
      UNION ALL ;
      SELECT    'CANC) Idade entre 050 e 059' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade between '050' and '059' ;
      UNION ALL ;
      SELECT    'CANC) Idade entre 060 e 069' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade between '060' and '069' ;
      UNION ALL ;
      SELECT    'CANC) Idade entre 070 e 079' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade between '070' and '079' ;
      UNION ALL ;
      SELECT    'CANC) Idade entre 080 e 999' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade between '080' and '999' ;
      UNION ALL ;
      SELECT    'CANC) Idade inconsistente  ' as quebra, SUM(qtd) as qtd ;
      FROM      LV_ANALISE ;
      WHERE     situacao='CANC' and idade ='ZZZ' ;
      INTO CURSOR (cAls_M)

      SELECT       *, PADR( REPLICATE( '|', ((qtd/(nqCANC) )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/(nqCANC))*100),'999.99%'))+')' ,100 )  as xGrf ;
      FROM        (cAls_M);
      INTO CURSOR (cAls_M)

   ENDIF 
   
ENDIF

USE IN (SELECT('LV_ANALISE')) 

IF cApura == '*' OR 'G' $ cApura 

   SELECT    ;
             'CANC) PERMANENCIA ate    30d        ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='CANC' AND (aa.datacancela-cc.database) <= 30 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'CANC) PERMANENCIA entre  31d a  90d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='CANC' AND (aa.datacancela-cc.database) between 31 AND 90 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'CANC) PERMANENCIA entre  91d a 180d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='CANC' AND (aa.datacancela-cc.database) between 91 AND 180 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'CANC) PERMANENCIA entre 181d a 365d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='CANC' AND (aa.datacancela-cc.database) between 181 AND 365 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'CANC) PERMANENCIA entre 366d a 730d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='CANC' AND (aa.datacancela-cc.database) between 366 AND 730 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'CANC) PERMANENCIA maior que   730d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='CANC' AND (aa.datacancela-cc.database) > 730 ; 
   GROUP BY  1 ;
   INTO CURSOR (cAls_G)

   SELECT *, PADR( REPLICATE( '|', ((qtd/nqCANC )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqCANC )*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM (cAls_G);
   INTO CURSOR (cAls_G)

ENDIF 


IF cApura == '*' OR 'C' $ cApura 

   SELECT    ;
             'ATIV) PERMANENCIA ate    30d        ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='ATIV' AND (aa.database-cc.dataBase) BETWEEN 000 AND 30 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'ATIV) PERMANENCIA entre  31d a  90d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='ATIV' AND (aa.database-cc.dataBase) between 31 AND 90 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'ATIV) PERMANENCIA entre  91d a 180d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='ATIV' AND (aa.database-cc.dataBase) between 91 AND 180 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'ATIV) PERMANENCIA entre 181d a 365d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='ATIV' AND (aa.database-cc.dataBase) between 181 AND 365 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'ATIV) PERMANENCIA entre 366d a 730d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='ATIV' AND (aa.database-cc.dataBase) between 366 AND 730 ; 
   GROUP BY  1 ;
   UNION ALL ;
   SELECT    ;
             'ATIV) PERMANENCIA maior que   730d ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='ATIV' AND (aa.database-cc.dataBase) > 730 ; 
   GROUP BY  1 ;
   INTO CURSOR (cAls_C)


   SELECT * FROM (cAls_C) UNION ALL ;
   SELECT    ;
             'ATIV) dtBase Assoc < dtBase Contr. ' as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idcontrato ;
   WHERE     &cWhe. AND aa.situacao='ATIV' AND (aa.database-cc.dataBase) < 000 ; 
   GROUP BY  1 ;
   INTO CURSOR (cAls_C)


   SELECT *, PADR( REPLICATE( '|', ((qtd/nqATIVO )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqATIVO )*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM        (cAls_C);
   INTO CURSOR (cAls_C)

ENDIF 


IF cApura == '*' OR 'F' $ cApura 
   SELECT    ;
             aa.motivocancel as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE     &cWhe. AND aa.situacao='CANC' ; 
   GROUP BY  1 ;
   INTO CURSOR (cAls_F)

   SELECT *, PADR( REPLICATE( '|', ((qtd/nqCANC )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqCANC )*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM (cAls_F);
   INTO CURSOR (cAls_F)
ENDIF 



IF cApura == '*' OR 'B' $ cApura 
   SELECT    ;
             ALLTRIM(aa.situacao)+' '+ IIF( aa.atendimento,'       ', 'S/Atend') as quebra , COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE     &cWhe. AND aa.situacao='ATIVO' ; 
   GROUP BY 1 ;
   INTO CURSOR (cAls_B)

   SELECT *, PADR( REPLICATE( '|', ((qtd/nqATIVO )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqATIVO )*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM (cAls_B);
   INTO CURSOR (cAls_B)
ENDIF 


IF cApura == '*' OR 'D' $ cApura 
   SELECT      ;
               aa.cidade as quebra, COUNT(*) as qtd ; 
   FROM        ASSOCIADO aa ;
   JOIN        CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE       &cWhe. AND aa.situacao='ATIVO' ; 
   GROUP BY    1 ;
   INTO CURSOR (cAls_D)

   SELECT *, PADR( REPLICATE( '|', ((qtd/nqATIVO )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqATIVO )*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM       (cAls_D);
   INTO CURSOR (cAls_D)
ENDIF 


IF cApura == '*' OR 'H' $ cApura 
   SELECT      ;
               aa.cidade as quebra, COUNT(*) as qtd ; 
   FROM        ASSOCIADO aa ;
   JOIN        CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE       &cWhe. AND aa.situacao='CANC' ; 
   GROUP BY    1 ;
   INTO CURSOR (cAls_H)

   SELECT *, PADR( REPLICATE( '|', ((qtd/nqCANC )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqCANC )*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM        (cAls_H);
   INTO CURSOR (cAls_H)
ENDIF 


IF cApura == '*' OR 'E' $ cApura 
   SELECT      ;
               ALLTRIM(aa.cidade)+': '+aa.bairro as quebra, COUNT(*) as qtd ; 
   FROM        ASSOCIADO aa ;
   JOIN        CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE       &cWhe. AND aa.situacao='ATIVO' ; 
   GROUP BY    aa.cidade, aa.bairro ;
   INTO CURSOR (cAls_E)


   SELECT *, PADR( REPLICATE( '|', ((qtd/nqATIVO )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqATIVO )*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM       (cAls_E);
   INTO CURSOR (cAls_E)
ENDIF 


IF cApura == '*' OR 'I' $ cApura 
   SELECT      ;
               ALLTRIM(aa.cidade)+': '+aa.bairro as quebra, COUNT(*) as qtd ; 
   FROM        ASSOCIADO aa ;
   JOIN        CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE       &cWhe. AND aa.situacao='CANC' ; 
   GROUP BY    aa.cidade, aa.bairro ;
   INTO CURSOR (cAls_I)


   SELECT *, PADR( REPLICATE( '|', ((qtd/nqCANC )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqCANC )*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM       (cAls_I);
   INTO CURSOR (cAls_I)
ENDIF 




IF cApura == '*' OR 'J' $ cApura 
   SELECT      ;
               PADR( ALLTRIM(aa.situacao)+': '+IIF(LEFT(aa.sexo,1)='M', 'Masculino',IIF(LEFT(aa.sexo,1)='F','Feminino', '?')),50) as quebra, COUNT(*) as qtd ; 
   FROM        ASSOCIADO aa ;
   JOIN        CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE       &cWhe. AND aa.situacao='ATIV' ; 
   GROUP BY    aa.situacao, aa.sexo;
   INTO CURSOR (cAls_J)

   SELECT *, PADR( REPLICATE( '|', ((qtd/nqATIVO )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqATIVO)*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM       (cAls_J);
   INTO CURSOR (cAls_J)
ENDIF 

IF cApura == '*' OR 'K' $ cApura 
   SELECT      ;
               PADR( ALLTRIM(aa.situacao)+': '+IIF(LEFT(aa.sexo,1)='M', 'Masculino',IIF(LEFT(aa.sexo,1)='F','Feminino', '?')),50) as quebra, COUNT(*) as qtd ; 
   FROM        ASSOCIADO aa ;
   JOIN        CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE       &cWhe. AND aa.situacao='CANC' ; 
   GROUP BY    aa.situacao, aa.sexo;
   INTO CURSOR (cAls_K)

   SELECT *, PADR( REPLICATE( '|', ((qtd/nqCANC )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/nqCANC )*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM       (cAls_K);
   INTO CURSOR (cAls_K)
ENDIF 


IF cApura == '*' OR 'A' $ cApura 
   SELECT    ;
             aa.situacao as quebra, COUNT(*) as qtd ; 
   FROM      ASSOCIADO aa ;
   JOIN      CONTRATO cc ON cc.idContrato = aa.idContrato ;
   WHERE     &cWhe.; 
   GROUP BY 1 ;
   INTO CURSOR (cAls_A)

   SELECT *, PADR( REPLICATE( '|', ((qtd/(nqATIVO+nqCANC) )*50) )+' ( '+ALLTRIM(TRANSFORM(((qtd/(nqATIVO+nqCANC))*100),'999.99%'))+')' ,100 )  as xGrf ;
   FROM (cAls_A);
   INTO CURSOR (cAls_A)

ENDIF 





SELECT 'A' as aba, IIF( RECNO()=1,'A) Situacao geral                       ','') as Titulo, * ;
FROM  (cAls_A) ;
INTO CURSOR (cAlsRet)

IF cApura == '*' OR 'B' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'B' as aba, IIF( RECNO()=1,'B) ATIVO(s)                             ','') as Titulo, * ;
   FROM  (cAls_B) ;
   into cursor (cAlsRet)
ENDIF 

IF cApura == '*' OR 'C' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'C' as aba, IIF( RECNO()=1,'C) PERMANENCIA EM DIAS DOS ATIVO(s)     ','') as Titulo, * ;
   FROM  (cAls_C) ;
   into cursor (cAlsRet)
ENDIF 
  
IF cApura == '*' OR 'D' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'D' as aba, IIF( RECNO()=1,'D) CIDADE DOS ATIVO(s)                  ','') as Titulo, * ;
   FROM  (cAls_D) ;
   into cursor (cAlsRet)
ENDIF
   
IF cApura == '*' OR 'E' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'E' as aba, IIF( RECNO()=1,'E) CIDADE/BAIRRO DOS ATIVO(s)           ','') as Titulo, * ;
   FROM  (cAls_E) ;
   into cursor (cAlsRet)
ENDIF
  
IF cApura == '*' OR 'F' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'F' as aba, IIF( RECNO()=1,'F) CANCELADO(s) MOTIVO                  ','') as Titulo, * ;
   FROM  (cAls_F) ;
   into cursor (cAlsRet)
ENDIF

IF cApura == '*' OR 'G' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'G' as aba, IIF( RECNO()=1,'G) PERMANENCIA EM DIAS DOS CANCELADOS(s)','') as Titulo, * ;
   FROM  (cAls_G);
   INTO CURSOR (cAlsRet) 
endif 

IF cApura == '*' OR 'H' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'H' as aba, IIF( RECNO()=1,'H) CIDADE DOS CANCELADO(s)               ','') as Titulo, * ;
   FROM  (cAls_H) ;
   INTO CURSOR (cAlsRet) 
endif 
   
IF cApura == '*' OR 'I' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'I' as aba, IIF( RECNO()=1,'I) CIDADE/BAIRRO DOS CANCELADO(s)        ','') as Titulo, * ;
   FROM        (cAls_I);
   INTO CURSOR (cAlsRet) 
ENDIF 

IF cApura == '*' OR 'J' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'J' as aba, IIF( RECNO()=1,'J) SEXO ATIVO(s)                         ','') as Titulo, * ;
   FROM        (cAls_J);
   INTO CURSOR (cAlsRet) 
ENDIF 

IF cApura == '*' OR 'K' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'K' as aba, IIF( RECNO()=1,'K) SEXO CANCELADO(s)                     ','') as Titulo, * ;
   FROM        (cAls_K);
   INTO CURSOR (cAlsRet) 
ENDIF 


IF cApura == '*' OR 'L' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'L' as aba, IIF( RECNO()=1,'L) FAIXA ETARIA ATIVO(s)                 ','') as Titulo, * ;
   FROM        (cAls_L);
   INTO CURSOR (cAlsRet) 
ENDIF 

IF cApura == '*' OR 'M' $ cApura 
   SELECT * FROM (cAlsRet) ;
   UNION ALL ;
   SELECT 'M' as aba, IIF( RECNO()=1,'L) FAIXA ETARIA CANCELADO(s)             ','') as Titulo, * ;
   FROM        (cAls_M);
   INTO CURSOR (cAlsRet) 
ENDIF 

For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      IF NOT cAlsRet == laClosed[x,1]
            Use In (laClosed[x,1])
      endif
   Endif
NEXT

SELECT (nSel)

RETURN (cAlsRet)

