Function FI_UNID_EM_EVENTO()
Local nQtdU, oReg, aUnid[1], i, cBs, cRet
Local aOpen[1], x, laClosed[1]

=Aused( aOpen )

cBs  = 'BS_'+Sys(2015)
cRet = 'EV_'+Sys(2015)

TEXT TO cSql TEXTMERGE PRETEXT 15
SELECT
           ee.idfilial
         , ee.prev_inicio as INICIO
         , ee.eve_local  as LOCAL
         , ee.eve_fone   as FONE
         , ee.eve_nome   as EVENTO
         , ee.qusb       as qtd_USB
         , ee.qusa       as qtd_USA
         , ee.fat_nome   as CONTRATANTE
         , IIF(!EMPTY(ee.prorrogacao), ee.prorrogacao, ee.prev_termino ) as Termino
         , ee.unidade_detalhe as xUnid
         , ee.idEvento
FROM     EVENTO ee
WHERE    ee.situacao='6' and !EMPTY(ee.unidade_detalhe)
INTO CURSOR <<cBs>>
ENDTEXT

&cSql.

Select * From (cBs) Where (1=2) Into Cursor (cRet) Readwrite
Select (cBs)
Scan All

   Scatter Name oReg
   nQtdU = Alines( aUnid, oReg.xUnid,1,',' )

   For i=1 To nQtdU
      oReg.xUnid = aUnid[i]
      Insert Into (cRet) From Name oReg
   Next

   Select (cBs)
Endscan

Select Distinct ;
   aa.idFilial, ;
   Cast(aa.xUnid As Int) As idUnid, ;
   NVL( UNI.descricao, Nvl(UNI2.descricao,Space(50)) ) As descricao,;
   aa.idEvento , aa.INICIO, aa.EVENTO, aa.Local, aa.FONE , aa.qtd_USB, aa.qtd_USA, aa.CONTRATANTE, aa.Termino  ;
   From (cRet) aa ;
   left Join  UNIDADEMOVEL UNI  On aa.idFilial == UNI.idFilial And Int(Val(aa.xUnid))= UNI.unidade And UNI.ativo=.T. ;
   left Join  UNIDADEMOVEL UNI2 On Int(Val(aa.xUnid))= UNI2.unidade  And UNI2.ativo=.T.


For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      If laClosed[x,1]<>cRet
         Use In (laClosed[x,1])
      Endif
   Endif
Next

Return cRet
