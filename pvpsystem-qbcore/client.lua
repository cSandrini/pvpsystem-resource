local QBCore = exports['qb-core']:GetCoreObject()

counter = 0 -- IF COUNTER EQUALS 1 THE PLAYER IS IN THE QUEUE

-- MESSAGES
RegisterNetEvent("pvpsystem:notify")
AddEventHandler("pvpsystem:notify", function(text, typeMsg, time, heading)
	QBCore.Functions.Notify(text, typeMsg, time)
	if heading then SetGameplayCamRelativeHeading(0) end
end)

RegisterNetEvent("pvpsystem:cancelCounter")
AddEventHandler("pvpsystem:cancelCounter", function()
	counter = 0
end)

-- ADD PLAYER TO A QUEUE
RegisterNetEvent("pvpsystem:pvpqueue")
AddEventHandler("pvpsystem:pvpqueue", function(ident, player, args)
	if LocalPlayer.state['isLoggedIn'] then
		if (args==nil) then
			if (ident==1) then
				if (counter == 0) then
					QBCore.Functions.Notify("You joined the queue (1v1)", "success", 3000)
					TriggerServerEvent("pvpsystem:counter1v1", source)
					if (Config.developerMode == false) then
						counter = 1
					end
				else
					QBCore.Functions.Notify("You are already in a queue", "error", 3000)
				end
			else
				if (counter == 0) then
					QBCore.Functions.Notify("You joined the queue (2v2)", "success", 3000)
					TriggerServerEvent("pvpsystem:counter2v2", source)
					if (Config.developerMode == false) then
						counter = 1
					end
				else 
					QBCore.Functions.Notify("You are already in a queue", "error", 3000)
				end
			end
		else
			if (counter == 0) then
				TriggerServerEvent("pvpsystem:comargs", player, args)
				if (Config.developerMode == false) then
					counter = 1
				end
			end
		end
	end
end)

-- REVIVE PLAYER
RegisterNetEvent("pvpsystem:revive")
AddEventHandler("pvpsystem:revive", function(id)
	NetworkResurrectLocalPlayer(-1497.45, 139.64, 55.65, true, true, false)
	SetEntityHealth(GetPlayerFromServerId(id), 200)
end)

RegisterNetEvent("pvpsystem:heal")
AddEventHandler("pvpsystem:heal", function(id)
	SetEntityHealth(GetPlayerFromServerId(id), 200)
end)

RegisterNetEvent("pvpsystem:request")
AddEventHandler("pvpsystem:request", function(id1, id2, rounds)
	if LocalPlayer.state['isLoggedIn'] then
		notification("pvpsystem:comargs", true, id1, id2, rounds, 30000, "1v1 Challenge! [ID] ".. id1)
	end
end)

function notification(trigger, isServer, params1, params2, params3, time, text)
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
                TriggerServerEvent(trigger, params1, params2, params3)
                SendNUIMessage({close = true})
                break
            else 
                TriggerEvent(trigger, params1, params2, params3)
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