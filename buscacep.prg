Lparameters cCep

Local cTmp, nSel, oRtn

cTmp = 'CLV_CEP_'+Sys(3)

nSel = Select()

oRtn = Createobject( 'CUSTOM' )
oRtn.AddProperty( 'CEP' )
oRtn.AddProperty( 'BAIRRO' )
oRtn.AddProperty( 'BAIRRO_ABREVIADO' )
oRtn.AddProperty( 'LOGRADOURO_TIPO' )
oRtn.AddProperty( 'LOGRADOURO' )
oRtn.AddProperty( 'CIDADE' )
oRtn.AddProperty( 'UF' )

Select      cc.cep8      As CEP, ;
            bb.extenso   As NomeBairro, ;
            bb.abreviado As AbreviacaoBairro, ;
            TT.abrev     As TipoLogradouro, ;
            cc.Nome      As NomeLogradouro, ;
            ll.Nome      As NomeLocal, ;
            ll.uf        As uf ;
FROM        DBCEP!CEP cc ;
INNER Join  DBCEP!TIPO TT   On cc.chvtipo=TT.TIPO ;
INNER Join  DBCEP!BAIRRO bb On cc.chvbai1=bb.chave And cc.chvLocal = bb.chvLoc ;
INNER Join  DBCEP!Local ll  On cc.chvLocal=ll.chave ;
WHERE       cc.cep8 = cCep ;
INTO Cursor (cTmp)

oRtn.CEP              = Alltrim( &cTmp..CEP )
oRtn.BAIRRO           = Alltrim( &cTmp..NomeBairro )
oRtn.BAIRRO_ABREVIADO = Alltrim( &cTmp..AbreviacaoBairro )
oRtn.LOGRADOURO_TIPO  = Alltrim( &cTmp..TipoLogradouro )
oRtn.LOGRADOURO       = Alltrim( &cTmp..NomeLogradouro )
oRtn.CIDADE           = Alltrim( &cTmp..NomeLocal )
oRtn.uf               = Alltrim( &cTmp..uf )

Use In ( Select( cTmp ) )
Use In ( Select( 'CEP' ) )
Use In ( Select( 'TIPO' ) )
Use In ( Select( 'BAIRRO' ) )
Use In ( Select( 'LOCAL' ) )

Sele ( nSel )

IF EMPTY(oRtn.LOGRADOURO)
   Declare Integer InternetGetConnectedState In WinInet Integer @ , Integer
   If InternetGetConnectedState(0,0) <> 0
      oCep = FI_CEP_NET( cCep )
      oRtn.CEP              = oCep.CEP
      oRtn.BAIRRO           = SemAcento( UPPER(oCep.BAIRRO) )
      oRtn.BAIRRO_ABREVIADO = ''
      oRtn.LOGRADOURO_TIPO  = SemAcento( UPPER(oCep.TIPO) )
      oRtn.LOGRADOURO       = SemAcento( UPPER(oCep.LOGRADOURO) )
      oRtn.CIDADE           = SemAcento( UPPER(oCep.CIDADE) )
      oRtn.uf               = UPPER(oCep.uf)
   Endif
   Clear Dlls 'InternetGetConnectedState'
ENDIF 

Return oRtn
