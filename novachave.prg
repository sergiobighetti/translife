Function NovaChave( cFilial, cCHAVE, cTipo )
Local lcoldreprocess, lnoldarea, nProxCodigo, cRet, cProxCodigo, nBuffer, lAbriu
Local cXCodigo

lnoldarea = Select()
lAbriu    = .F.
If !Used('FILIAL_CHAVES')
   lAbriu = .T.
   Use BDMDC!FILIAL_CHAVES In 0 Shared
Endif

Select FILIAL_CHAVES

nBuffer = CursorGetProp("Buffering", 'FILIAL_CHAVES' )
lcoldreprocess = Set('REPROCESS')
Set Reprocess To Automatic

nProxCodigo = -1
cXCodigo    = ''

If Seek( cFilial+cCHAVE, 'FILIAL_CHAVES', 'IDFILIAL' )

   Select FILIAL_CHAVES

   nProxCodigo = FILIAL_CHAVES.contador
   cXCodigo    = Alltrim(FILIAL_CHAVES.xCodigo )

   If !Empty(cXCodigo)

      If (nProxCodigo+1) >= 100000
         cXCodigo  = Chr( Asc( cXCodigo )+1 )
         Replace xCodigo With cXCodigo
         
         If FILIAL_CHAVES.contador <= 99999
            nProxCodigo = 1
         Endif
      Endif

   Else

      If (nProxCodigo+1) >= 1000000
         If Empty(cXCodigo)
            cXCodigo  = 'A'
            Replace xCodigo With cXCodigo
         Endif
         If FILIAL_CHAVES.contador <= 999999
            nProxCodigo = 1
         Endif
      Endif

   Endif

   Replace contador With ( nProxCodigo + 1 )

Else

   nProxCodigo = 1
   Insert Into FILIAL_CHAVES ( idfilial, chave, contador ) Values (cFilial,cCHAVE,2)

Endif

If nBuffer >= 3
   =Tableupdate(2,.T.,'FILIAL_CHAVES' )
Endif

Flush
Go Top In FILIAL_CHAVES

If Empty(cXCodigo)
   cProxCodigo =            Padl(nProxCodigo,6,'0')
Else
   cProxCodigo = cXCodigo + Padl(nProxCodigo,5,'0')
Endif

If nProxCodigo > 0
   cRet = cCHAVE + cProxCodigo + cTipo
Else
   cRet = ""
Endif

If lAbriu
   Use In ( Select( 'FILIAL_CHAVES' ) )
Endif

Select (lnoldarea)
Set Reprocess To lcoldreprocess

Return cRet
