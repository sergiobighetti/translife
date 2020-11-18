Function  fi_VerFECHA_FNC( _Data )  && retorna .t. se a data esta dentro do perido de FECHA_FNC
Local cSql, nSel, cVer, cMsg, lOk

cMsg = ''

Do Case
   Case Type('_Data') = 'C'
   
   Case Inlist( Type('_Data'), 'D', 'T' )
      _Data = TTOC_SQL( _Data )

Endcase

lOk  = .T.
Try
   If Not Isnull(_Data) And Not Empty(_Data)
      cMsg  = fi_VlrDTMOV( _Data )
      If Not Empty(cMsg)
          cMsg = Alltrim(cMsg)
      Endif
      lOk = Empty(cMsg)
   Endif
Catch
Endtry

Return lOk



Function fi_VlrDTMOV( tData  )
Local tUltFecha, cRst, nSel, aOpen, x, aOpen[1,2], laClosed[1,2]

tUltFecha = Ctot('')
cRst      = Space(50)
nSel      = SELECT()

If !Empty(tData)

   =Aused( aOpen )

   Select Top 1 datahora From FECHA_FNC Order By datahora Desc Into Array aMax
   IF _tally = 0
      tUltFecha = {^1991-01-01 00:00}
   else
      tUltFecha = Nvl( aMax[1], {^1991-01-01 00:00} )
   ENDIF 
   
   If tData < tUltFecha
      cRst = 'Data < fechamento (FECHA_FNC)'
   Endif

   For x=1 To Aused( laClosed )
      If Ascan( aOpen, laClosed[x,1]) = 0
         Use In (laClosed[x,1])
      Endif
   Next

Endif

SELECT (nSel)
Return cRst
ENDFUNC 
