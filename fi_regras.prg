#DEFINE DF_PLANO_MEDICA_MAIS  3

LPARAMETERS cChv, dRef, lDispNegativo

lDispNegativo = IIF( TYPE( 'lDispNegativo' ) = 'L', lDispNegativo, .f. )

LOCAL dIni, cIni, cFim, cCodAssoc, nNroMeses, nNroConsultas, nNivelCobranca, nCtrl, cChvSM, nSel, nDisp, nPosATEND
LOCAL aTmp[1], aDep[1], dFim
LOCAL oRtn as Object, lUsaATD, lUsaHST, lUsaCTR, nComCob, nSele, lUsaGRT, dVigencia, cNivelCobranca, nUtilizado

dRef  = IIF( TYPE('dRef')$'D', dRef, DATE() )
nSele = SELECT()

lUsaATD = USED( 'ATENDIMENTO' )
lUsaHST = USED( 'HSTATEND' )
lUsaCTR = USED( 'CONTRATO' )
lUsaGRT = USED( 'CONTRATO_GARANTIAS' )

IF NOT lUsaATD
   USE ATENDIMENTO IN 0
ENDIF

IF NOT lUsaHST
   USE HSTATEND IN 0
ENDIF

IF NOT lUsaGRT
   USE CONTRATO_GARANTIAS IN 0
ENDIF

IF NOT lUsaCTR
   USE CONTRATO IN 0
ENDIF

oRtn = CREATEOBJECT( 'Relation' )
oRtn.AddProperty( 'VIGENCIA' )
oRtn.AddProperty( 'NROMESES' )
oRtn.AddProperty( 'NroConsultas' )
oRtn.AddProperty( 'Com_Cobranca' )
oRtn.AddProperty( 'NivelCobranca' )
oRtn.AddProperty( 'Permitidas' )
oRtn.AddProperty( 'Utilizadas' )
oRtn.AddProperty( 'Disponiveis' )

oRtn.VIGENCIA      = {}
oRtn.NROMESES      = 0
oRtn.NroConsultas  = 0
oRtn.Com_Cobranca  = 0
oRtn.NivelCobranca = ''
oRtn.Permitidas    = 0
oRtn.Utilizadas    = 0
oRtn.Disponiveis   = 0

IF SUBSTR(cChv,11,2) = 'CT'
   PTAB( LEFT(cChv,10)+'CT', 'CONTRATO', 'CODIGO' )
   nCtrl = CONTRATO.idContrato
ELSE   
   =PTAB( ALLTRIM(cChv), 'ASSOCIADO', 'CODIGO' )
   nCtrl = ASSOCIADO.idContrato
ENDIF

