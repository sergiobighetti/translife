CLEAR
CLOSE DATABASES all
SET ESCAPE ON
dIni = DATETIME()

SELECT idContrato FROM CONTRATO WHERE idFilial='01' AND situacao='ATIVO' INTO CURSOR LV_FAZER

TEXT TO cLista NOSHOW PRETEXT 15
CONTRATO,
CONTRATO_ANEXO,
CONTRATO_COP,
CONTRATO_ESTATISTICA,
CONTRATO_FEVENTOS,
CONTRATO_FM,
CONTRATO_GARANTIAS,
CONTRATO_HIMPORTA,
CONTRATO_HRATD,
CONTRATO_LANCAMENTO,
CONTRATO_NFSe,
CONTRATO_REGRAS_DISK,
CONTRATO_REGRAS_TRANSP,
CONTRATO_TRA,
CONTRATO_TRASLADO,
ASSOCIADO
ENDTEXT 

* CONTRATO_TRA_ITEM,


nLst = ALINES( aArq, cLista,1,',')
FOR i=1 TO nLst
   cAls = 'LV_'+aArq[i]
   SELECT * FROM (aArq[i]) WHERE idContrato in ( SELECT idContrato FROM CONTRATO WHERE idFilial='01' AND situacao='ATIVO' ) INTO CURSOR &cAls. READWRITE 
   
   IF FSIZE( 'idFilial', cAls ) > 0
      replace ALL idFilial WITH '02'
   ENDIF 
   

NEXT 


SELECT LV_CONTRATO
SCAN all
   cChv    = idFilial  + 'CL'
   cNewCod = NovaChave( idFilial, cChv, 'CT' )
   
   replace fil_cart WITH '02'
   replace oldKey   WITH TRANSFORM(idContrato)+':'+codigo
   replace codigo   WITH cNewCod
   
ENDSCAN 


SELECT CONTRATO
cLstCampo = ''
FOR n=1 TO FCOUNT()
   IF UPPER(FIELD(n))<>'IDCONTRATO'
      cLstCampo = cLstCampo +','+FIELD(n)
   ENDIF 
NEXT 
cLstCampo = SUBSTR(cLstCampo,2)

cCmd = 'APPEND FROM DBF("LV_CONTRATO") FIELDS '+ cLstCampo
&cCmd.


SELECT idContrato,codigo, tipo_contrato, idFilial, oldKey, idContrato as numero ;
FROM   CONTRATO ;
WHERE  oldKey IN (SELECT oldKey FROM LV_CONTRATO ) ;
INTO CURSOR LV_CONTRATO_NEW 


