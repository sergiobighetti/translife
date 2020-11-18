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
Local lFecha_associado_plano, lFecha_associado, lOk

lFecha_associado       = .F.
lFecha_associado_plano = .F.

nSel = Select()
cVer = Sys(2015)

If !Used('associado_plano')
   Use associado_plano In 0
   lFecha_associado_plano = .T.
   Select associado_plano
   =CursorSetProp("Buffering",5)
Endif

If !Used( 'associado' )
   Use associado In 0
   lFecha_associado = .T.
Endif

Select associado_plano
Set Order To IDASSOC   && IDASSOC


Select      aa.IDASSOC,        ;
   aa.idPlano,        ;
   aa.dtinc,          ;
   aa.valor           ;
   ;
   FROM        associado_plano aa ;
   JOIN        associado bb  On aa.IDASSOC == bb.IDASSOC ;
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
   nIdAssoc = &cVer..IDASSOC
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

   Select associado_plano
   If Seek( nIdAssoc, 'associado_plano', 'IDASSOC' )
      Scan While IDASSOC == nIdAssoc
         If associado_plano.idPlano == nIdPlano
            Replace valor With nVlr
         Endif
      Endscan
   Endif

Endscan

Use In ( Select( cVer ) )

lOk = Tableupdate( 2, .T., 'associado_plano' )

If lFecha_associado_plano
   Select associado_plano
   Use
Endif

If lFecha_associado
   Select associado
   Use
Endif

Select (nSel)

oTerm.Complete()

Return lOk
