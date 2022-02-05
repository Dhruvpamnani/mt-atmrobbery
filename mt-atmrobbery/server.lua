local QBCore = exports['qb-core']:GetCoreObject()

-- Dar item
RegisterServerEvent("mt-atmrobbery:success")
AddEventHandler("mt-atmrobbery:success",function()
	local Player =  QBCore.Functions.GetPlayer(source)
    local reward = math.random(1,2)
	Player.Functions.AddItem("markedbills", tonumber(reward))
	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["markedbills"], "add")
end)