IF FI_TEM_PROD_GARANTIA( cChv )

   SELECT      CONTRATO_GARANTIAS.fm_Vigencia, ;        &&  001
               CONTRATO_GARANTIAS.fm_NroMeses, ;        &&  002
               CONTRATO_GARANTIAS.fm_NroConsultas, ;    &&  003
               CONTRATO_GARANTIAS.fm_NivelCobranca, ;   &&  004
               CONTRATO.NroVidas, ;                     &&  005
               CONTRATO.tipo_Contrato ;                 &&  006
   FROM        CONTRATO_GARANTIAS ;
   INNER JOIN  CONTRATO ON CONTRATO_GARANTIAS.idContrato == CONTRATO.idContrato ;
   WHERE       CONTRATO_GARANTIAS.idContrato == nCtrl AND ;
               INLIST(CONTRATO_GARANTIAS.idProd,3,18,23) ;
   INTO CURSOR CLV_ARG_GRT

	IF _TALLY > 0
	   
	   cChvSM = cChv

	   nComCob        = 0
      
	   dVigencia      = CLV_ARG_GRT.fm_Vigencia
	   oRtn.Vigencia  = CLV_ARG_GRT.fm_Vigencia
	   
	   nNroMeses      = CLV_ARG_GRT.fm_NroMeses
	   oRtn.NroMeses  = CLV_ARG_GRT.fm_NroMeses
	   
	   nNroConsultas     = CLV_ARG_GRT.fm_NroConsultas
	   oRtn.NroConsultas = CLV_ARG_GRT.fm_NroConsultas

	   cNivelCobranca     = CLV_ARG_GRT.fm_NivelCobranca
	   oRtn.NivelCobranca = cNivelCobranca
	  
	   IF cNivelCobranca = "CONTRATO"
	   
	      if ( LEFT( CLV_ARG_GRT.tipo_Contrato, 8 ) # 'AREA PRO' OR LEFT( CLV_ARG_GRT.tipo_Contrato, 8 ) # 'REMOÇÃO ' ) ;
            AND  ;
	         !( LEFT( CLV_ARG_GRT.tipo_Contrato, 7 ) $ 'CLIENTE,BENEMÉR' )
	         
            IF LEFT( CLV_ARG_GRT.tipo_Contrato, 8 ) = 'AREA PRO'
               nNroConsultas = nNroConsultas
            ELSE
   	         nNroConsultas = ( nNroConsultas * CLV_ARG_GRT.NroVidas )
            ENDIF
	         
	      ENDIF
	      
	   ELSE
	   
	      cChvSM = LEFT(cChvSM,10)
	      
	      SELECT     COUNT(*) ;
	      FROM       ASSOCIADO dd ;
	      WHERE      dd.codigo = cChvSM AND dd.situacao = 'ATIVO' AND dd.atendimento=.t. ;
	      INTO ARRAY aDep
	      
         ** nNroConsultas = ( nNroConsultas * ( aDep(1) + 1  ) )
	      nNroConsultas = ( nNroConsultas * ( aDep(1) ) )
	      
	   ENDIF

	   USE IN ( SELECT( 'CLV_ARG_GRT' ) )

	   nUtilizado =0

	   IF !EMPTY(dVigencia)
	   
	      IF ( dRef - dVigencia ) < 365
	         dIni = dVigencia
	      ELSE
	         IF MONTH(dRef) > MONTH(dVigencia)
	            dIni = DATE( YEAR(dRef), MONTH(dVigencia), DAY(dVigencia) )
	         ELSE
	            dIni = DATE( YEAR(dRef)-1, MONTH(dVigencia), DAY(dVigencia) )
	         ENDIF
	      
	      ENDIF
	      IF dIni < dVigencia
	         dIni = dVigencia
	      ENDIF

	      dFim = DATE( YEAR(dIni)+1, MONTH(dVigencia), DAY(dVigencia) )

	      cIni = DTOS( dIni ) 
	      cFim = DTOS( dFim ) 
	      
	      nUtilizado = 0
	      nComCob    = 0
      
	      WAIT WINDOW 'Verificando regras #1' NOWAIT NOCLEAR 
	      IF PTAB( LEFT( cChv, 10 ), 'ATENDIMENTO', 'CODIGO', .t. )
	     
	         SELECT ATENDIMENTO
	         SCAN WHILE LEFT(ATENDIMENTO.paccodigo,10) == LEFT(cChv,10)
	         
	            IF ATENDIMENTO.situacao  == 2 AND ;                 && ENCERRADO
	               ATENDIMENTO.liberacao == 2 AND ;                 && LIBERADO
	               ATENDIMENTO.medclassificacao = 'CONS' AND ;  && CLASSIFICADO PELO MEDICO
	               EMPTY(ATENDIMENTO.idcancelamento) AND ;          && NAO ESTA CANCELADO
	               BETWEEN( DTOS(ATENDIMENTO.tm_chama), cIni,cFim ) && DENTRO DO PERIODO
	               
	               nUtilizado = nUtilizado + 1
	               nComCob = nComCob + IIF( ATENDIMENTO.valorcobranca # $0, 1, 0 )
	               
	            ENDIF
	         ENDSCAN
	         
	      ENDIF
	      	      
	      WAIT WINDOW 'Verificando regras #2' NOWAIT NOCLEAR 

	      IF PTAB( LEFT( cChv, 10 ), 'HSTATEND', 'PACCODIGO', .t. )

	         SELECT HSTATEND
	         SCAN WHILE LEFT(HSTATEND.paccodigo,10) == LEFT(cChv,10)
	         
	            IF HSTATEND.situacao  == 2 AND ;                 && ENCERRADO
	               HSTATEND.liberacao == 2 AND ;                 && LIBERADO
	               HSTATEND.medclassificacao = 'CONS' AND ;  && CLASSIFICADO PELO MEDICO
	               EMPTY(HSTATEND.idcancelamento) AND ;          && NAO ESTA CANCELADO
	               BETWEEN( DTOS(HSTATEND.tm_chama), cIni,cFim ) && DENTRO DO PERIODO

	               nUtilizado = nUtilizado + 1
	               nComCob = nComCob + IIF( HSTATEND.valorcobranca # $0, 1, 0 )
	               
	            ENDIF
	         ENDSCAN

	      ENDIF
	      
	      WAIT CLEAR 
	     
	   endif

	   IF lDispNegativo
	      nDisp = ( nNroConsultas-nUtilizado )
	   ELSE
	      nDisp = IIF( nNroConsultas-nUtilizado < 0, 0, nNroConsultas-nUtilizado )
	   ENDIF

	   oRtn.Com_Cobranca  = nComCob
	   oRtn.Permitidas    = nNroConsultas 
	   oRtn.Utilizadas    = nUtilizado 
	   oRtn.Disponiveis   = nDisp 
   
   ENDIF   
   
ENDIF

IF NOT lUsaCTR
   USE IN ( SELECT( 'CONTRATO' ) )
ENDIF

IF NOT lUsaGRT
   USE IN ( SELECT( 'CONTRATO_GARANTIAS' ) )
ENDIF


IF NOT lUsaHST
   USE IN ( SELECT( 'HSTATEND' ) )
ENDIF

IF NOT lUsaATD
   USE IN ( SELECT( 'ATENDIMENTO' ) )
ENDIF

SELECT(nSele)

RETURN oRtn




FUNCTION FI_TEM_PROD_GARANTIA( cKey )
LOCAL nID as Integer, lTemMedMais as Boolean, nSele as Integer

nSele = SELECT()

lTemMedMais = .t.

IF PTAB( cKey, 'ASSOCIADO', 'CODIGO' )

   nID = ASSOCIADO.idAssoc
   
   SELECT      idPlano ;
   FROM        ASSOCIADO_PLANO ;
   WHERE       idAssoc == nID AND ;
               INLIST(idPlano,3,18,23) ;
   INTO CURSOR CLV_VER_MED_MAIS

   lTemMedMais = (_Tally>0)

ENDIF   

USE IN ( SELECT( 'CLV_VER_MED_MAIS' ) )

SELECT (nSele)

RETURN lTemMedMais 

ENDFUNC