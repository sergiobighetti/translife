clear
USE atendimento
GO BOTTOM 

_ClipText = FI_REG_TO_JSON( ALIAS())
? _ClipText

Function FI_REG_TO_JSON(cAls)
   Local cJS, nQtdCampos, aFld[1], F, cFldNome, _FldCont

   cJS = ''
   nQtdCampos = Fcount(cAls)
   Afields( aFld, cAls)

   For F=1 To nQtdCampos
      cFldNome  = Lower( Field(F,cAls) )
      _FldCont  = Evaluate( cFldNome )

      cJS = cJS + ','+Chr(13)+'"'+ cFldNome  +'": '
      Do Case
         Case Inlist(aFld[f,2],'C' )
            _FldCont  = Alltrim(_FldCont )
            _FldCont  = Chrtran(_FldCont, '|',     ' ' )
            _FldCont  = Chrtran(_FldCont, '"',     ' ' )
            _FldCont  = Chrtran(_FldCont, Chr(9),  ' ' )
            _FldCont  = Chrtran(_FldCont, Chr(39), ' ' )
            _FldCont  = Chrtran(_FldCont, Chr(13), '|' )
            _FldCont  = Chrtran(_FldCont, Chr(10), ' ' )

            cJS = cJS + '"'+ Alltrim(_FldCont ) +'"'

         Case Inlist(aFld[f,2],'M' )

            _FldCont  = Alltrim(_FldCont )
            _FldCont  = Chrtran(_FldCont, '|',     ' ' )
            _FldCont  = Chrtran(_FldCont, '"',     ' ' )
            _FldCont  = Chrtran(_FldCont, Chr(9),  ' ' )
            _FldCont  = Chrtran(_FldCont, Chr(39), ' ' )
            _FldCont  = Chrtran(_FldCont, Chr(13), '|' )
            _FldCont  = Chrtran(_FldCont, Chr(10), ' ' )
            _FldCont  = SemAcento(_FldCont,.T.)

            cJS = cJS + '"'+ Alltrim(_FldCont ) +'"'
         Case Inlist(aFld[f,2],'D', 'T' )
         
            IF EMPTY(_FldCont )
               cJS = cJS + 'null'
            else
               cJS = cJS + '"'+ TTOC_SQL(_FldCont )  +'"'
            endif
         
         Case Inlist(aFld[f,2],'I' )
            cJS = cJS + Tran(_FldCont )
         Case Inlist(aFld[f,2],'N' )
            cJS = cJS + NTOC_SQL(_FldCont,12,2)
         Case Inlist(aFld[f,2],'Y' )
            cJS = cJS + NTOC_SQL(_FldCont,18,4)
         Case Inlist(aFld[f,2],'L' )
            cJS = cJS + '"'+ Iif( _FldCont,'S','N' ) +'"'
      Endcase

   Next

   Return '{'+SUBSTR(cJS,2)+CHR(13)+'}'
ENDfunc