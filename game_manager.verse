using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags } 

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

player_data := class< final>< persistable>{
    Cash : int = 0
    Gems : int = 0
    RebirthItems : int = 0

    SavedButtonStruct : []int = array{}
}

player_data_update< constructor>(OldStat:player_data)< transacts> := player_data {
    Cash := OldStat.Cash
    Gems := OldStat.Gems
    RebirthItems := OldStat.RebirthItems
    SavedButtonStruct := OldStat.SavedButtonStruct
}

var Data:weak_map(player, player_data) = map{}

game_manager_tag := class(tag){}

# A Verse-authored creative device that can be placed in a level
game_manager := class(creative_device):

    var PlayerMap : [agent]Player_Tycoon_Class = map{}

    @editable TycoonSaves : logic = true

    @editable PropAnimationInsteadOfTeleport_PossiblyGlitch_ : logic = false

    # Runs when the device is started in a running game
    OnBegin< override>()< suspends>:void=
        # TODO: Replace this with your code
        for (Player : GetPlayspace().GetPlayers()) {
            OnPlayerSpawned(Player)
        }

        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerSpawned)

        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)

    OnPlayerSpawned(Player : player) : void = {
        if (not Data[Player]) {
            if (set Data[Player] = player_data{}) {}
        }

        if (Agent := agent[Player], not PlayerMap[Agent]) {
            PTC : Player_Tycoon_Class = Player_Tycoon_Class{AgentOB := Agent}

            PTC.MainPlayerUIClass.Init(Player)

            option:
                set PlayerMap[Agent] = PTC
        }

        if (TycoonSaves = false) {
            if (PlayerData := Data[Player]) {

                if:
                    OldData := Data[Player]

                    set Data[Player] = player_data {
                        player_data_update< constructor>(OldData)
                        SavedButtonStruct := array{}
                    }
                then:
                    Print("Player data has been reset")
                    
                if:
                    OldData := Data[Player]
    
                    set Data[Player] = player_data{
                        player_data_update< constructor>(OldData)
                        Cash := 0
                        Gems := 0
                        RebirthItems := 0 
                    }
                then:
            }     
        }
    }

    GetManager()< decides>< transacts>:game_manager = {
        OBJ := GetCreativeObjectsWithTag(game_manager_tag{})[0]
        game_manager[OBJ]
    }

    GetCurrentCash< public>(Player : player)<decides><transacts> : int = {
        return Data[Player].Cash
    }

    GetCurrentGems< public>(Player : player)<decides><transacts> : int = {
        return Data[Player].Gems
    }

    GetCurrentRebirthItems< public>(Player : player)<decides><transacts> : int = {
        return Data[Player].RebirthItems
    }

    GetPlayerTycoonClass< public>(Agent : agent)<decides><transacts> : Player_Tycoon_Class = {
        return GetManager[].PlayerMap[Agent]
    }

    AddToCash< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Cash := OldData.Cash + Amount 
                }
            then:
        }   
    }

    RemoveFromCash< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Cash := OldData.Cash - Amount 
                }
            then:
        }
    }

    AddToGems< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Gems := OldData.Gems + Amount 
                }
            then:
        }   
    }

    RemoveFromGems< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Gems := OldData.Gems - Amount 
                }
            then:
        }
    }

    AddToRebirthItems< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    RebirthItems := OldData.RebirthItems + Amount 
                }
            then:
        }   
    }

    RemoveFromRebirthItems< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    RebirthItems := OldData.RebirthItems - Amount 
                }
            then:
        }
    }

    AddToTycoonArray< public>(Player : player, Amount : int) : void = {
        if (PlayerData := Data[Player]) {
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    SavedButtonStruct := OldData.SavedButtonStruct + array{Amount} 
                }
            then:
                Print("Key should be saved to player value {Amount}")
                for (Key : OldData.SavedButtonStruct) {
                    Print("Key: {Key}")
                }
        }   
    }

    GetCurrentTycoonArray< public>(Player : player)< decides>< transacts> : []int = {
        return Data[Player].SavedButtonStruct
    }

    # Rebirth function - resets cash but gives rebirth items based on current cash
    PerformRebirth< public>(Player : player) : void = {
        if (PlayerData := Data[Player]) {
            CurrentCash := PlayerData.Cash
            RebirthItemsToGrant := CurrentCash / 1000000  # 1 rebirth item per million cash
            
            if:
                OldData := Data[Player]

                set Data[Player] = player_data{
                    player_data_update< constructor>(OldData)
                    Cash := 0
                    RebirthItems := OldData.RebirthItems + RebirthItemsToGrant
                    SavedButtonStruct := array{}  # Reset tycoon progress
                }
            then:
                Print("Player performed rebirth and gained {RebirthItemsToGrant} rebirth items")
        }   
    }


    OnPlayerRemoved(PlayerLeft : agent):void =
        if (Agent := agent[PlayerLeft]):
            if (ActualPlayer := PlayerMap[Agent]):
                var TempAllPlayerMap : [agent]Player_Tycoon_Class = map{}
                for (Key -> Value : PlayerMap, Key <> Agent):
                    set TempAllPlayerMap = ConcatenateMaps(TempAllPlayerMap, map{Key => Value})

                set PlayerMap = TempAllPlayerMap