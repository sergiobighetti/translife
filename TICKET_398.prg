CLOSE DATABASES all

cPrn  = SYS(2015)
* cWhe = Thisform.fi_where()
cWhe = "tt.idtransp>=4057 AND tt.FAT_CODIGO='05CL038992CT'"
SELECT  ;
           tt.fat_codigo;
         , tt.fat_NOME;
         , TT.SITUACAO;
         , tt.idtransp ;
         , tt.data_transporte;
         , '?' as Guia;
         , fi_INFATD( tt.idTransp,'paccodorigem')   as CodUsuario;
         , pp.nomepacien  as paciente;
         , '?' as Origem;
         , '?' as Destino;
         , '?' as Diagnostico;
         , tt.tipo_transporte;
         , fi_INFATD( tt.idTransp,'tm_chama'  )     as AbertAtend;
         , fi_INFATD( tt.idTransp,'tm_nloca'  )     as tm_nolocal;
         , fi_INFATD( tt.idTransp,'tm_sloca'  )     as tm_slocal;
         , fi_INFATD( tt.idTransp,'tm_rnloca' )     as tm_rnolocal;
         , fi_INFATD( tt.idTransp,'tm_rsloca' )     as tm_rslocal;
         , fi_INFATD( tt.idTransp,'tm_retor', .f. ) as EncerraAtend ;
         , tt.km_quant as km ;
         , IIF( tt.km_quant> 0,(tt.valor_inicial/tt.km_quant), tt.km_quant ) as km_valor;
         , tt.pedagio ;
         , tt.extras ;
         , tt.hrp_quant ;
         , tt.hrp_valor ;
         , tt.desconto ;
         , tt.acrescimo;
         , NVL(fi_INFMED(tt.idtransp,'CHEGADAMEDICO'),CTOT('')) HR_MEDICO_DE;
         , '' HR_MEDICO_ATE;
         , NVL(fi_INFMED(tt.idtransp,'VALOR'),000000000.00)   HR_MEDICO_TOTAL;
         , '0.00' as TX_Psquiatra50p;
         , 0.000 as TotalHRM;
         , 0.000 as TotalRemoção; 
         , NVL(fi_INFATD( tt.idTransp,'MEDICO'),SPACE(40)) as MEDICO_NOME;
         , tt.fat_forma;
         , NVL(fi_INFMED(tt.idtransp,'TPTRABALHO'),SPACE(10)) as EQP_TIPO;
FROM       TRANSP tt ;
JOIN      TRANSP_PACIENTE pp    ON pp.idtransp=tt.idTransp ;
JOIN      CONTRATO cc           ON cc.codigo ==tt.fat_codigo ;
WHERE     &cWhe. ;
INTO CURSOR (cPrn)



*!*   SELECT  distinct ;
*!*             tt.fat_codigo;
*!*            , tt.fat_NOME;
*!*            , TT.SITUACAO;
*!*            ,  tt.idtransp ;
*!*            , tt.data_transporte;
*!*            ,'?' as Guia;
*!*            ,fi_INFATD( tt.idTransp,'paccodorigem')   as CodUsuario;
*!*            ,pp.nomepacien  as paciente;
*!*            ,'?' as Origem;
*!*            ,'?' as Destino;
*!*            ,'?' as Diagnostico;
*!*            ,tt.tipo_transporte;
*!*            ,fi_INFATD( tt.idTransp,'tm_chama'  )     as AbertAtend;
*!*            ,fi_INFATD( tt.idTransp,'tm_nloca'  )     as tm_nolocal;
*!*            ,fi_INFATD( tt.idTransp,'tm_sloca'  )     as tm_slocal;
*!*            ,fi_INFATD( tt.idTransp,'tm_rnloca' )     as tm_rnolocal;
*!*            ,fi_INFATD( tt.idTransp,'tm_rsloca' )     as tm_rslocal;
*!*            ,fi_INFATD( tt.idTransp,'tm_retor', .f. ) as EncerraAtend ;
*!*            ,tt.km_quant as km ;
*!*            ,IIF( tt.km_quant> 0,(tt.valor_inicial/tt.km_quant), tt.km_quant ) as km_valor;
*!*            ,tt.pedagio ;
*!*            ,tt.extras ;
*!*            ,tt.hrp_quant ;
*!*            ,tt.hrp_valor ;
*!*            ,tt.desconto ;
*!*            ,tt.acrescimo;
*!*            ,NVL(fi_INFMED(tt.idtransp,'CHEGADAMEDICO'),CTOT('')) HR_MEDICO_DE;
*!*            ,'' HR_MEDICO_ATE;
*!*            ,NVL(fi_INFMED(tt.idtransp,'VALOR'),000000000.00)   HR_MEDICO_TOTAL;
*!*            ,'0.00' as TX_Psquiatra50p;
*!*            ,0.000 as TotalHRM;
*!*            ,0.000 as TotalRemoção; 
*!*            ,NVL(fi_INFATD( tt.idTransp,'MEDICO'),SPACE(40)) as MEDICO_NOME;
*!*            ,fat_forma;
*!*            ,NVL(fi_INFMED(tt.idtransp,'TPTRABALHO'),SPACE(10)) as EQP_TIPO;
*!*   FROM      TRANSP tt ;
*!*   JOIN      TRANSP_PACIENTE pp    ON pp.idtransp=tt.idTransp ;
*!*   WHERE tt.idtransp>=4057 AND TT.FAT_CODIGO='05CL038992CT'


