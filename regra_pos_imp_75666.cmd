***************************************************************************
* Regra de valorização de produtudos para o contrato da SOGELI (75666)
***************************************************************************
Lparameters nCtr, dRef
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

Select         aa.IDASSOC,        ;
               aa.idPlano,        ;
               aa.dtinc,          ;
               aa.valor,          ;
               bb.vendedor        ;
               ;
FROM        associado_plano aa ;
JOIN        associado bb  On aa.IDASSOC == bb.IDASSOC ;
WHERE       bb.idContrato == nCtr and aa.idPlano == 18 ;
ORDER By    aa.IDASSOC,aa.idPlano ;
INTO Cursor (cVer) Readwrite

oTerm = Newobject("_thermometer","_therm","","Procedendo acerto de REGRA DE COMISSAO")
oTerm.Show()

nTotal = Reccount( cVer )
nProc  = 0
nVlr   = 0

Scan All

   nPerc = ( ( nProc / nTotal ) * 100 )
   nProc = nProc + 1
   oTerm.Update( nPerc, "Registro "+Str(nProc,10)+"/"+Str(nTotal,10))

   nIdAssoc = &cVer..IDASSOC
   nIdPlano = &cVer..idPlano

   Select associado_plano
   If Seek( nIdAssoc, 'associado_plano', 'IDASSOC' )
      Scan While IDASSOC == nIdAssoc
         If associado_plano.idPlano == nIdPlano
            Replace regra_cod With '03'  && -- RP:INCLUSAO: 3 X 50%                               
            Replace idVend    WITH  &cVer..vendedor            
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