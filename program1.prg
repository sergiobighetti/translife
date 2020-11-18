FUNCTION fi_FEV_Valor( cCodFat, tDataTransp, cRetorno )
* Retorna o valor hora do evento para a franquia acordada em contrato
Local cTmp, dFim, dFimV, dIni, dRef, i, nPulo, oFEV, nSel, nRet
LOCAL aOpen[1], x, laClosed[1]

cRetorno = IIF( TYPE('cRetorno')='C', UPPER(cRetorno), 'VHORA' )  && -- default do retorno é o valor HORA

* cCodFat     = '02CL018581CT'
* tDataTransp = DATETIME( 2019, 8, 10 )
* CLEAR

nSel = Select()
cTmp = Sys(2015)
nRet = 0  && --- ira conter o "valor" a ser retornado

=AUSED( aOpen )

* Seleciona a(s) franquia(s) do contrato
Select      aa.* ;
FROM        contrato_feventos aa ;
JOIN        contrato cc On cc.idcontrato = aa.idcontrato ;
WHERE       cc.codigo = cCodFat ;
ORDER By    aa.iniVigencia Desc ;
INTO Cursor (cTmp)

If _Tally > 1  && se tem mais que uma 

   && pega de acordo com a data
   Select  Top 1  aa.* ;
   FROM   (cTmp)  aa;
   WHERE          aa.iniVigencia <= tDataTransp;
   ORDER By       aa.iniVigencia  Desc ;
   Into Cursor   (cTmp)

Endif

Select (cTmp)

If Reccount(cTmp) > 0 && se tem registro

   Scatter Name oFEV
   dFimV = Gomonth( oFEV.iniVigencia, oFEV.nMesesVigencia ) -1
   =AddProperty( oFEV,'fimVigencia', Datetime( Year(dFimV), Month(dFimV), Day(dFimV), 23,59,59 ) )
   =AddProperty( oFEV,'hrUtilizado', 00000000 )
   =AddProperty( oFEV,'codigo', cCodFat )
   *=AddProperty( oFEV,'codigo', LTAB( 'idcontrato='+Transform(oFEV.idcontrato), 'CONTRATO',,'codigo') )

   oFEV.tpapuracao = Upper(oFEV.tpapuracao)

   nPulo = Iif( oFEV.tpapuracao='MENSAL',    1, ;
      IIF( oFEV.tpapuracao='BIMESTRAL',      2, ;
      IIF( oFEV.tpapuracao='TRIMESTRAL',     3, ;
      IIF( oFEV.tpapuracao='QUADRIMESTRAL',  4, ;
      IIF( oFEV.tpapuracao='SEMESTRAL',      6, ;
      IIF( oFEV.tpapuracao='ANUAL',         12, 0 ))))))

   dRef = Ttod(oFEV.iniVigencia)
   dIni = Ttod(oFEV.iniVigencia)

   For i=1 To 1000

      dRef = Gomonth(dIni,nPulo )-1

      If dRef > Ttod(oFEV.fimVigencia)
         dRef = Ttod(oFEV.fimVigencia)
         i=2000
      Endif
      dFim = dRef

      * se a data do transporte esta dentro do periodo
      IF BETWEEN( DTOS(tDataTransp), DTOS(dIni), DTOS(dFim) )

         && apura informações de acordo com o periodo
         SELECT      Left(Dtos(aa.prev_inicio),6) As anomes ;
                   , Count(1)                     As EV_qtd_Total ;
                   , Sum( fi_eve_tempo( aa.prev_inicio, aa.prev_termino, aa.prorrogacao ) ) As EV_Horas_Total ;
                   , Sum( aa.Total)               As EV_Vlr_Total ;
                   ;
                   , Sum( Iif( aa.Total>0,1,0) ) As EV_Qtd_Cobrados;
                   , Sum( Iif( aa.Total>0,fi_eve_tempo( aa.prev_inicio, aa.prev_termino, aa.prorrogacao ),0) ) As EV_Horas_Cobradas;
         FROM        EVENTO aa ;
         WHERE       aa.FAT_CODIGO = oFEV.codigo And Dtos(aa.prev_inicio) Between Dtos(dIni) And Dtos(dFim)  ;
         GROUP By    1 ;
         ORDER By    1 ;
         INTO Cursor (cTmp)


         DO CASE 
            CASE cRetorno =  'VHORA'   && --- retorna o valor/hora do evento (DEFAULT)
               IF &cTmp..EV_Horas_Total > oFEV.qhr_isento 
                  nRet = oFEV.vhora
               ENDIF 
            CASE cRetorno = 'EV_QTD_TOTAL'  && -- retornoa a quantidade de eventos
                  nRet = &cTmp..EV_qtd_Total 
                  
            CASE cRetorno = 'EV_HORAS_TOTAL' && -- retorna a quantidade de horas de evento
                  nRet = &cTmp..EV_Horas_Total 
               
            CASE cRetorno = 'EV_VLR_TOTAL'  && -- retorna o valor dos eventos
                  nRet = &cTmp..EV_Vlr_Total

            CASE cRetorno = 'O'  &&-- retorna um obj com as informações de apuracao
                  nRet = oFat
                  FOR i=1 TO FCOUNT(cTmp)
                     =ADDPROPERTY( nRet, FIELD(i,cTmp), EVALUATE( cTmp+'.'+FIELD(i,cTmp) ) )
                  NEXT 
         ENDCASE 
                
         exit
      ENDIF 

      dIni = dRef+1

   Next
Endif

Use In (Select(cTmp))

For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
NEXT

Select (nSel)

RETURN nRet 