SELECT LV_CONTRATO_NEW 
SCAN all

   nNewCtr = idContrato
   nNewFil = idFilial
   cNewCod = codigo
   nOldCtr = INT(VAL(STREXTRACT( oldKey, '', ':' )))
   
   UPDATE CONTRATO SET numero=nNewCtr WHERE idContrato=nNewCtr 
   
   * -----------------------------------
   SELECT  LV_CONTRATO_ANEXO
   replace idContrato WITH nNewCtr FOR idContrato = nOldCtr
   cLstCampo = ''
   FOR n=1 TO FCOUNT()
      IF NOT UPPER(FIELD(n))=='ID'
         cLstCampo = cLstCampo +','+FIELD(n)
      ENDIF 
   NEXT 
   cLstCampo = SUBSTR(cLstCampo,2)
   SELECT CONTRATO_ANEXO
   cCmd = "APPEND FROM DBF('LV_CONTRATO_ANEXO') FIELDS "+ cLstCampo +" FOR idContrato="+TRANSFORM(nNewCtr)
   &cCmd.
   
   
   * -----------------------------------
   SELECT LV_CONTRATO_COP
   replace idContrato WITH nNewCtr FOR idContrato = nOldCtr
   cLstCampo = ''
   FOR n=1 TO FCOUNT()
      cLstCampo = cLstCampo +','+FIELD(n)
   NEXT 
   cLstCampo = SUBSTR(cLstCampo,2)
   SELECT CONTRATO_COP
   cCmd = "APPEND FROM DBF('LV_CONTRATO_COP') FIELDS "+ cLstCampo +" FOR idContrato="+TRANSFORM(nNewCtr)
   &cCmd.

   
   * -----------------------------------
   SELECT LV_CONTRATO_FEVENTOS
   replace idContrato WITH nNewCtr FOR idContrato = nOldCtr
   cLstCampo = ''
   FOR n=1 TO FCOUNT()
      IF NOT UPPER(FIELD(n))=='ID'
         cLstCampo = cLstCampo +','+FIELD(n)
      ENDIF 
   NEXT 
   cLstCampo = SUBSTR(cLstCampo,2)
   SELECT CONTRATO_FEVENTOS
   cCmd = "APPEND FROM DBF('CONTRATO_FEVENTOS') FIELDS "+ cLstCampo +" FOR idContrato="+TRANSFORM(nNewCtr)
   &cCmd.
   
   * -----------------------------------
   SELECT LV_CONTRATO_FM
   replace idContrato WITH nNewCtr FOR idContrato = nOldCtr
   cLstCampo = ''
   FOR n=1 TO FCOUNT()
      cLstCampo = cLstCampo +','+FIELD(n)
   NEXT 
   cLstCampo = SUBSTR(cLstCampo,2)
   SELECT CONTRATO_FM
   cCmd = "APPEND FROM DBF('LV_CONTRATO_FM') FIELDS "+ cLstCampo +" FOR idContrato="+TRANSFORM(nNewCtr)
   &cCmd.   
   
   * -----------------------------------
   SELECT LV_CONTRATO_NFSe
   replace idContrato WITH nNewCtr FOR idContrato = nOldCtr
   cLstCampo = ''
   FOR n=1 TO FCOUNT()
      cLstCampo = cLstCampo +','+FIELD(n)
   NEXT 
   cLstCampo = SUBSTR(cLstCampo,2)
   SELECT CONTRATO_NFSe
   cCmd = "APPEND FROM DBF('LV_CONTRATO_NFSe') FIELDS "+ cLstCampo +" FOR idContrato="+TRANSFORM(nNewCtr)
   &cCmd.     
     
   * -----------------------------------
   SELECT LV_CONTRATO_REGRAS_DISK   
   replace idContrato WITH nNewCtr FOR idContrato = nOldCtr
   cLstCampo = ''
   FOR n=1 TO FCOUNT()
      cLstCampo = cLstCampo +','+FIELD(n)
   NEXT 
   cLstCampo = SUBSTR(cLstCampo,2)
   SELECT CONTRATO_REGRAS_DISK   
   cCmd = "APPEND FROM DBF('CONTRATO_REGRAS_DISK') FIELDS "+ cLstCampo +" FOR idContrato="+TRANSFORM(nNewCtr)
   &cCmd.    

   * -----------------------------------
   SELECT LV_CONTRATO_TRA
   replace idContrato WITH nNewCtr FOR idContrato = nOldCtr
   cLstCampo = ''
   FOR n=1 TO FCOUNT()
      IF NOT UPPER(FIELD(n))=='ID'
         cLstCampo = cLstCampo +','+FIELD(n)
      ENDIF 
   NEXT 
   cLstCampo = SUBSTR(cLstCampo,2)
   SELECT CONTRATO_TRA
   cCmd = "APPEND FROM DBF('LV_CONTRATO_TRA') FIELDS "+ cLstCampo +" FOR idContrato="+TRANSFORM(nNewCtr)
   &cCmd.

   * -----------------------------------
   INSERT INTO CONTRATO_TRA_ITEM  ( id_contrato_tra, idcodatend, regra, detalha, vunitario, codref_vu, vtaxa, ;
                                    codref_tx, vhrparada, codref_hp, auditoria, vmedico ) ;
   SELECT bb.id as id_contrato_tra, ;
          aa.idcodatend, aa.regra, aa.detalha, aa.vunitario, aa.codref_vu, aa.vtaxa, ;
          aa.codref_tx, aa.vhrparada, aa.codref_hp, aa.auditoria, aa.vmedico ;
   FROM   CONTRATO_TRA_ITEM aa ;
   JOIN   CONTRATO_TRA bb ON bb.id=aa.id_CONTRATO_TRA;
   WHERE  bb.idContrato=nNewCtr 
   * -----------------------------------
   ? nNewCtr     
   ?? [:]

   SELECT COUNT(1) as qtd FROM ASSOCIADO WHERE idContrato=nOLDCtr AND situacao='ATIVO' INTO ARRAY aQtdAssoc
   ?? LV_CONTRATO_NEW.tipo_contrato+':'+TRANSFORM( aQtdAssoc[1] )
   
   IF aQtdAssoc[1] > 0

      SELECT * FROM ASSOCIADO WHERE idContrato=nOldCtr AND situacao='ATIVO' INTO CURSOR LV_ASSOC READWRITE 
      SELECT LV_ASSOC
      replace ALL idContrato WITH nNewCtr 
      replace ALL oldcod     WITH TRANSFORM(idAssoc)
      
      cLstCampo = ''
      FOR n=1 TO FCOUNT()
         IF NOT UPPER(FIELD(n))=='IDASSOC'
            cLstCampo = cLstCampo +','+FIELD(n)
         ENDIF 
      NEXT 
      cLstCampo = SUBSTR(cLstCampo,2)
      SELECT ASSOCIADO
      cCmd = "APPEND FROM DBF('LV_ASSOC') FIELDS "+ cLstCampo 
      &cCmd.

      SELECT ASSOCIADO
      SET ORDER TO IDCONTRATO 
      =SEEK( nNewCtr, 'ASSOCIADO' )
      
      SCAN WHILE idContrato == nNewCtr  AND !EOF()
         nPos = RECNO()
         =SEEK( nNewCtr, 'CONTRATO', 'I_D' )
         
         @ row(),40 say RECNO()
         
         nOldIdAssoc = INT(VAL(ASSOCIADO.oldcod))
         cAssocCodOld  = ASSOCIADO.codigo
         replace ASSOCIADO.oldcod    WITH TRANSFORM(nOldIdAssoc)+':'+ALLTRIM(ASSOCIADO.codigo)    
         replace ASSOCIADO.codigo    WITH ''

         IF SUBSTR(cAssocCodOld ,11,2) = '00'
            =FI_CODIFICA( 'TITULAR' )
            cCodTIT = ASSOCIADO.codigo
         ELSE
            =FI_CODIFICA( 'DEPENDENTE', LEFT(cCodTIT,10) )
         ENDIF
      
         INSERT INTO ASSOCIADO_PLANO (idplano, valor, idvend, parcela, dtinc, ultfat, valor_ant, auditoria);
         SELECT  aa.idplano, aa.valor, aa.idvend, aa.parcela, aa.dtinc, aa.ultfat, aa.valor_ant, aa.auditoria ;
         FROM    ASSOCIADO_PLANO aa ;
         WHERE   aa.idAssoc=nOldIdAssoc 
         
         INSERT INTO ASSOCIADO_ACLINICO (idantclinico, origem);
         SELECT  aa.idantclinico, aa.origem ;
         FROM    ASSOCIADO_ACLINICO  aa ;
         WHERE   aa.idAssoc=nOldIdAssoc 
         
         INSERT INTO ASSOCIADO_HOSPITAL (idhospital, origem);
         SELECT  aa.idhospital, aa.origem ;
         FROM    ASSOCIADO_HOSPITAL aa ;
         WHERE   aa.idAssoc=nOldIdAssoc 

         INSERT INTO ASSOCIADO_PSAUDE (idplanosaude, origem);
         SELECT  aa.idplanosaude, aa.origem ;
         FROM    ASSOCIADO_PSAUDE aa ;
         WHERE   aa.idAssoc=nOldIdAssoc          
      
         SELECT ASSOCIADO
         SET ORDER TO IDCONTRATO 
         GOTO nPos
         
      ENDSCAN       
      
   ENDIF 

   SELECT LV_CONTRATO_NEW 
