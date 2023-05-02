--===== FiveM Script =========================================
--= drugsale - YUPPZWORKSHOP CFX (Webhook)
--===== Developed By: ========================================
--= YUPPZWORKSHOP CFX
--= Copyright (C) YUPPZWORKSHOP CFX - All Rights Reserved
--= You are not allowed to sell this script or edit
--============================================================ 

ESX = nil
local StartSlleDrug = false
local CreateBag = nil
local NPC = nil
local Selling = false
local Blip = {}
local CancleDelay = false
local IsPress =false 
local CurTime = nil

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	print("^2 YUPPZWORKSHOP : Actived ! | Supports!^1")
    print("^2 DISCORD : ^2https:--discord.gg/KhnrE48Nfd")
end)


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()

end)

RegisterNetEvent("yuppz_drugsale:startsales")
AddEventHandler("yuppz_drugsale:startsales", function(itemname, price)
    if not StartSlleDrug then
        OpenMenuSellDrug(itemname, price)
    else
        PlayAnimation()
    end
end)


function OpenMenuSellDrug(itemname, price)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'startsales', {
        title = 'ขายยา',
        align = 'top-left',
        elements = {{
            label = 'เริ่มการขาย',
            value = 'sell'
        }, {
            label = 'ยกเลิก',
            value = 'cancel'
        }}
    }, function(data, menu)
        if data.current.value == 'cancel' then
            menu.close()
            return
        end

        if data.current.value == 'sell' then
            if not ResetDelay and not Selling then
                StartSlleDrug = true
                menu.close()
                StartSell(itemname, price)
            else
                if not CancleDelay then
                    CancleDelay = true
                    local total = math.floor(((GetGameTimer()/1000) - CurTime))
                    TriggerEvent("pNotify:SendNotification", {
                        text = "จะสามารถขายอีกครั้งใน "..((Config.CancelDelay/1000)-total).." วินาที",
                        type = "error",
                        queue = "lmao",
                        timeout = 3000,
                        layout = "centerRight"
                    })
                    menu.close()
                    Wait(1000)
                    CancleDelay = false
                end
            end
        end

    end, function(data, menu)
        menu.close()
    end)
end

local RandonNumber

function StartSell(itemname, price)
    RandonNumber = math.random(1, tablelength(Config.NPCSpawnPoint))
    local RandonZone = Config.NPCSpawnPoint[RandonNumber]
    CreateBlip(RandonZone.Pos)
    CreateBag = CreateObject(GetHashKey(Config.ItemInHand), 0.0, 0.0, 0.0, true)
    AttachEntityToEntity(CreateBag, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.10, 0.0, 0.0, 0.0, 280.0, 53.0, true, true, false, true, 1, true)
    CreateNPC(RandonZone.Model, RandonZone.Pos)
    Citizen.CreateThread(function()
		while true do
			Citizen.Wait(50)
			local letSleep = true
            if StartSlleDrug then
                letSleep = false
                exports["yuppz_textui"]:ShowHelpNotification("~w~Press ~g~[X]~w~ ยกเลิกขายยา")
           
                DrawTextScreen('', {
                    x = 0.5,
                    y = 0.1
                })
                if IsControlPressed(0, 73) and not Selling then
                    Reset()
                    ResetDelay = true
                    CurTime = (GetGameTimer()/1000)
                    Wait(Config.CancelDelay)
                    ResetDelay = false
                end

                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.NPCSpawnPoint[RandonNumber].Pos, true) < 1.0 then
                    ESX.ShowHelpNotification("")
                    letSleep = false
                    exports["yuppz_textui"]:ShowHelpNotification("กด ~INPUT_CONTEXT~ ~r~ขายยา")
                
                    if IsControlPressed(0, 38) and not Selling and not IsPress and not IsPedInAnyVehicle(GetPlayerPed(-1),true) then
                        IsPress = true
                        ESX.TriggerServerCallback("yuppz_drugsale:checkpolice", function(count)
                            if count >= Config.PoliceCount then
                                StartSlleDrug = true
                                Selling = true
                             --   TriggerEvent('maxez-police:alertNet', 'drugsales') 
                                TriggerEvent("yuppz_minigamecard:openui", 10, function(callback)
                                    if callback ~= nil then
                                        if callback == "win" then
                                            Win(itemname, price)
                                        elseif callback == "loss" then
                                            Loss()
                                            FreezePlayer()
                                        elseif callback == "timeout" then
                                            Reset(0)
                                        end
                                    end
                                end)
                                Wait(2000)
                                IsPress = false
                            else
                                TriggerEvent("pNotify:SendNotification", {
                                    text = 'ตำตรวจไม่เพียงพอ',
                                    type = "error",
                                    timeout = 3000,
                                    layout = "bottomCenter",
                                    queue = "global"
                                })
                                Wait(2000)
                                IsPress = false
                            end

                        end)
                    end
                end
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), RandonZone.Pos, true) < 30.0 then
                    NPCCoords = GetEntityBonePosition_2(NPC, GetPedBoneIndex(NPC, 12844))
                end
            end
            if letSleep then 
				Citizen.Wait(500)
			end
        end
    end)
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Selling then
            DisableAllControlActions(0)
            EnableControlAction(0,1,true)
            EnableControlAction(0,2,true)
        end
    end
