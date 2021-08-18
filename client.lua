local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

var = 1
counter = 0 -- IF COUNTER EQUALS 1 THE PLAYER IS IN THE QUEUE
induo = false
owner=false
myduo = {}

RegisterNetEvent("msg")
AddEventHandler("msg", function(numero)
    notify("Você está na arena: ~b~#"..numero) 
    SetGameplayCamRelativeHeading(0)
end)

RegisterNetEvent("msgWon")
AddEventHandler("msgWon", function()
    notify("~g~You won!") 
    SetGameplayCamRelativeHeading(0)
    counter = 0
end)

RegisterNetEvent("msgLost")
AddEventHandler("msgLost", function()
    notify("~r~You lost!") 
    SetGameplayCamRelativeHeading(0)
    counter = 0
end)

RegisterNetEvent("filapvp")
AddEventHandler("filapvp", function()
    if (counter == 0) then
        notify("~g~You joined the queue")
        TriggerServerEvent("pvpsource", source)
        counter = 1
    else 
        notify("~r~You are already in a queue")
    end
end)

RegisterNetEvent("pvpsystem:owner")
AddEventHandler("pvpsystem:owner", function()
    owner = true
end)

RegisterNetEvent("pvpsystem:duoadd")
AddEventHandler("pvpsystem:duoadd", function(ownerid, friendid)
    local verify=false
    for i in pairs(myduo) do
        if (friendid==myduo[i]) then
            verify=true
        end
    end
    if (verify==false) then
        induo = true
        table.insert(myduo, friendid)
    end
end)

RegisterNetEvent("pvpsystem:duoexit")
AddEventHandler("pvpsystem:duoexit", function(duo_id)
    if (induo==true and duo_id==myduo[1])  then
        owner = false
        induo = false
        myduo = {}
        TriggerEvent("chatMessage", "You left the team", {255,100,100})
    else
        TriggerEvent("chatMessage", "You don't have a team", {220,220,220})
    end
end)

------- MEMBROS -------------------------

RegisterCommand("member", function()
	if myduo[1] then
		TriggerEvent("chatMessage", "Your duo: ",{255,255,255},"[ID] ".. myduo[1])
	else
		TriggerEvent("chatMessage", "You don't have a team",{255,100,100})
	end
end)

-------- 2v2 -----------
RegisterCommand("2v2", function()
    if (myduo[1]~=nil and owner==true) then
        if (counter==0) then
            notify("~g~You joined the queue")
            TriggerServerEvent("pvpsystem:enter2v2queue", myduo[1])
            counter = 1
        else
            notify("~r~You are already in a queue")
        end
    elseif (myduo[1] and owner==false) then
        TriggerEvent("chatMessage","You aren't the owner of your team!", {255,110,110})
    else
        TriggerEvent("chatMessage","You need a team to go 2v2!", {255,110,110})
    end
end)

--------------------------------------------

function notify(str)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(str)
    EndTextCommandThefeedPostTicker(true, false)
end