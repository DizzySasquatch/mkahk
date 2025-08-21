#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 3
#Include Lib/config.ahk
; #HotIf WinActive("ahk_exe " conf.mumuExe)

; @region intelli-sense helpers

/**
 * @typedef {Gui} GenericUI
 * @property {Map<string, Gui.Control>} Controls
 */
Gui.Prototype.Controls := Map()

; @endregion

defaultWinName := "Default"
toggle := false

/**
 * @type {Config}
 */
conf := Config.Load("config.json")

if (!conf.instanceName or conf.instanceName = '')
{
    conf.instanceName := defaultWinName
}
if (!conf.mumuExe or conf.mumuExe = '')
{
    conf.mumuExe := "MuMuNxDevice.exe"
}
if (!conf.skipUpdate or conf.skipUpdate = '')
{
    conf.skipUpdate := false
    UpdateScript() 
}

clearBookColors := [
    "Gray",
    "Green",
    "Blue",
    "All"
]
selectedClearBookColor := clearBookColors[1]

cardX := 430
cardColors := [
    { Index: 1, Name: "Gray", X: cardX, Y: 317 },
    { Index: 2, Name: "Green", X: cardX, Y: 353 },
    { Index: 3, Name: "Blue", X: cardX, Y: 390 },
    { Index: 4, Name: "Red", X: cardX, Y: 426 },
    { Index: 5, Name: "Purple", X: cardX, Y: 463 },
]
cardBackground := 0xE3E3E3
cardColorNames := []
for color in cardColors
{
    cardColorNames.Push(color.Name)
}
selectedColorIndex := 5
winSize := { Width: 1336, Height: 788 }

keyOpenBox := "Z" ; place key on "s" in "Use" when having boxes open
keyOpenDisassemble := "U" ; place key on the bin icon
keyDisassembleGrey := "I" ; place key on the grey icon in the disassemble menu
keyDisassembleGreen := "O" ; same in green
keyDisassembleBlue := "L" ; same in blue
keyDisassembleOk := "P" ; place key on "Bulk Disassemble" button

keyLevel := "N"
keyReset := "M"
keyConfirm := "K"

keyGreyScroll := "W"
numGreyScroll := 7
keyGreenScroll := "G"
numGreenScroll := 10
keyBlueScroll := "B"
numBlueScroll := 10
keyScrollRefresh := "R"
keyScrollMax := "H"
keyScrollCraft := "V"
keyScrolls := [
    [keyGreyScroll, numGreyScroll],
    [keyGreenScroll, numGreenScroll],
    [keyBlueScroll, numBlueScroll],    
]

; @region UI

/**
 * @type {GenericUI}
 */
ui := Gui()
ui.OnEvent('Close', (*) => conf.Save())

dummy := ui.Controls

ui.AddText(, "Name of Instance:")
ui.Controls["edit"] := ui.AddEdit('xm w200 r1', conf.instanceName)
ui.Controls["edit"].OnEvent('Change', updateTitle)

updateTitle(con, info)
{
    conf.instanceName := con.Value || defaultWinName
}

ui.Controls["OpenBoxes"] := ui.AddButton(,"Open Boxes")
ui.Controls["OpenBoxes"].OnEvent('Click', (*) => OpenBoxes())

ui.Controls["LevelReset"] := ui.AddButton(,"Level Reset")
ui.Controls["LevelReset"].OnEvent("Click", (*) => LevelReset())

ui.AddText(,"Clear Books")
ui.Controls["ClearBookTier"] := ui.AddDropDownList("Choose1 Section", clearBookColors)
ui.Controls["ClearBookTier"].OnEvent('Change', OnClearBookTierChange)
OnClearBookTierChange(con, info) {
    global selectedClearBookColor := con.Value
}
ui.Controls["ClearBooks"] := ui.AddButton("ys","Clear Books")
ui.Controls["ClearBooks"].OnEvent("Click", (*) => ClearBooks(selectedClearBookColor))

ui.Controls["TierSelect"] := ui.AddDropDownList("Choose1 Section xs", cardColorNames)
ui.Controls["TierSelect"].Choose(selectedColorIndex)
ui.Controls["TierSelect"].OnEvent('Change', OnTierSelectChange)
OnTierSelectChange(con, info) {
    global selectedColorIndex := con.Value
}
ui.Controls["RollCard"] := ui.AddButton("ys","Roll Card")
ui.Controls["RollCard"].OnEvent("Click", (*) => RollCard())

ui.Controls["Update"] := ui.AddButton("xs","Update Script")
ui.Controls["Update"].OnEvent("Click", (*) => UpdateScript())

ui.Controls["Exit"] := ui.AddButton("xs", "Cancel")
ui.Controls["Exit"].OnEvent("Click", (*) => Cancel())

ui.Show('W250 H310')
; @endregion

Cancel() {
    global toggle := false
}

