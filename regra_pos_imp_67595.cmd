***************************************************************************************************************
* Regra de valorização de produtudos para o contrato da REAL SOCIEDADE PORTUGUESA DE BENEFICENCIA (67595)
***************************************************************************************************************
Lparameters nCtr, dRef
*!*   nCtr = numero do contrato (67595)
*!*   dRef = data de inclusao do associado (qdo importado)    ou    data de referencia no faturamento 

*!*   Formato de cobrança de usuários de APH: 
*!*   de 25/02/2009 à 25/01/2010 custo de R$ 0,45 ( quarenta e cinco centavos)
*!*   de 25/02/2010 à 25/01/2011 custo de R$ 0,90 ( noventa centavos) 
*!*   de 25/02/2011 à 25/01/2012 custo de R$ 1,35 (um real e trinta e cinco centavos) 
*!*   a partir de fevereiro de 2012 será dado reajuste conforme índice pré estabelecido em contrato.

Local cVer, nTempo, nIdAssoc, nIdPlano, nSel, oTerm, nTerm, nTotal, nProc, nSum

nSel = Select()
cVer = Sys(2015)

SELECT associado_plano 
SET ORDER TO IDASSOC   && IDASSOC

Select      aa.idAssoc,        ;
   aa.idPlano,        ;
   aa.dtinc,          ;
   aa.valor           ;
   ;
   FROM        associado_plano aa ;
   JOIN        associado bb  On aa.idAssoc == bb.idAssoc ;
   WHERE       bb.idContrato == nCtr ;
   ORDER By    1,2 ;
   INTO Cursor (cVer) Readwrite

oTerm = Newobject("_thermometer","_therm","","Procedendo acerto de valores")
oTerm.Show()

nTotal = Reccount( cVer )
nProc  = 0

Scan All

   nPerc = ( ( nProc / nTotal ) * 100 )
   nProc = nProc + 1
   oTerm.Update( nPerc, "Registro "+Str(nProc,10)+"/"+Str(nTotal,10))


   If idPlano=2

      nIdAssoc = &cVer..idAssoc
      nIdPlano = &cVer..idPlano
      
      Do Case
      
         *!*   de 25/02/2009 à 25/01/2010 custo de R$ 0,45 ( quarenta e cinco centavos)
         Case Between( dRef, {^2008-12-01}, {^2010-01-25} )
            nVlr = $0.45
            
         *!*   de 25/02/2010 à 25/01/2011 custo de R$ 0,90 ( noventa centavos) 
         Case Between( dRef, {^2010-01-26}, {^2011-01-25} )
            nVlr = $0.90
            
         *!*   de 25/02/2011 à 25/01/2012 custo de R$ 1,35 (um real e trinta e cinco centavos) 
         Case Between( dRef, {^2011-01-26}, {^2012-01-25} )
            nVlr = $1.35
            
         *!*   a partir de fevereiro de 2012 será dado reajuste conforme índice pré estabelecido em contrato.
         Case dRef >= {^2011-01-26}  && negociação
            nVlr = $1.35
            
      ENDCASE
      
      SELECT associado_plano 
      IF SEEK( nIdAssoc, 'associado_plano', 'IDASSOC' )   
         SCAN WHILE idAssoc == nIdAssoc
            IF associado_plano.idPlano == nIdPlano
               replace valor WITH nVlr
            ENDIF
         ENDSCAN 
      ENDIF
      *** Update associado_plano Set valor = nVlr Where idAssoc == nIdAssoc And idPlano == nIdPlano
   
   Endif
   
   SELECT (cVer)
   
Endscan

Use In ( Select( cVer ) )

Select (nSel)

oTerm.Complete()

Return Tableupdate( 2, .T., 'associado_plano' )
