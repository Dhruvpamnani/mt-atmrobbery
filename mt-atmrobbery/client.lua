local QBCore = exports['qb-core']:GetCoreObject()
local CurrentCops = -0

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('qb-police:SetCopCount')
AddEventHandler('qb-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

RegisterNetEvent('mt-atmrobbery:client:roubar', function()
    RobAtm()
end)

function RobAtm()
	local pos = GetEntityCoords(PlayerPedId())
	if LocalPlayer.state.isLoggedIn then
		QBCore.Functions.TriggerCallback("mt-atmrobbery:Cooldown", function(cooldown)
			if not cooldown then
				if CurrentCops >= 0 then
					QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasItem)
						if hasItem then
							PoliceCall()
							local minigame = exports['hackingminigame']:Open()   
                               if(minigame == true) then -- success
							   ClearPedTasksImmediately(PlayerPedId())
							   HackSuccess() 
							else
								Citizen.Wait(1000)
							    ClearPedTasksImmediately(PlayerPedId())
								HackFailed()
							end
						else
							QBCore.Functions.Notify("Força bruta não vai funcionar aqui", "error")
						end
					end, "trojan_usb")
				else
					QBCore.Functions.Notify("Sem policias", "error")
				end
			else
				QBCore.Functions.Notify("ATM foi roubado recentemente, Tempo de espera do sistema ativo ")
			end
		end)
	else
		Citizen.Wait(3000)
	end
end

function RobbingTheMoney()
    Anim = true
    QBCore.Functions.Progressbar("power_hack", "A encher saco de dinheiro...", (7500), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@heists@ornate_bank@grab_cash_heels",
        anim = "grab",
        flags = 16,
    }, {
       model = "prop_cs_heist_bag_02",
       bone = 57005,
       coords = { x = -0.005, y = 0.00, z = -0.16 },
       rotation = { x = 250.0, y = -30.0, z = 0.0 },


    }, {}, function() -- Done
        Anim = false
        StopAnimTask(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 1.0)
		SetPedComponentVariation((PlayerPedId()), 5, 47, 0, 0)

    end, function() -- Cancel
        Anim = false
        StopAnimTask(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 1.0)
		
    end)
    
    Citizen.CreateThread(function()
        while Anim do
            TriggerServerEvent('qb-hud:Server:gain:stress', math.random(2, 3))
            Citizen.Wait(12000)
        end
    end)
end

function HackFailed()
	QBCore.Functions.Notify("Fds és uma merda como é que falhas-te isso?")
    if math.random(1, 100) <= 40 and IsWearingHandshoes() then
		TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
		QBCore.Functions.Notify("Deixas-te impressões digitais no ATM...")
	end
end

function HackSuccess()
	QBCore.Functions.Notify("Sucesso!")
    ClearPedTasksImmediately(PlayerPedId())
	RobbingTheMoney()
	TriggerServerEvent("mt-atmrobbery:success")	
    TriggerServerEvent('mt-atmrobbery:Server:BeginCooldown')
end

function PoliceCall()
    local chance = 75
    if GetClockHours() >= 0 and GetClockHours() <= 6 then
        chance = 50
    end
    if math.random(1, 100) <= chance then
        TriggerServerEvent('police:server:policeAlert', 'ASSALTO A ATM EM CONCURSO')
    end
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

local prop = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm",
}
  exports['qb-target']:AddTargetModel(prop, {
      options = {
          {
              type = "client",
              event = "mt-atmrobbery:client:roubar",
              icon = "fas fa-user-secret",
              label = "ROUBAR ATM",
        },
    },
        distance = 2.0    
})
