FUNCTION fi_INFMED( nIdTransp, cRet )
LOCAL nCol,cVer, nSel, oReg

nSel = SELECT()
cVer = SYS(2015)
xRet = .NULL.

DO case
   CASE UPPER(cRet) = 'TPTRABALHO'
      nCol = 1
      xRet = SPACE(10)
   CASE UPPER(cRet) = 'NOMEMEDICO'
      nCol = 2
      xRet = SPACE(40)
   CASE UPPER(cRet) = 'VALOR'
      nCol = 3
      xRet = 0000000.0000
   CASE UPPER(cRet) = 'CHEGADAMEDICO'
      nCol = 4
      xRet = CTOT('')
ENDCASE

SELECT      NVL(te.tipo_trabalho,SPACE(10)) as tpTrabalho    ;
          , NVL(eq.Nome,SPACE(40))          as NomeMedico    ;
          , te.valor                        as Valor         ;
          , te.hr_chegada                   as ChegadaMedico ;
FROM        TRANSP_EQUIPE te                                 ;
JOIN        EQUIPE eq        ON eq.id = te.idMembro AND eq.tipo IN ( 'MEDICO' , 'REGULADOR' ) ;
WHERE       te.idtransp=nIdTransp ;
INTO CURSOR (cVer) ;

SELECT (cVer)
IF cRet = '*'  &&-- retorna obj com todos os campos
   SCATTER NAME oReg MEMO 
   xRet = oReg
ELSE 
   if _Tally > 0
      xRet = EVALUATE( FIELD(nCol) )
   ENDIF 
ENDIF 

USE IN (SELECT(cVer))
SELECT (nSel)

RETURN xRet