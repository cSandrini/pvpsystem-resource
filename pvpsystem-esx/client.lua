ESX = exports["es_extended"]:getSharedObject()

counter = 0 -- IF COUNTER EQUALS 1 THE PLAYER IS IN THE QUEUE

-- MESSAGES
RegisterNetEvent("pvpsystem:msg")
AddEventHandler("pvpsystem:msg", function(numero)
	ESX.TextUI("You are in the arena: #"..numero, "success")
	SetGameplayCamRelativeHeading(0)
end)

RegisterNetEvent("pvpsystem:msgWon")
AddEventHandler("pvpsystem:msgWon", function()
    ESX.TextUI("You won!", "success")
	SetGameplayCamRelativeHeading(0)
    counter = 0
end)

RegisterNetEvent("pvpsystem:msgLost")
AddEventHandler("pvpsystem:msgLost", function()
	ESX.TextUI("You lost!", "error")
    SetGameplayCamRelativeHeading(0)
    counter = 0
end)

-- ADD PLAYER TO A QUEUE
RegisterNetEvent("pvpsystem:pvpqueue")
AddEventHandler("pvpsystem:pvpqueue", function(ident, player, args)
	if ESX.IsPlayerLoaded() then
		if (args==nil) then
			if (ident==1) then
				if (counter == 0) then
					ESX.TextUI("You joined the queue (1v1)", "success")
					TriggerServerEvent("pvpsystem:counter1v1", source)
					counter = 0
				else
					ESX.TextUI("You are already in a queue", "error")
				end
			else
				if (counter == 0) then
					ESX.TextUI("You joined the queue (2v2)", "success")
					TriggerServerEvent("pvpsystem:counter2v2", source)
					counter = 0
				else 
					ESX.TextUI("You are already in a queue", "error")
				end
			end
		else
			if (counter==0) then
				TriggerServerEvent("pvpsystem:comargs", player, args)
				counter = 0
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
	if ESX.IsPlayerLoaded() then
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