ENDSCAN 


SELECT LV_CONTRATO
dCanc = {^2020-10-01}
cMoti = 'TRANSFERIDO PARA FILIAL 02 em '+DTOC(DATE())+' por AliasTi Conforme Orientação'
SCAN ALL

   IF SEEK( LV_CONTRATO.idContrato, 'CONTRATO', 'I_D' )   
      replace CONTRATO.situacao        WITH 'CANCELADO'
      replace CONTRATO.datacancela     WITH dCanc 
      replace CONTRATO.motivocancel    WITH 'OUTROS'
      replace CONTRATO.motivo          WITH cMoti 
      replace CONTRATO.dataExc         WITH dCanc 
   endif
ENDSCAN 

SELECT LV_ASSOCIADO
SCAN ALL
   IF SEEK( LV_ASSOCIADO.idAssoc, 'ASSOCIADO', 'IDASSOC' )   
      replace ASSOCIADO.situacao        WITH 'CANCELADO'
      replace ASSOCIADO.datacancela     WITH dCanc 
      replace ASSOCIADO.motivocancel    WITH 'OUTROS'
      replace ASSOCIADO.motivo          WITH cMoti 
      replace ASSOCIADO.dataExc         WITH dCanc 
   ENDIF 
ENDSCAN 


*!*   FOR i=1 TO nLst
*!*      cAls = 'LV_'+aArq[i]
*!*      USE IN ( SELECT(cAls))
*!*   NEXT 
?
? DATETIME()-dIni
?
