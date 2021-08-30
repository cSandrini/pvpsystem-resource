local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")


id = nil
-- HEALTH LIMIT TO GET IN COMA (DIE)
healthlimit = 120 -- CHANGE TO HEALTH LIMIT OF YOUR SERVER IF DOESN'T WORK

-- VARS TO 1v1
count = 1
queue1v1 = {}
initialdimension1v1 = 1000
dimension1v1 = initialdimension1v1 -- INITIAL DIMENSION 1V1

-- VARS TO 2v2
queue2v2={}
initialdimension2v2 = 1200
dimension2v2 = initialdimension2v2 -- INITIAL DIMENSION 2V2

-- DISABLE VEHICLES IN THE SOME DIMENSIONS
for i = (initialdimension1v1+300),initialdimension1v1,-1 do 
   SetRoutingBucketEntityLockdownMode(i, "strict")
end

for i = (initialdimension2v2+300),initialdimension2v2,-1 do 
   SetRoutingBucketEntityLockdownMode(i, "strict")
end

-- ADD A PLAYER TO THE 1V1 QUEUE
RegisterServerEvent("pvpsystem:counter1v1")
AddEventHandler("pvpsystem:counter1v1", function()
	table.insert(queue1v1, source)
end)

-- ADD A TEAM TO THE 2V2 QUEUE
RegisterServerEvent("pvpsystem:counter2v2")
AddEventHandler("pvpsystem:counter2v2", function()
	table.insert(queue2v2, source)
end)

