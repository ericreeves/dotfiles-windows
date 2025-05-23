# VD.ahk: Virtual Desktop

Windows 11 support, Windows Server 2022

### Just run the examples, everything explained inside

* <kbd>Numpad1</kbd> to go to `Desktop 1`<br>
* <kbd>Numpad2</kbd> to go to `Desktop 2`<br>
* <kbd>Numpad3</kbd> to go to `Desktop 3`<br>
```autohotkey
numpad1::VD.goToDesktopNum(1)
numpad2::VD.goToDesktopNum(2)
numpad3::VD.goToDesktopNum(3)
```
if you don't want VD switching animation, set `VD.animation_on:=false`

* <kbd>Win + x</kbd> move VSCode to your current Desktop and WinActivate
* <kbd>Win + e</kbd> move "explorer replacement program" to your current Desktop and WinActivate
```autohotkey
#x::VD.MoveWindowToCurrentDesktop("ahk_exe Code.exe ahk_class Chrome_WidgetWin_1")
#e::VD.MoveWindowToCurrentDesktop("ahk_explorer ahk_exe AutoHotkey.exe")
```
<br>

* <kbd>Numpad4</kbd> to move the active window to `Desktop 1`<br>
* <kbd>Numpad5</kbd> to move the active window to `Desktop 2`<br>
* <kbd>Numpad6</kbd> to move the active window to `Desktop 3`<br>
* here, I choose to follow the window
```autohotkey
numpad4::VD.MoveWindowToDesktopNum("A",1).follow()
numpad5::VD.MoveWindowToDesktopNum("A",2).follow()
numpad6::VD.MoveWindowToDesktopNum("A",3).follow()
```
```autohotkey
numpad7::VD.MoveWindowToDesktopNum("A",1)
numpad8::VD.MoveWindowToDesktopNum("A",2)
numpad9::VD.MoveWindowToDesktopNum("A",3)
```
...
```autohotkey
; wrapping / cycle back to first desktop when at the last
^#left::VD.goToRelativeDesktopNum(-1)
^#right::VD.goToRelativeDesktopNum(+1)

; move window to left and follow it
#!left::VD.MoveWindowToRelativeDesktopNum("A", -1).follow()
; move window to right and follow it
#!right::VD.MoveWindowToRelativeDesktopNum("A", 1).follow()
```

you can remap everything
___
detect when the virtual desktop changes:<br>
create a hotkey to return you to the **previous desktop**
```ahk
#Include %A_LineFile%\..\VD.ah2
VD.RegisterDesktopNotifications()
VD.DefineProp("CurrentVirtualDesktopChanged", {Call:CurrentVirtualDesktopChanged})
VD.previous_desktopNum:=1
CurrentVirtualDesktopChanged(desktopNum_Old, desktopNum_New) {
  VD.previous_desktopNum:=desktopNum_Old
}
Numpad0::VD.goToDesktopNum(VD.previous_desktopNum)
```
___
also has:
* `createDesktop()`

* rename desktop: `VD.setNameToDesktopNum("custom Desktop Name",desktopNum)`

* "Show this window on all desktops" corresponds to `VD.PinWindow(wintitle)`

* "Show windows from this app on all desktops" corresponds to `VD.PinExe(exe_path)`

- `getCount()` ;how many virtual desktops you now have
- pretty much everything virtual desktop, or so I think!<br>
  if there's anything missing/something you want: [create an issue](https://github.com/FuPeiJiang/VD.ahk/issues/new): I want to know what you're using it for

here's quick nice example: "get desktopNum of all windows"
```autohotkey
#Include %A_LineFile%\..\..\VD.ahk

foundProcesses := ""
; Make sure to get all windows from all virtual desktops
DetectHiddenWindows On
WinGet, id, List
Loop %id%
{
    hwnd := id%A_Index%
    ;VD.getDesktopNumOfWindow will filter out invalid windows
    desktopNum_ := VD.getDesktopNumOfWindow("ahk_id" hwnd)
    If (desktopNum_ > -1) ;-1 for invalid window, 0 for "Show on all desktops", 1 for Desktop 1
    {
        WinGet, exe, ProcessName, % "ahk_id" hwnd
        foundProcesses .= desktopNum_ " " exe "`n"
    }
}

MsgBox % foundProcesses
```

## cool fixes:<br>
* Switching VD does not make icons (on the taskbar) flash<br>
https://github.com/mzomparelli/zVirtualDesktop/issues/59#issue-227209226
> Sometimes when I switch desktop, the application that's focused on that desktop becomes highlighted in the task bar.
>
> Example:
> On desktop A, I have Firefox:<br>
> ![untitled](https://cloud.githubusercontent.com/assets/22036272/25830018/467f9c3a-345a-11e7-91a0-3d2a633fae68.png)
>
> On desktop B I have Steam (note that Firefox is pinned to my task bar, which is why it's visible on this desktop):<br>
> ![untitled2](https://cloud.githubusercontent.com/assets/22036272/25830028/563f7a3c-345a-11e7-8672-f0e43baf440f.png)
>
> When I switch from A to B, Steam becomes highlighted:<br>
> ![untitled3](https://cloud.githubusercontent.com/assets/22036272/25830040/675eff36-345a-11e7-970b-9a689eec74b3.png)
> (It's possible to stop the blinking by explicitly selecting the blinking window with the mouse or alt+tab.)
>
> When I switch back to A, Firefox also becomes highlighted (and Steam stays visible in the taskbar because it is highlighted):<br>
> ![untitled4](https://cloud.githubusercontent.com/assets/22036272/25830049/8281af16-345a-11e7-8d48-700b252e815a.png)
>
> This doesn't always happen; I'm not sure if it depends on the programs or where the mouse/keyboard focus is when switching desktops. That said, it happens far too often, to the point where it defeats the point of having multiple desktops at all.
>
> (The problem isn't limited to Firefox and Steam, the same thing also happens with other programs like Explorer.)
<br>

how ? `WinActivate` taskbar before switching and `WinMinimize` taskbar after arriving
* Switch VD reliably works in FULLSCREEN thanks to `SetTimer, pleaseSwitchDesktop, -50`
___
### if you don't use these headers, it will be slow:<br>
```autohotkey
#SingleInstance force
ListLines 0
SendMode "Input"
SetWorkingDir A_ScriptDir
KeyHistory 0
#WinActivateForce

ProcessSetPriority "H"

SetWinDelay -1
SetControlDelay -1
```
___
if you want global functions style instead of a class:<br>
eg: `VD_goToDesktopNum()` instead of `VD.goToDesktopNum()`<br>
then visit branch `global_functions`<br>
but it won't be updated
___
from https://github.com/MScholtes/VirtualDesktop/blob/812c321e286b82a10f8050755c94d21c4b69812f/VirtualDesktop11.cs#L161-L185<br>
Windows 11 has more functionality,<br>
if you need:<br>
* MoveDesktop: `// move current desktop to desktop in index (-> index = 0..Count-1)`<br>
* SetDesktopName<br>
* SetDesktopWallpaper<br>
* GetDesktopIsPerMonitor<br>
* etc.
* or anything else that's not On this list

[create an issue](https://github.com/MScholtes/VirtualDesktop/issues/new)
saying what function(s) you need, what you'll be using it for (I'm curious)
