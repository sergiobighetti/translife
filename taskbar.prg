Define Class TaskBar As Custom

  Procedure Init
    Declare Integer FindWindow In "user32" ;
      String lpClassName, String lpWindowName

    Declare Integer FindWindowEx In "user32" ;
      Integer HWnd, Integer hWnd2, ;
      String lpsz1, String lpsz2

    Declare Integer GetWindowLong In "user32" ;
      Integer HWnd, Integer nIndex

    Declare Integer SetWindowLong In "user32" ;
      Integer HWnd, Integer nIndex, Integer dwNewLong

    Declare Integer SetLayeredWindowAttributes In "user32" ;
      Integer HWnd, Integer crey, ;
      Integer bAlpha, Integer dwFlags

    Declare Integer ShowWindow In "user32" ;
      Integer HWnd, Integer nCmdShow

    Declare Integer EnableWindow In "user32" ;
      Integer  HWnd, Integer fEnable

  Endproc

  Proc BarraDeTareaVisible(tlVisible)
    Local lnHWndShell_TrayWnd
    lnHWndShell_TrayWnd = FindWindow("Shell_TrayWnd", 0)
    If lnHWndShell_TrayWnd <> 0
      ShowWindow(lnHWndShell_TrayWnd, Iif(tlVisible, 1, 0))
    Endif
  Endproc

  Proc BarraDeTareaHabilitada(tlEnabled)
    Local lnHWndShell_TrayWnd
    lnHWndShell_TrayWnd = FindWindow("Shell_TrayWnd", 0)
    If lnHWndShell_TrayWnd <> 0
      EnableWindow(lnHWndShell_TrayWnd, tlEnabled)
    Endif
  Endproc

  Procedure RelojVisible(tlVisible)
    Local lnHWndShell_TrayWnd, lnHWndTrayNotifyWnd, lnHWndTrayClockWClass
    lnHWndShell_TrayWnd = FindWindow("Shell_TrayWnd", 0)
    lnHWndTrayNotifyWnd = FindWindowEx(lnHWndShell_TrayWnd, 0, "TrayNotifyWnd", 0)
    lnHWndTrayClockWClass = FindWindowEx(lnHWndTrayNotifyWnd, 0, "TrayClockWClass", 0)
    If lnHWndTrayClockWClass <> 0
      ShowWindow(lnHWndTrayClockWClass, Iif(tlVisible,1,0))
    Endif
  Endproc

  Procedure SystrayVisible(tlVisible)
    Local lnHWndShell_TrayWnd, lnHWndTrayNotifyWnd
    lnHWndShell_TrayWnd = FindWindow("Shell_TrayWnd", 0)
    lnHWndTrayNotifyWnd = FindWindowEx(lnHWndShell_TrayWnd, 0, "TrayNotifyWnd", 0)
    If lnHWndTrayNotifyWnd <> 0
      ShowWindow(lnHWndTrayNotifyWnd, Iif(tlVisible,1,0))
    Endif
  Endproc

  Procedure IconosVisible(tlVisible)
    Local lnHWndShell_TrayWnd, lnHWndTrayNotifyWnd, lnHWndSyspager
    lnHWndShell_TrayWnd = FindWindow("Shell_TrayWnd", 0)
    lnHWndTrayNotifyWnd = FindWindowEx(lnHWndShell_TrayWnd, 0, "TrayNotifyWnd", 0)
    lnHWndSyspager = FindWindowEx(lnHWndTrayNotifyWnd, 0, "Syspager", 0)
    If lnHWndSyspager <> 0
      ShowWindow(lnHWndSyspager, Iif(tlVisible,1,0))
    Endif
  Endproc

  Procedure InicioRapidoVisible(tlVisible)
    Local lnHWndShell_TrayWnd, lnHWndReBarWindow32, lnHWndToolbarWindow32
    lnHWndShell_TrayWnd = FindWindow("Shell_TrayWnd", 0)
    lnHWndReBarWindow32 = FindWindowEx(lnHWndShell_TrayWnd, 0, "ReBarWindow32", 0)
    lnHWndToolbarWindow32 = FindWindowEx(lnHWndReBarWindow32, 0, "ToolbarWindow32", 0)
    If lnHWndToolbarWindow32 <> 0
      ShowWindow(lnHWndToolbarWindow32, Iif(tlVisible,1,0))
    Endif
  Endproc

  Procedure BarraDeTareaTransparente(tnLevel)
    Local lnLevel, lnOldStyle, lnWndShell_TrayWnd
    lnLevel = 0xFF - Max(0,Min(Int(tnLevel*255/100),255))
    lnHWndShell_TrayWnd = FindWindow("Shell_TrayWnd", 0)
    If lnHWndShell_TrayWnd <> 0
      lnOldStyle = GetWindowLong(lnHWndShell_TrayWnd, -20)
      SetWindowLong(lnHWndShell_TrayWnd, -20, Bitor(lnOldStyle, 0x80000))
      SetLayeredWindowAttributes(lnHWndShell_TrayWnd, 0, lnLevel, 0x2)
    Endif
  Endproc

Enddefine