FUNCTION fi_INFATD( nIdTransp, cRet, lBotton )
LOCAL nCol,cVer, nSel, cIdTransp
nSel = SELECT()
cVer = SYS(2015)
xRet = .NULL.

cIdTransp = '<T>'+ Transform(nIdTransp,'@L 9999999999') +'</T>'

SELECT     ate.id ;
         , ate.idfilial_atend;
         , ate.codatendimento;
         , ate.km_percurso;
         , ate.regobservacao ;
         , ate.tm_chama ;
         , ate.tm_saida ;
         , ate.tm_nloca ;
         , ate.tm_sloca ;
         , ate.removidopara ;
         , ate.tm_rnloca ;
         , ate.tm_rsloca ;
         , ate.tm_retor ;
         , ate.resumoatendimento ;
         , ate.obsatendimento ;
         , ate.keyold ;
         , ate.paccodorigem ;
         , PADL( Alltrim(Strextract( tt.Observacao,'<COD>','</COD>')), 30 ) as xCod ;
         , NVL( md.nome,rg.nome) as MEDICO ;
FROM        ATENDIMENTO ate ;
JOIN        TRANSP tt ON tt.idtransp = nIdTransp;
LEFT JOIN        EQUIPE rg ON rg.id = ate.idregulador;
LEFT JOIN        EQUIPE md ON md.id = ate.idMedico;
WHERE       ate.keyold  = cIdTransp ;
INTO CURSOR (cVer) ;




SELECT (cVer)
GO TOP 
IF lBotton
   GO BOTTOM 
ENDIF 


xRet = EVALUATE( FIELD(cRet) )

IF EMPTY(xRet) 
   IF UPPER(cRet) = 'PACCODIGO'
      xRet = EVALUATE(FIELD('xCod'))
   ENDIF 
ENDIF 


USE IN (SELECT(cVer))
SELECT (nSel)

RETURN xRet




********************************************************
FUNCTION fi_INFMED( nIdTransp, cRet )
LOCAL nCol,cVer, nSel
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
      xRet = 0000000.00
   CASE UPPER(cRet) = 'CHEGADAMEDICO'
      nCol = 4
      xRet = CTOT('')
ENDCASE

SELECT      NVL(te.tipo_trabalho,SPACE(10)) as tpTrabalho    ;
          , NVL(eq.Nome,SPACE(40))          as NomeMedico    ;
          , te.valor                        as Valor         ;
          , te.hr_chegada                   as ChegadaMedico ;
FROM        TRANSP_EQUIPE te                                 ;
JOIN        EQUIPE eq        ON eq.id = te.idMembro AND eq.tipo IN ( 'MEDICO', 'REGULADOR' ) ;
WHERE       te.idtransp=nIdTransp ;
INTO CURSOR (cVer) ;

SELECT (cVer)
if _Tally > 0

   xRet = EVALUATE( FIELD(nCol) )
ENDIF 
USE IN (SELECT(cVer))
SELECT (nSel)

RETURN xRet