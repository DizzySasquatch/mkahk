#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 3
; #HotIf WinActive("ahk_exe MuMuPlayer.exe")

defaultWinName := "Default"
toggle := false
winName := defaultWinName

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
selectedColorIndex := 1
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
keyScrolls := [ [keyGreyScroll, numGreyScroll], [keyGreenScroll, numGreenScroll], [keyBlueScroll, numBlueScroll] ]


ui := Gui()

ui.AddText(, "Name of Instance:")
ui.edit := ui.AddEdit('xm w200 r1', defaultWinName)
ui.edit.OnEvent('Change', updateTitle)

updateTitle(con, info) {
    if (con.Value = '')
        global winName := defaultWinName
    else winName := con.Value
}

ui.openBoxes := ui.AddButton(,"Open Boxes")
ui.openBoxes.OnEvent('Click', (*) => OpenBoxes())

ui.restLevel := ui.AddButton(,"Level Reset")
ui.restLevel.OnEvent("Click", (*) => LevelReset())

ui.ClearGreyBooks := ui.AddButton(,"Clear grey Books")
ui.ClearGreyBooks.OnEvent("Click", (*) => ClearBooks(1))

ui.ClearGreenBooks := ui.AddButton(,"Clear green Books")
ui.ClearGreenBooks.OnEvent("Click", (*) => ClearBooks(2))

ui.ClearBlueBooks := ui.AddButton(,"Clear blue Books")
ui.ClearBlueBooks.OnEvent("Click", (*) => ClearBooks(3))

ui.ClearAllBooks := ui.AddButton(,"Clear all Books")
ui.ClearAllBooks.OnEvent("Click", (*) => ClearAllBooks())

ui.tierSelect := ui.AddDropDownList("Choose1", cardColorNames)
ui.tierSelect.OnEvent('Change', color_change)

color_change(con, info) {
    global selectedColorIndex := con.Value
}

ui.RollCard := ui.AddButton(,"Roll Card")
ui.RollCard.OnEvent("Click", (*) => RollCard())


ui.Exit := ui.AddButton(,"Cancel")
ui.Exit.OnEvent("Click", (*) => Cancel())

ui.Show('W250 H310')

Cancel() {
    global toggle := false
}

LevelReset() {

    global toggle := !toggle

    if(!toggle) {
        return
    }

    WinActivate(winName " ahk_exe MuMuPlayer.exe")
    mumuId := WinActive("ahk_exe MuMuPlayer.exe")
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

    if(!toggle) {
        return
    }
    
    WinActivate(winName " ahk_exe MuMuPlayer.exe")
    mumuId := WinActive("ahk_exe MuMuPlayer.exe")
    game := "ahk_id " mumuId

    while (toggle) {
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

ClearAllBooks() {
    ;still cancel for each ClearBooks needed
    ClearBooks(1)
    ClearBooks(2)
    ClearBooks(3)
}

ClearBooks(type) {

    global toggle := !toggle

    if(!toggle) {
        return
    }

    WinActivate(winName " ahk_exe MuMuPlayer.exe")
    mumuId := WinActive("ahk_exe MuMuPlayer.exe")
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

    WinActivate(winName " ahk_exe MuMuPlayer.exe")
    mumuId := WinActive("ahk_exe MuMuPlayer.exe")
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
