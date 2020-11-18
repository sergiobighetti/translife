***************************************************************************
* Regra de valorização de produtudos para o contrato da SOGELI (66299)
***************************************************************************
Lparameters nCtr, dRef
*!*   a) de 0 a 6 meses   - R$ 0,00
*!*   b) de 7 a 12 meses  - R$ 0,45 (APH) + R$ 0,20 (DISK ENFERMAGEM)
*!*   c) de 13 a 18 meses - R$ 0,90 (APH)
*!*   d) de 19 a 24 meses - R$ 1,35 (APH)
*!*   e) após 24 meses    - R$ 1,80 (APH)
Local cVer, nTempo, nIdAssoc, nIdPlano, nSel, oTerm, nTerm, nTotal, nProc, nSum

nSel = Select()
cVer = Sys(2015)

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

   nTempo   = ( dRef - &cVer..dtinc )
   nIdAssoc = &cVer..idAssoc
   nIdPlano = &cVer..idPlano
   If idPlano=2

      Do Case

         Case Between( dtinc, {^2009-12-01}, {^2010-01-25} )
            nVlr = $0.45

         Case Between( dtinc, {^2010-01-26}, {^2011-01-25} )
            nVlr = $0.90

         Case Between( dtinc, {^2011-01-26}, {^2012-01-25} )
            nVlr = $1.35

         Case dtinc >= {^2011-01-26}  && negociação
            nVlr = $1.35
      Endcase

      Update associado_plano Set valor = nVlr Where idAssoc == nIdAssoc And idPlano == nIdPlano
      
   Endif

Endscan

Use In ( Select( cVer ) )

Select (nSel)

oTerm.Complete()

Return Tableupdate( 2, .T., 'associado_plano' )
