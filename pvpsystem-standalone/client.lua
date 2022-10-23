counter = 0 -- IF COUNTER EQUALS 1 THE PLAYER IS IN THE QUEUE

-- MESSAGES
RegisterNetEvent("pvpsystem:notify")
AddEventHandler("pvpsystem:notify", function(text, heading)
	notify(text)
	if heading then SetGameplayCamRelativeHeading(0) end
end)

-- ADD PLAYER TO A QUEUE
RegisterNetEvent("pvpsystem:pvpqueue")
AddEventHandler("pvpsystem:pvpqueue", function(ident, player, args)
		if (args==nil) then
			if (ident==1) then
				if (counter == 0) then
					notify("~g~You joined the queue (1v1)")
					TriggerServerEvent("pvpsystem:counter1v1", source)
					counter = 1
				else
					notify("~r~You are already in a queue")
				end
			else
				if (counter == 0) then
					notify("~g~You joined the queue (2v2)")
					TriggerServerEvent("pvpsystem:counter2v2", source)
					counter = 1
				else 
					notify("~r~You are already in a queue")
				end
			end
		else
			if (counter==0) then
				TriggerServerEvent("pvpsystem:comargs", player, args)
				counter = 1
			end
		end
end)

-- REVIVE PLAYER
RegisterNetEvent("pvpsystem:revive")
AddEventHandler("pvpsystem:revive", function()
	NetworkResurrectLocalPlayer(-1497.45, 139.64, 55.65, true, true, false)
    SetEntityHealth(GetPlayerFromServerId(id), 200)
end)

RegisterNetEvent("pvpsystem:request")
AddEventHandler("pvpsystem:request", function(id1, id2)
	notification("pvpsystem:comargs", true, id1, id2, nil, nil, 30000, "1v1 Challenge! [ID] ".. id1)
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

-- NOTIFICATIONS
function notify(str)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(str)
    EndTextCommandThefeedPostTicker(true, false)
end