-- 1V1
Citizen.CreateThread(function()
	while true do
	    if (#queue1v1>=2) then
		-- PLAYER 1
	    SetEntityCoords(queue1v1[1], -1748.63, 175.88, 64.37, true, true, true, false)
	    SetEntityHeading(queue1v1[1], 210.26)
	    SetPlayerRoutingBucket(queue1v1[1], dimension1v1) -- DIMENSION
	    --
	    RemoveAllPedWeapons(queue1v1[1], false)
	    GiveWeaponToPed(queue1v1[1], GetHashKey("weapon_pistol_mk2"), 200, true)
	    SetCurrentPedWeapon(queue1v1[1], GetHashKey("weapon_pistol_mk2"), true)

	    TriggerClientEvent("pvpsystem:msg", queue1v1[1], 1)

		-- PLAYER 2
	    SetEntityCoords(queue1v1[2], -1727.01, 145.06, 64.4, true, true, true, false)
	    SetEntityHeading(queue1v1[2], 38.05)
	    SetPlayerRoutingBucket(queue1v1[2], dimension1v1) -- DIMENSION
	    --
	    RemoveAllPedWeapons(queue1v1[2], false)
	    GiveWeaponToPed(queue1v1[2], GetHashKey("weapon_pistol_mk2"), 200, true)
	    SetCurrentPedWeapon(queue1v1[2], GetHashKey("weapon_pistol_mk2"), true)

	    TriggerClientEvent("pvpsystem:msg", queue1v1[2], 1)

	    TriggerEvent("pvpsystem:die1v1", queue1v1[1], queue1v1[2]) -- CHECK IF ANY PLAYER DIE

	    dimension1v1 = dimension1v1 + 1 
	   	table.remove(queue1v1, 2)
		table.remove(queue1v1, 1)
		end
    Citizen.Wait(1200)
  	end
end)

-- 1V1 COMMAND 
RegisterCommand("1v1", function(source)
	TriggerClientEvent("pvpsystem:pvpqueue", source, 1)
end)

-- 2V2 COMMAND 
RegisterCommand("2v2", function(source)
	TriggerClientEvent("pvpsystem:pvpqueue", source, 2)
end)

-- IF SOMEONE DIE THE PLAYERS GO TO A POINT (1V1)
RegisterServerEvent("pvpsystem:die1v1")
AddEventHandler("pvpsystem:die1v1", function(player1, player2)
	Citizen.CreateThread(function()
		while true do
			if (GetEntityHealth(GetPlayerPed(player1))<=healthlimit or GetEntityHealth(GetPlayerPed(player2))<=healthlimit or id==player1 or id==player2) then
				if (GetEntityHealth(GetPlayerPed(player1))<=healthlimit) then
					TriggerClientEvent("pvpsystem:msgLost", player1)
					TriggerClientEvent("pvpsystem:msgWon", player2)
				elseif (GetEntityHealth(GetPlayerPed(player2))<=healthlimit) then
					TriggerClientEvent("pvpsystem:msgWon", player1)
					TriggerClientEvent("pvpsystem:msgLost", player2)
				elseif (id==player1 or id==player2) then
					TriggerClientEvent("pvpsystem:msgQuit", player1)
				end

				Citizen.Wait(1700)
				
				local players = {player1, player2}
				for i=2,1,-1 do
					SetEntityCoords(GetPlayerPed(players[i]),-1497.45,139.64,55.65,1,0,0,1)
					SetEntityHeading(players[i], 314.48)
					SetPlayerRoutingBucket(players[i], 0)
					vRPclient.killGod(players[i])
					vRPclient.setHealth(players[i], 400)
				end		
				break
			end
			Citizen.Wait(1)
		end
	end)
end)

-- 2v2
Citizen.CreateThread(function()
	while true do
	    if (#queue2v2>=2) then
	    	SetEntityCoords(queue2v2[1], 1214.8901367188,3115.2985839844,40.414089202881, true, true, true, false)
	    	SetEntityCoords(queue2v2[2], 1214.8901367188,3115.2985839844,40.414089202881, true, true, true, false)
	    	SetEntityCoords(queue2v2[3], 1115.7302246094,3090.5446777344,40.414070129395, true, true, true, false)
	    	SetEntityCoords(queue2v2[4], 1115.7302246094,3090.5446777344,40.414070129395, true, true, true, false)

	    	SetEntityHeading(queue2v2[1], 108.94)
	    	SetEntityHeading(queue2v2[2], 108.94)
	    	SetEntityHeading(queue2v2[3], 286.34)
	    	SetEntityHeading(queue2v2[4], 286.34)
			for i=4,1,-1 do
			    SetPlayerRoutingBucket(queue2v2[i], dimension2v2)

			    RemoveAllPedWeapons(queue2v2[i], false)
			    GiveWeaponToPed(queue2v2[i], GetHashKey("weapon_pistol_mk2"), 200, true)
			    SetCurrentPedWeapon(queue2v2[i], GetHashKey("weapon_pistol_mk2"), true)

			    TriggerClientEvent("pvpsystem:msg", queue2v2[i], 2)
			end

		    TriggerEvent("pvpsystem:die2v2", queue2v2[1], queue2v2[2], queue2v2[3], queue2v2[4])

		    dimension2v2 = dimension2v2 + 1
			table.remove(queue2v2, 4)
		   	table.remove(queue2v2, 3)
		    table.remove(queue2v2, 2)
		   	table.remove(queue2v2, 1)
		end
    Citizen.Wait(1200)
  	end
end)

-- IF A TEAM DIES, THE PLAYERS GO TO A POINT (2V2)
RegisterServerEvent("pvpsystem:die2v2")
AddEventHandler("pvpsystem:die2v2", function(player1, player2, player3, player4) -- TEAM 1 - PLAYER 1 AND 2
	Citizen.CreateThread(function()												   -- TEAM 2 - PLAYER 3 AND 4
		while true do
			if (GetEntityHealth(GetPlayerPed(player1))<=healthlimit and GetEntityHealth(GetPlayerPed(player2))<=healthlimit or GetEntityHealth(GetPlayerPed(player3))<=healthlimit and GetEntityHealth(GetPlayerPed(player4))<=healthlimit) then
				if (GetEntityHealth(GetPlayerPed(player1))<=healthlimit and GetEntityHealth(GetPlayerPed(player2))<=healthlimit) then
					TriggerClientEvent("pvpsystem:msgLost", player1)
					TriggerClientEvent("pvpsystem:msgLost", player2)
					TriggerClientEvent("pvpsystem:msgWon", player3)
					TriggerClientEvent("pvpsystem:msgWon", player4)
				elseif (GetEntityHealth(GetPlayerPed(player3))<=healthlimit and GetEntityHealth(GetPlayerPed(player4))<=healthlimit) then
					TriggerClientEvent("pvpsystem:msgLost", player4)
					TriggerClientEvent("pvpsystem:msgLost", player3)
					TriggerClientEvent("pvpsystem:msgWon", player2)
					TriggerClientEvent("pvpsystem:msgWon", player1)
				end

				Citizen.Wait(1700)
				
				local players = {player1, player2, player3, player4}
				for i=4,1,-1 do
					SetEntityCoords(GetPlayerPed(players[i]),-1497.45,139.64,55.65,1,0,0,1)
					SetEntityHeading(players[i], 314.48)
					SetPlayerRoutingBucket(players[i], 0)
					vRPclient.killGod(players[i])
					vRPclient.setHealth(players[i], 400)
				end
				break
			end
			Citizen.Wait(1)
		end
	end)
end)


-- WHEN THE DIMENSION REACHES THE LIMIT, IT RETURNS TO THE INITIAL NUMBER

-- 1V1
Citizen.CreateThread(function()
	while true do
		if (dimension1v1==(initialdimension1v1+301)) then
			dimension1v1=initialdimension2v2
		end
		Citizen.Wait(10)
	end
end)

-- 2V2
Citizen.CreateThread(function()
	while true do
		if (dimension2v2==(initialdimension2v2+301)) then
			dimension2v2=initialdimension2v2
		end
		Citizen.Wait(10)
	end
end)

AddEventHandler('playerDropped', function (reason)
  id = source
end)