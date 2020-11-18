
nIdCtrDE      = 10513  && filial 01
nIdCtrPARA    = 71078  && filial 02


Close Databases All
Close Tables All
Set Escape On
CLEAR


cDirDE   = 'c:\desenv\win\vfp9\sca_new\'
cDirPARA = 'c:\desenv\win\vfp9\sca_new\'
*-----------------------------------------------------------------------
Use  (cDirDE+'CONTRATO')          In 0 Alias DE_CONTR
Use  (cDirDE+'ASSOCIADO')         In 0 Alias DE_ASSOC
Use  (cDirDE+'ASSOCIADO_PLANO')   In 0 Alias DE_PLANO
*-----------------------------------------------------------------------
Use  (cDirPARA+'CONTRATO')        In 0 Alias CONTRATO AGAIN
Use  (cDirPARA+'ASSOCIADO')       In 0 Alias ASSOCIADO AGAIN
Use  (cDirPARA+'ASSOCIADO_PLANO') In 0 Alias ASSOCIADO_PLANO AGAIN
*-----------------------------------------------------------------------


Select      aa.* ;
   FROM        DE_ASSOC aa ;
   WHERE       aa.situacao='ATIVO' And aa.idContrato == nIdCtrDE ;
   ORDER By    aa.codigo ;
   INTO Cursor LV_ASSOC

If _Tally > 0

   Scan While !Eof()
      ?? [.]

      nOldIdAssoc = LV_ASSOC.idAssoc

      Scatter Name oReg Memo

      oReg.oldcod     = Allt(oReg.codigo)+' ('+Tran(oReg.idAssoc)+')'
      oReg.idContrato = nIdCtrPARA
      oReg.codigo     = '02'+Substr(oReg.codigo,3)

      Select ASSOCIADO
      Append Blank
      Gather Name oReg Fields Except idAssoc

      nNewIDAssoc = ASSOCIADO.idAssoc

      Select Distinct * From DE_PLANO Where idAssoc = nOldIdAssoc Into Cursor LV_PLANO

      Scan While idAssoc = nOldIdAssoc

         Scatter Name oReg
         oReg.idAssoc = nNewIDAssoc

         Select ASSOCIADO_PLANO
         Append Blank
         Gather Name oReg

         Select LV_PLANO

      Endscan

      Select LV_ASSOC
   Endscan

Endif


