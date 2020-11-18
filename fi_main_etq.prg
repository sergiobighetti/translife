Set Resource Off
* SET RESOURCE TO

Set Talk Off
Set Debug Off
Set Escape On
Set Date BRITISH
Close Tables   All
Close Databases All

Clear

? 'Etiqueta para MEDICAR'

Clear Memory
Clear All


_Screen.Visible  = .T.
_Screen.WindowState= 2

cArq = Padr('ENVIAR.DBF',40)

@ 10,10 Say "Arquivo base: " Get cArq
Read

cArq = Alltrim(cArq)

If !Empty(cArq)

   If File(cArq)

      lcNewDir = Justpath( Sys(16,0) )
      m.drvDiretorio = lcNewDir
      Cd (lcNewDir)
      Set Default To (lcNewDir)

      Use (cArq) Alias ENVIAR

      cPrg = Filetostr( 'FI_ETQ_AVULSA.CMD' )
      cDeAte = '1-99999'
      Do While .T.

         Clear
         cDeAte = Inputbox( 'Quantidade de etiquetas','De-Ate', cDeAte)
         If Empty(cDeAte)
            Exit
         Endif

         If Sys(1037)='1'
            Set Step On
            nDe  = Int(Val(Left(cDeAte,At('-',cDeAte)-1)))
            nAte = Int(Val(Substr(cDeAte,At('-',cDeAte)+1)))
            Scan For Between( Recno(), nDe, nAte ) And Inkey(.05)<>27
               ? Recno()
               =Execscript( cPrg )
            Endscan
         Endif

      Enddo

   ELSE
   
      Messagebox( 'Arquivo não encontrado', 16, 'Atenção' )

   Endif

Endif

Clear Memory
Close Tables   All
Close Databases All
Quit

Read Events
