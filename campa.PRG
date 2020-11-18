Close Databases All
Close Tables All

Create Cursor XCAMPA ;
   ( Matricula C(6),;
   CCUSTO    C(6),;
   Nome      C(35),;
   CPF       C(11),;
   RG        C(18),;
   Endereco  C(35),;
   Comple    C(25),;
   Bairro    C(25),;
   Cidade    C(25),;
   Cep       C(10),;
   Fone      C(25) )

Scatter Name oBS Blank

Use campa In 0

Select campa
nLinha = 1
oReg = oBS

Scan All

   cLinha = campo

   If cLinha = '---'
      nLinha = 1
      Loop
   Endif

   Do Case

      Case nLinha = 1

         oReg.Matricula = Alltrim(Substr( cLinha, 14,18 ))
         oReg.CCUSTO    = Alltrim(Substr( cLinha, 60,18 ))
         oReg.Nome      = Alltrim(Substr( cLinha, 105   ))

         nLinha = nLinha + 1

      Case nLinha = 2

         oReg.CPF       = Alltrim(Substr( cLinha, 14, 18))
         oReg.RG        = Alltrim(Substr( cLinha, 60, 18))
         oReg.Endereco  = Alltrim(Substr( cLinha, 105   ))

         nLinha = nLinha + 1

      Case nLinha = 3

         oReg.Comple    = Alltrim(Substr( cLinha, 14, 20))
         oReg.Bairro    = Alltrim(Substr( cLinha, 60, 20))
         oReg.Cidade    = Alltrim(Substr( cLinha, 105   ))

         IF oReg.Cidade = 'RIB'
            oReg.Cidade = 'RIBEIRAO PRETO'
         ENDIF

         nLinha = nLinha + 1

      Case nLinha = 4

         oReg.Cep       = Alltrim(Substr( cLinha, 14, 20))
         oReg.Fone      = Alltrim(Substr( cLinha, 60, 20))

         nLinha  = 1
         
         Insert Into XCAMPA From Name oReg
         oReg = oBS

   Endcase

   Select campa

Endscan

Select XCAMPA
Go Top
Brow
