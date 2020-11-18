
*4* 
*updated on mercredi 7 octobre 2015; 15:11:57
*retrieves a google map itinerary from a known town to a destination town
*accepts also 2 coordinates points given by (latitude,lingitude) from to (latitude,longitude) destination
*Warning: replace the google map of your custom country.In algeria its
*https://www.google.dz/    --> (string 'dz' to replace)
*google dont draw all itineraries.it can fail on non known towns(data dont gathered by google).

Do ydeclare

Local m.yfrom,m.yto
m.yfrom=Inputbox("From a known town","","EL BAYADH"    )
m.yto=Inputbox("To a known town","","ALGER")

If Empty(m.yfrom) Or Empty(m.yto)
    Return .F.
Else
   m.yfrom=Allt(Strtran(m.yfrom," ","-"))
   m.yto=Allt(Strtran(m.yto," ","-"))
Endi
Local m.url
m.url="https://www.google.dz/maps/dir/"+m.yfrom+"/"+m.yto
Messagebox(m.url,0+32+4096,'',1500)
_Cliptext=m.url  &&url in clipboard


Local apie
apie=Newobject("internetexplorer.application")
With apie
   .Navigate(m.url)
   .Width=Sysmetric(1)
   .Height=Sysmetric(2)-30
   .Left=0
   .Top=0
   .menubar=0
   .StatusBar=0
   .Toolbar=0
   sleep(4000)  &&pass transitionnings
   =setwindowText(.HWnd,"google map ininerary: "+m.url)
   =bringWindowToTOp(.HWnd)
   .Visible=.T.
Endwith

Procedure ydeclare
Declare Integer BringWindowToTop In user32 Integer
Declare Integer SetWindowText In user32 Integer,String
Declare Integer Sleep In kernel32 Integer
Endproc
