#Requires AutoHotkey v2.0
#SingleInstance Force

class Main {
    title := "Super AltTab.ahk"
    gui := "" ; An object of the AHK "Gui" class
    x := ""
    y := ""
    w := ""
    h := ThemeValueVariables["IconSize"] + (Icon.padding * 2)
    windowsArray := [] ; An array of objects of the "Window" class
    outline := "" ; An object of the "Outline" class

    /**
     * Constructor
     * @param position The "position" value to be passed to the "Outline".
     * If omitted, it defaults to a falsy empty string
     */
    __New(position := "") {
        ; Retrieve all the windows whose icons will be displayed
        this.windowsArray := Window.WinGetListAlt()

        if (this.windowsArray.Length > 0) {
            ; Prepare the Gui of the main window
            this.gui := Gui("+AlwaysOnTop -Caption +toolwindow +LastFound -Border", this.title)
            try {
                this.gui.BackColor := ThemeValueVariables["BackgroundColor"]
            }

            ; Listen to any loss in focus of the app's main window
            this.listenToFocus()

            ; Create the window
            this.localDrawWindow()

            ; Adding the outline window
            this.outline := Outline(this, position)

            ; Unhiding the main window and the outline window
            AnimateWindow(this.gui.hwnd, 50, "0xa0000")
            AnimateWindow(this.outline.gui.Hwnd, 50, "0xa0000")
        } else {
            throw NoWindowsError()
        }
    }

    __Delete() {
        AnimateWindow(this.gui.hwnd, 50, "0x90000")
        this.gui.Destroy()
    }

    /**
     * Method to start listening to any loss of foucs by a window of this class
     */
    listenToFocus() {
        DllCall("RegisterShellHookWindow", "ptr", A_ScriptHwnd)
        OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), FocusLost)
    }

    /**
     * Method to draw the main window of the app
     * @param windowsArray
     */
    localDrawWindow() {
        if (this.windowsArray.Length > 0) {
            for i in this.windowsArray {
                i.icon.draw(this.gui)
            }

            loop this.windowsArray.Length {
                if (this.windowsArray[A_Index].badge) {
                    this.windowsArray[A_Index].badge.draw(
                        this.gui,
                        this.windowsArray[A_Index].windowSubWindows.Length,
                        this.windowsArray[A_Index].icon.x,
                        this.windowsArray[A_Index].icon.y,
                        this.windowsArray[1].icon.size,
                        false
                    )
                }
            }

            Window.EnableShadow(this.gui.hwnd)

            this.w := (
                ((Icon.padding + this.windowsArray[1].icon.size) * this.windowsArray.Length) + Icon.padding
            )
            this.gui.Show("w" this.w " h" this.h " Hide")

            DetectHiddenWindows(true)

            WinGetPos(&xPos, &yPos, , , "ahk_id" this.gui.Hwnd)
            this.x := xPos
            this.y := yPos

            DetectHiddenWindows(false)
        }
    }
}