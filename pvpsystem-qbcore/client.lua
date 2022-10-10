local QBCore = exports['qb-core']:GetCoreObject()

counter = 0 -- IF COUNTER EQUALS 1 THE PLAYER IS IN THE QUEUE

-- MESSAGES
RegisterNetEvent("pvpsystem:msg")
AddEventHandler("pvpsystem:msg", function(numero)
	QBCore.Functions.Notify("You are in the arena: #"..numero, "success", 4000)
	SetGameplayCamRelativeHeading(0)
end)

RegisterNetEvent("pvpsystem:msgWon")
AddEventHandler("pvpsystem:msgWon", function()
    QBCore.Functions.Notify("You won!", "success", 4000)
	SetGameplayCamRelativeHeading(0)
    counter = 0
end)

RegisterNetEvent("pvpsystem:msgLost")
AddEventHandler("pvpsystem:msgLost", function()
	QBCore.Functions.Notify("You lost!", "error", 4000)
    SetGameplayCamRelativeHeading(0)
    counter = 0
end)

-- RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
--
-- end)

RegisterNetEvent("pvpsystem:msgQuit")
AddEventHandler("pvpsystem:msgQuit", function()
	QBCore.Functions.Notify("A player disconnected", "error", 4000)
	SetGameplayCamRelativeHeading(0)
end)

-- ADD PLAYER TO A QUEUE
RegisterNetEvent("pvpsystem:pvpqueue")
AddEventHandler("pvpsystem:pvpqueue", function(ident, player, args)
	if LocalPlayer.state['isLoggedIn'] then
		if (args==nil) then
			if (ident==1) then
				if (counter == 0) then
					QBCore.Functions.Notify("You joined the queue (1v1)", "primary", 4000)
					TriggerServerEvent("pvpsystem:counter1v1", source)
					counter = 1
				else
					QBCore.Functions.Notify("You are already in a queue", "error", 4000)
				end
			else
				if (counter == 0) then
					QBCore.Functions.Notify("You joined the queue (2v2)", "primary", 4000)
					TriggerServerEvent("pvpsystem:counter2v2", source)
					counter = 1
				else 
					QBCore.Functions.Notify("You are already in a queue", "error", 4000)
				end
			end
		else
			if (counter==0) then
				TriggerServerEvent("pvpsystem:comargs", player, args)
				counter = 1
			end
		end
	end
end)

-- REVIVE PLAYER
RegisterNetEvent("pvpsystem:revive")
AddEventHandler("pvpsystem:revive", function()
	NetworkResurrectLocalPlayer(-1497.45, 139.64, 55.65, true, true, false)
end)

RegisterNetEvent("pvpsystem:heal")
AddEventHandler("pvpsystem:heal", function(id)
	SetEntityHealth(GetPlayerFromServerId(id), 200)
end)

RegisterNetEvent("pvpsystem:request")
AddEventHandler("pvpsystem:request", function(id1, id2)
	if LocalPlayer.state['isLoggedIn'] then
		notification("pvpsystem:comargs", true, id1, id2, nil, nil, 30000, "1v1 Challenge! [ID] ".. id1)
	end
end)

function notification(trigger, isServer, params1, params2, params3, params4, time, text)
    SendNUIMessage({
        action = "request",
        text = text,
        time = time
    })
    local time2 = time - 1
    Citizen.SetTimeout(time, function()
        time2 = time + 1
    end)
    while time > time2 do
        if IsControlJustPressed(1, 246) then -- IF PRESSED Y
            if isServer == true then
                TriggerServerEvent(trigger, params1, params2, params3, params4)
                SendNUIMessage({close = true})
                break
            else 
                TriggerEvent(trigger, params1, params2, params3, params4)
                SendNUIMessage({close = true})
                break
            end
        elseif IsControlJustPressed(1, 303) then -- IF PRESSED U
            SendNUIMessage({close = true})
            break
        end
        Wait(1)
    end
end