counter = 0 -- IF COUNTER EQUALS 1 THE PLAYER IS IN THE QUEUE

-- MESSAGES
RegisterNetEvent("pvpsystem:msg")
AddEventHandler("pvpsystem:msg", function(numero)
	notify("You are in the arena: ~b~#"..numero) 
	SetGameplayCamRelativeHeading(0)
end)

RegisterNetEvent("pvpsystem:msgWon")
AddEventHandler("pvpsystem:msgWon", function()
    notify("~g~You won!") 
	SetGameplayCamRelativeHeading(0)
    counter = 0
end)

RegisterNetEvent("pvpsystem:msgLost")
AddEventHandler("pvpsystem:msgLost", function()
    notify("~r~You lost!") 
    SetGameplayCamRelativeHeading(0)
    counter = 0
end)

RegisterNetEvent("pvpsystem:msgQuit")
AddEventHandler("pvpsystem:msgQuit", function()
	notify("A player disconnected") 
	SetGameplayCamRelativeHeading(0)
end)

-- ADD PLAYER TO A QUEUE
RegisterNetEvent("pvpsystem:pvpqueue")
AddEventHandler("pvpsystem:pvpqueue", function(ident)
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
end)

-- NOTIFICATIONS
function notify(str)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(str)
    EndTextCommandThefeedPostTicker(true, false)
end