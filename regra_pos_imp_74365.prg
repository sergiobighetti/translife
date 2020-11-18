***************************************************************************
* Regra de valorização de produtudos para o contrato da SOGELI (66299)
***************************************************************************
Lparameters nCtr, dRef
*!*   Ate o associado 33.000 o valor deve ser de 0,48, do associado 33.001 adiante o valor deve ser de 0,45.
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
WHERE       bb.idContrato == nCtr AND idPlano=18;
ORDER By    1,2,3 ;
INTO Cursor (cVer) Readwrite

oTerm = NEWOBJECT("_thermometer","_therm","","Processo: Ate 33000 assoc. 0,48, acima: 0,45")
oTerm.SHOW()

nTotal = RECCOUNT( cVer )
nProc  = 0

Scan All

   nPerc = ( ( nProc / nTotal ) * 100 )
   nProc = nProc + 1
   oTerm.UPDATE( nPerc, "Registro "+STR(nProc,10)+"/"+STR(nTotal,10))
   
   nIdAssoc = &cVer..idAssoc
   nIdPlano = &cVer..idPlano

   IF nProc <= 33000
      nVlr = $0.48
   ELSE
      nVlr = $0.45
   ENDIF 

   Update associado_plano SET valor = nVlr WHERE idAssoc == nIdAssoc And idPlano == nIdPlano

Endscan

Use In ( Select( cVer ) )

Select (nSel)

oTerm.COMPLETE()

RETURN TABLEUPDATE( 2, .t., 'associado_plano' )