LevelReset() {

    global toggle := !toggle

    if (!toggle)
    {
        return
    }

    WinActivate(conf.instanceName " ahk_exe " conf.mumuExe)
    mumuId := WinActive("ahk_exe " conf.mumuExe)
    game := "ahk_id " mumuId

    while (toggle) {
        ControlSend keyLevel, , game
        Sleep 500
        if (!toggle) {
            return
        }

        outPutX := 0
        outPutY := 0

        if (ImageSearch(&outPutX, &outPutY, 3650, 910, 3690, 940, "*20 45.png") == 1) {
            ControlSend keyReset, , game
            Sleep 500

            ControlSend keyConfirm, , game
            Sleep 500
        }
        if (!toggle) {
            return
        }
    }
}

OpenBoxes() {
    global toggle := !toggle

    if (!toggle)
    {
        return
    }
    
    WinActivate(conf.instanceName " ahk_exe " conf.mumuExe)
    mumuId := WinActive("ahk_exe " conf.mumuExe)
    game := "ahk_id " mumuId

    while (toggle)
    {
        ControlSend keyOpenBox, , game
        Sleep 500
        if (!toggle) {
            return
        }
        ControlSend keyOpenBox, , game
        Sleep 500
        if (!toggle) {
            return
        }
        ControlSend keyOpenBox, , game
        Sleep 500
        if (!toggle) {
            return
        }
        ControlSend keyopendisassemble, , game
        Sleep 100
        ControlSend keyDisassembleGrey, , game
        ControlSend keyDisassembleGreen, , game
        ControlSend keyDisassembleBlue, , game
        Sleep 100
        ControlSend keyDisassembleOk, , game
        Sleep 500
        ControlSend keyOpenBox, , game
        Sleep 500
        ControlSend keyOpenBox, , game
        Sleep 500
    }
}

ClearBooks(type) {
    if (type = clearBookColors.Length) {
        ClearBooks(1)
        ClearBooks(2)
        ClearBooks(3)
    }

    global toggle := !toggle

    if (!toggle)
    {
        return
    }

    WinActivate(conf.instanceName " ahk_exe " conf.mumuExe)
    mumuId := WinActive("ahk_exe " conf.mumuExe)
    game := "ahk_id " mumuId

    count := 0

    while (count < 3 && toggle) {
        ControlSend keyScrolls[type][1], , game
        Sleep 500

        ControlSend keyScrollRefresh, , game
        Sleep 500

        i := 0
        while (i < keyScrolls[type][2] + count && toggle) {
            ControlSend keyScrollRefresh, , game
            Sleep 200

            i++
        }

        if(!toggle) {
            break
        }

        count++

        ControlSend keyScrollMax, , game
        Sleep 500

        ControlSend keyScrollCraft, , game
        Sleep 750

        ControlSend keyScrolls[type][1], , game
        Sleep 500

        ControlSend keyScrolls[type][1], , game
        Sleep 500
    }

    global toggle := false
}

RollCard()
{
    global toggle := !toggle

    if (!toggle)
    {
        return
    }

    WinActivate(conf.instanceName " ahk_exe " conf.mumuExe)
    mumuId := WinActive("ahk_exe " conf.mumuExe)
    game := "ahk_id " mumuId
    WinMove(,, winSize.Width, winSize.Height, game)

    CoordMode("Pixel", "Window")

    purple := cardColors[5]
    if (not ColorIsApproximatelyEqual(cardBackground, PixelGetColor(purple.X, purple.Y)))
    {
        return
    }
    while (toggle)
    {
        ControlSend keyConfirm, , game
        Sleep 250

        for index, color in cardColors
        {
            if (index < selectedColorIndex)
            {
                continue
            }
            foundColor := PixelGetColor(color.X, color.Y)
            if (not ColorIsApproximatelyEqual(cardBackground, foundColor))
            {
                global toggle := false
                return
            }
        }
    }
}

ColorIsApproximatelyEqual(color1, color2, tolerance := 35)
{
    r1 := (color1 >> 16) & 0xFF
    g1 := (color1 >> 8) & 0xFF
    b1 := color1 & 0xFF

    r2 := (color2 >> 16) & 0xFF
    g2 := (color2 >> 8) & 0xFF
    b2 := color2 & 0xFF

    dr := r1 - r2
    dg := g1 - g2
    db := b1 - b2

    return Sqrt(dr**2 + dg**2 + db**2) <= tolerance
}

UpdateScript()
{
    try
    {
        RunWait(A_ComSpec " /C git fetch origin", , "Hide")
        RunWait(A_ComSpec " /C git rev-parse HEAD > version.txt", , "Hide")
        localVersion := Trim(FileRead("version.txt"))
        FileDelete("version.txt")
        RunWait(A_ComSpec " /C git rev-parse origin/main > remoteVersion.txt", , "Hide")
        remoteVersion := Trim(FileRead("remoteVersion.txt"))
        FileDelete("remoteVersion.txt")
        if (localVersion != remoteVersion)
        {
            result := MsgBox("A new version is available. Do you want to update?", , "YesNo")
            if (result = "Yes")
            {
                RunWait(A_ComSpec " /C git reset --hard origin/main", , "Hide")
                Reload()
                Sleep(1000)
                return
            }
            return
        }
        MsgBox("Your Script is up to date.", , "OK")
    }
    catch Error as e
    {
        MsgBox(e.Message, "Failed to update")
    }
}
