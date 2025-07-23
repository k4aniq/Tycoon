using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Verse.org/Assets }
using { /Fortnite.com/UI }

Player_Tycoon_Class := class {
    AgentOB : agent

    var IsAlreadyOwnerOfTycoon : logic = false

    MainPlayerUIClass : Player_Tycoon_Main_UI = Player_Tycoon_Main_UI{}
}


Player_Tycoon_Main_UI := class {
    var AmountOfCashImage : texture = VerseUIImages.MoneyCurrencyAmount

    StringToMessage< localizes>(value:string) : message = "{value}"

    var AmountOfCash : text_block = text_block {
        DefaultTextColor := MakeColorFromHex("#FFFFFF")
    }

    Init(Player : player) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            PlayerUI.AddWidget(AddCashCurrencyUI())
        }
    }

    UpdateCash(Player : player, Cash : int) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            AmountOfCash.SetText(StringToMessage(AbbreviateNumber((Cash) * 1.0)))
        }
    }

    AbbreviateNumber(value:float) : string = {
        if (value >= 1000000000.0) {
            return ToTruncatedString(value / 1000000000.0, 2) + "B"
        } else if (value >= 1000000.0) {
            return ToTruncatedString(value / 1000000.0, 2) + "M"
        } else if (value >= 1000.0) {
            return ToTruncatedString(value / 1000.0, 2) + "K"
        } else {
            return ToTruncatedString(value, 0)
        }
    }

    ToTruncatedString< public>(Number:float, Decimals:int):[]char=
        var Str:[]char = ToString(Number)
        if:
            DotIndex := Str.Find['.']
            StopIndex := if (Decimals > 0) then Min(DotIndex+Decimals+1,Str.Length) else DotIndex
            if (StrT := Str.Slice[0, StopIndex]) {
                set Str = StrT
            }
        return Str


    AddCashCurrencyUI() : canvas = {
        NewCanvas := canvas{
            Slots := array {
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 219.165, Top := 1.875, Right := 502.33, Bottom := 300.832}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := texture_block:
                        DefaultImage := AmountOfCashImage
                }
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 216.0, Top := -16.54, Right := 169.50, Bottom := 41.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 1
                    Widget := AmountOfCash
                }      
            }
        }
    }
}