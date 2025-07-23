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
    var AmountOfCashImage : texture = UiImages.MoneyCurrencyAmount
    var AmountOfGemsImage : texture = UiImages.MoneyCurrencyAmount
    var AmountOfRebirthItemsImage : texture = UiImages.MoneyCurrencyAmount

    StringToMessage< localizes>(value:string) : message = "{value}"

    var AmountOfCash : text_block = text_block {
        DefaultTextColor := MakeColorFromHex("#FFFFFF")
    }

    var AmountOfGems : text_block = text_block {
        DefaultTextColor := MakeColorFromHex("#00FFFF")
    }

    var AmountOfRebirthItems : text_block = text_block {
        DefaultTextColor := MakeColorFromHex("#FF00FF")
    }

    Init(Player : player) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            PlayerUI.AddWidget(AddAllCurrencyUI())
        }
    }

    UpdateCash(Player : player, Cash : int) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            AmountOfCash.SetText(StringToMessage(AbbreviateNumber((Cash) * 1.0)))
        }
    }

    UpdateGems(Player : player, Gems : int) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            AmountOfGems.SetText(StringToMessage(AbbreviateNumber((Gems) * 1.0)))
        }
    }

    UpdateRebirthItems(Player : player, RebirthItems : int) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            AmountOfRebirthItems.SetText(StringToMessage(ToString(RebirthItems)))
        }
    }

    UpdateAllCurrencies(Player : player, Cash : int, Gems : int, RebirthItems : int) : void = {
        UpdateCash(Player, Cash)
        UpdateGems(Player, Gems)  
        UpdateRebirthItems(Player, RebirthItems)
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


    AddAllCurrencyUI() : canvas = {
        NewCanvas := canvas{
            Slots := array {
                # Cash UI
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
                # Gems UI
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 219.165, Top := 70.0, Right := 502.33, Bottom := 368.832}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := texture_block:
                        DefaultImage := AmountOfGemsImage
                }
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 216.0, Top := 51.46, Right := 169.50, Bottom := 109.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 1
                    Widget := AmountOfGems
                }
                # Rebirth Items UI
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 219.165, Top := 138.0, Right := 502.33, Bottom := 436.832}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := texture_block:
                        DefaultImage := AmountOfRebirthItemsImage
                }
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 216.0, Top := 119.46, Right := 169.50, Bottom := 177.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 1
                    Widget := AmountOfRebirthItems
                }      
            }
        }
    }
}