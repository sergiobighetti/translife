LPARAMETERS cTitulo, cMsg, nTempo

* API declarations
Declare Integer Shell_NotifyIcon In shell32 Long, String


#Define SW_HIDE 0
#Define SW_SHOW 5
#Define SW_MINIMIZE 6
#Define SW_RESTORE 9


#Define NIM_ADD 0x0
#Define NIM_MODIFY 0x1
#Define NIM_DELETE 0x2
#Define NIF_MESSAGE 1
#Define NIF_ICON 2
#Define NIF_TIP 4

#Define NIF_SHOWTIP 0x00000080
#Define NIF_INFO   0x00000010
#Define NIIF_NOSOUND 0x00000010   && no sound


Local m.lcBalloonText,m.lcBalloontitle,m.lnIcon,m.lnTimeout,m.lcTip,lcNotifyString
m.lcBalloonText  =  cMsg
m.lcBalloontitle = cTitulo
m.lnIcon         = 1
m.lnTimeout      = IIF( TYPE('nTempo')='N', nTempo, 10 )
m.lcTip          = _Screen.Caption
m.lcNotifyString =ybuild_structure(m.lcBalloonText,m.lcBalloontitle,m.lnIcon,m.lnTimeout,_Screen.HWnd,m.lcTip)

If Shell_NotifyIcon(NIM_ADD, m.lcNotifyString)<>0 && add icon to the system windows traybar if valid structure
   =Shell_NotifyIcon( NIM_MODIFY, @lcNotifyString)
Endif


Procedure ybuild_structure
   Lparameters cBalloonText,cBalloonTitle,lnIcon,lnTimeout,phiconSmall,lcTip
   If Pcount() < 1
      *  Must at least include the balloon Text.
      Return -1
   Endif

   If Type("cBalloonText") <> "C"
      Return -1
   Endif

   If Type("cBalloonTitle") <> "C"
      lcBalloontitle = ""
   Endif

   If Type("lnIcon") <> "N"
      lnIcon = 0
   Endif

   If Type("lnTimeout") <> "N"
      lnTimeout = 0
   Else
      lnTimeout = m.lnTimeout * 1000   && Convert seconds to Milliseconds.
   Endif

   _Screen.AddProperty("yhwnd",_Screen.HWnd)
   _Screen.AddProperty("OLD_ICON",_Screen.Icon)
   _Screen.AddProperty("ysound",.T.)  && .t. for sound associated with notification .f. no sound.


   Local lcNotifyString
   lcNotifyString = ;
      + DoubleWord(504) ;
      + DoubleWord(_Screen.yhwnd) ;
      + DoubleWord(0) ;
      + DoubleWord( Bitor(NIF_ICON,NIF_TIP,NIF_MESSAGE,NIF_INFO)) ;
      + DoubleWord(0x201);
      + DoubleWord(phiconSmall) ;
      + Padr(Left(lcTip+Chr(0), 127), 128, Chr(0));
      + DoubleWord(0);
      + DoubleWord(0);
      + Padr(Left(Transform(cBalloonText), 255),256, Chr(0));
      + DoubleWord(m.lnTimeout) ;
      + Padr(Left(Transform(cBalloonTitle), 63),64, Chr(0))   ;
      + Iif(_Screen.ysound=.T.,"",DoubleWord(NIIF_NOSOUND));
      + DoubleWord(Bitand(lnIcon, 0x1F))

   *  Send request to display balloon.  This is asynchronous, so
   *  balloon may not be displayed immediately.
   lnReturn =Shell_NotifyIcon( NIM_MODIFY,@lcNotifyString)  &&return 1 if successful

   Return lcNotifyString
Endproc

***********************
*convert numeric INTEGER to DWORD
Procedure DoubleWord
   Parameters Integer_word_size
   Private I,Double_word_size
   Double_word_size = ''
   For I = 1 To 4
      Double_word_size = Double_word_size + Chr(Integer_word_size % 256)
      Integer_word_size = Int(Integer_word_size / 256)
   Endfor
   Return Double_word_size
   *
