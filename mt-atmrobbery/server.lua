local QBCore = exports['qb-core']:GetCoreObject()
local Cooldown = false


-- hack
QBCore.Functions.CreateUseableItem('trojan_usb', function(source)
	local Player = QBCore.Functions.GetPlayer(source)
   TriggerClientEvent('hack:trojan_usb',source)
end)

-- Recompensa
RegisterServerEvent("mt-atmrobbery:success")
AddEventHandler("mt-atmrobbery:success",function()
	local Player =  QBCore.Functions.GetPlayer(source)
    local reward = math.random(Config.MinReward,Config.MaxReward)
	Player.Functions.AddItem(Config.Rewarditem, tonumber(reward))
    Player.Functions.RemoveItem("trojan_usb", 1)
	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.Rewarditem], "add")

end)

-- Cooldown
RegisterServerEvent('mt-atmrobbery:Server:BeginCooldown')
AddEventHandler('mt-atmrobbery:Server:BeginCooldown', function()
    Cooldown = true
    local timer = Config.Cooldown * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

QBCore.Functions.CreateCallback("mt-atmrobbery:Cooldown",function(source, cb)
    if Cooldown then
        cb(true)
    else
        cb(false)
        
    end
end)