FUNCTION fi_INFATD( nIdTransp, cRet, lBotton )
LOCAL nCol,cVer, nSel, cIdTransp,oReg,cEnd, oTR
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
         , NVL( di.descricao,SPACE(35)) as DIAGNOSTICO ;
         , ate.pacidade ;
         , ate.pacsexo ;        
FROM             ATENDIMENTO ate ;
JOIN             TRANSP tt ON tt.idtransp = nIdTransp;
LEFT JOIN        EQUIPE rg ON rg.id = ate.idregulador;
LEFT JOIN        EQUIPE md ON md.id = ate.idMedico;
LEFT JOIN        HIPODIAG di ON di.id = ate.idhipotesediag;
WHERE       ate.keyold  = cIdTransp ;
INTO CURSOR (cVer) ;

SELECT (cVer)
GO TOP 
IF lBotton
   GO BOTTOM 
ENDIF 

IF cRet = '*'  && retorna obj com todos os campos

   SCATTER NAME oReg MEMO 
   =ADDPROPERTY( oReg, 'ITINERARIO_DE',      SPACE(240) )
   =ADDPROPERTY( oReg, 'ITINERARIO_PARA',    SPACE(240) )
   =ADDPROPERTY( oReg, 'ITINERARIO_RETORNO', SPACE(240) )
   
   SELECT * FROM transp_itinerario ii WHERE ii.idtransp = nIdTransp INTO CURSOR (cVer)
   SCAN all
      cEnd = '' 
      IF !EMPTY(&cVer..localnome)
         cEnd= cEnd+', ('+ALLTRIM(&cVer..localnome)+')'
      ENDIF  
      IF !EMPTY(&cVer..endereco)
         cEnd= cEnd+', '+ALLTRIM(&cVer..endereco)
      ENDIF  
      IF !EMPTY(&cVer..cidade)
         cEnd= cEnd+', '+ALLTRIM(&cVer..cidade)+'/'+&cVer..uf
      ENDIF  
      DO case
         CASE &cVer..tipo=1
            oReg.ITINERARIO_DE      = ALLTRIM(SUBSTR(cEnd,2))
         CASE &cVer..tipo=2
            oReg.ITINERARIO_PARA    = ALLTRIM(SUBSTR(cEnd,2))
         CASE &cVer..tipo=3
            oReg.ITINERARIO_RETORNO = ALLTRIM(SUBSTR(cEnd,2))
         
      ENDCASE 
   ENDSCAN 

   IF oReg.id>0
      oTR = fi_TRESP( oReg.id, 'MM' )
      IF oTR.temRegistro
         =ADDPROPERTY( oReg, 'TR_TARME',   oTR.TR_TARME )
         =ADDPROPERTY( oReg, 'TR_GASTO',   oTR.TR_GASTO )
         =ADDPROPERTY( oReg, 'TR_DESP',    oTR.TR_DESP )
         =ADDPROPERTY( oReg, 'TR_RESP',    oTR.TR_RESP )
         =ADDPROPERTY( oReg, 'TR_ACIONA',  oTR.TR_ACIONA )
         =ADDPROPERTY( oReg, 'TR_SAIDABS', oTR.TR_SAIDABS )
         =ADDPROPERTY( oReg, 'TR_DESLOCA', oTR.TR_DESLOCA )
         =ADDPROPERTY( oReg, 'TR_ATEND',   oTR.TR_ATEND )
         =ADDPROPERTY( oReg, 'TR_EMPENHO', oTR.TR_EMPENHO )
         =ADDPROPERTY( oReg, 'TR_LOCAL',   oTR.TR_LOCAL )
         =ADDPROPERTY( oReg, 'TR_LIBER',   oTR.TR_LIBER )
         =ADDPROPERTY( oReg, 'TR_TRANS',   oTR.TR_TRANS )
      ENDIF 
   ENDIF 
      
   xRet = oReg

ELSE    

   IF FSIZE(cRet) > 0
      xRet = EVALUATE( FIELD(cRet) )
      IF EMPTY(xRet) 
         IF UPPER(cRet) = 'PACCODIGO'
            xRet = EVALUATE(FIELD('xCod'))
         ENDIF 
      ENDIF 
   ELSE
   
      IF &cVer..id>0 AND OCCURS(UPPER(cRet), ',TR_TARME,TR_GASTO,TR_DESP,TR_RESP,TR_ACIONA,TR_SAIDABS,TR_DESLOCA,TR_ATEND,TR_EMPENHO,TR_LOCAL,TR_LIBER,TR_TRANS' ) > 0
         oTR = fi_TRESP( &cVer..id, 'MM' )
         IF oTR.temRegistro
            =ADDPROPERTY( oReg, UPPER(cRet),   oTR.&cRet. )
         ENDIF 
      ENDIF 
   
   ENDIF 
   
ENDIF 

USE IN (SELECT(cVer))
SELECT (nSel)

RETURN xRet