end)

function Win(itemname, price)
    ESX.Streaming.RequestAnimDict(Config.Animations.Win.dict, function()
        TaskPlayAnim(GetPlayerPed(-1),Config.Animations.Win.dict, Config.Animations.Win.name, 8.0, 8.0, -1, 0, 0, false, false, false)
    end)

    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = Config.SellDelay,
        label = Config.Text,
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }
    }, function(status)
        if not status then
        end
    end)
    Wait(Config.SellDelay)
    TriggerServerEvent("yuppz_drugsale:sellsuccess", itemname, price)
    Reset(0)
end


function Loss()
    ESX.Streaming.RequestAnimDict(Config.Animations.Loss.dict, function()
        TaskPlayAnim(NPC, Config.Animations.Loss.dict, Config.Animations.Loss.name, 8.0, 8.0, -1, 0, 0, false, false, false)
    end)

-----------------------------    แจ้งเตือน
TriggerEvent('maxez-police:alertNet', 'drugsales') 
    local PedPosition = GetEntityCoords(PlayerPedId())
    local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
    TriggerServerEvent('esx_addons_gcphone:startCall', 'police', ('มีคนกำลังขายยา'), PlayerCoords, {
 PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
})
------------------------------   แจ้งเตือน
    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = Config.FreezeTime,
        label = Config.FreezeText,
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }
    }, function(status)
        if not status then
        end
    end)
    Reset(0)
end


function Reset(delay)
    if delay ~= nil then
        Wait(delay)
    end
    RemoveBlip(Blip1)
    RemoveBlip(Blip2)
    DeleteObject(CreateBag)
    DeleteEntity(NPC)
    Selling = false
    StartSlleDrug = false
end

function FreezePlayer()
    TriggerEvent("pNotify:SendNotification", {
        text = "ไม่สามารถเดินได้เป็นเวลา "..(Config.FreezeTime/1000).." วินาที",
        type = "error",
        queue = "lmao",
        timeout = 50000,
        layout = "bottomCenter"
    })
    FreezeEntityPosition(GetPlayerPed(-1), true)
    ESX.Streaming.RequestAnimDict('stungun@standing', function()
        TaskPlayAnim(GetPlayerPed(-1), 'stungun@standing', 'damage', 8.0, 8.0, -1, 1, 0, false, false, false)
    end)
    Wait(Config.FreezeTime)
    Reset(0)
    ClearPedTasks(GetPlayerPed(-1))
    FreezeEntityPosition(GetPlayerPed(-1), false)
end

function CreateNPC(Model, Pos)
    RequestModel(GetHashKey(Model))
    while (not HasModelLoaded(GetHashKey(Model))) do
        Citizen.Wait(1)
    end
    NPC = CreatePed(5, GetHashKey(Model), Pos.x, Pos.y, Pos.z - 1.0, 0.0, false, false)
    FreezeEntityPosition(NPC, true)
    SetEntityInvincible(NPC, true)
    SetBlockingOfNonTemporaryEvents(NPC, true)
    TaskStartScenarioInPlace(NPC, "WORLD_HUMAN_COP_IDLES", 0, true)
end

function DrawTextScreen(text, pos)
    DrawGenericTextThisFrame()
    SetTextFont(4)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(pos.x, pos.y)
end

function DrawGenericTextThisFrame()
    SetTextFont(4)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
end

function CreateBlip(Coords)
    Citizen.CreateThread(function()

        Blip1 = AddBlipForRadius(Coords, Config.Blips.Radius + .0)
        -- SetBlipSprite (Blip, 1)
        SetBlipHighDetail(Blip1, true)
        SetBlipColour(Blip1, 1)
        SetBlipAlpha(Blip1, 100)

        Blip2 = AddBlipForCoord(Coords)
        SetBlipHighDetail(Blip2, true)
        SetBlipSprite(Blip2, 1)
        SetBlipScale(Blip2, 1.0)
        SetBlipColour(Blip2, Config.Blips.Color)
        SetBlipAsShortRange(Blip2, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blips.Text)
        EndTextCommandSetBlipName(Blip1)
    end)
end

function PlayAnimation(dict, se)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
    TaskPlayAnim(GetPlayerPed(-1), dict, se, 8.0, 1.0, -1, 2, 0, 0, 0, 0)
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    SetTextScale(scaleX * scale, scaleY * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255) 
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x, y, z + 2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        DeleteObject(CreateBag)
        DeleteEntity(NPC)
    end
end)

