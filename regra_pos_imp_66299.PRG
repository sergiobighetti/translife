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

oTerm = NEWOBJECT("_thermometer","_therm","","Procedendo acerto de valores")
oTerm.SHOW()

nTotal = RECCOUNT( cVer )
nProc  = 0

Scan All

   nPerc = ( ( nProc / nTotal ) * 100 )
   nProc = nProc + 1
   oTerm.UPDATE( nPerc, "Registro "+STR(nProc,10)+"/"+STR(nTotal,10))

   nTempo   = ( dRef - &cVer..dtinc )
   nIdAssoc = &cVer..idAssoc
   nIdPlano = &cVer..idPlano

   Do Case
   
      Case Between( nTempo, 000, 182 ) &&__________   a) de 0 a 6 meses - R$ 0,00
         nVlr = $0
         
      Case Between( nTempo, 183, 365 ) &&__________   b) de 7 a 12 meses - R$ 0,45 (APH) + R$ 0,20 (DISK ENFERMAGEM)
         nVlr = Iif( idPlano=3, $0.45, Iif( idPlano=20, $0.20, &cVer..valor ))
         
      Case Between( nTempo, 366, 547 ) &&__________   c) de 13 a 18 meses - R$ 0,90 (APH)
         nVlr = Iif( idPlano=3, $0.90, Iif( idPlano=20, $0.20, &cVer..valor ))
         
      Case Between( nTempo, 548, 730 ) &&__________   d) de 19 a 24 meses - R$ 1,35 (APH)
         nVlr = Iif( idPlano=3, $1.35, Iif( idPlano=20, $0.20, &cVer..valor ))
         
      Case nTempo > 730                &&__________   e) após 24 meses - R$ 1,80 (APH)
         nVlr = Iif( idPlano=3, $1.80, Iif( idPlano=20, $0.20, &cVer..valor ))
         
   Endcase

   Update associado_plano SET valor = nVlr WHERE idAssoc == nIdAssoc And idPlano == nIdPlano

Endscan

Use In ( Select( cVer ) )

Select (nSel)

oTerm.COMPLETE()

RETURN TABLEUPDATE( 2, .t., 'associado_plano' )
