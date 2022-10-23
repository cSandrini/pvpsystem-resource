local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-- FUNCTIONS 
function function1v1(player, x, y, z, heading, dimension)
	SetEntityCoords(player, x, y, z, false, true, true, false)
	SetEntityHeading(player, heading)
	SetPlayerRoutingBucket(player, dimension) -- DIMENSION
	RemoveAllPedWeapons(player, false)
	GiveWeaponToPed(player, GetHashKey("weapon_pistol_mk2"), 200, true)
	SetCurrentPedWeapon(player, GetHashKey("weapon_pistol_mk2"), true)
	TriggerClientEvent("pvpsystem:notify", player, "You are in the arena: ~b~#1", true)
end

function revivePlayer(player, x, y, z, heading)
	SetEntityCoords(player, x, y,  z, false, true, true, false)
	SetEntityHeading(player, heading)
	SetPlayerRoutingBucket(player, 0)
	TriggerClientEvent("pvpsystem:revive", player, player)
	vRPclient.killGod(players[i])
	vRPclient.setHealth(players[i], 200)
end

function dimensions(dimension, initialDimension)
	Citizen.CreateThread(function()
		while true do
			if (dimension==(initialDimension+301)) then
				dimension=initialDimension
			end
			Citizen.Wait(10)
		end
	end)
end

-- VARS
id = nil
-- HEALTH LIMIT TO GET IN COMA (DIE)
healthlimit = 0 -- CHANGE TO HEALTH LIMIT OF YOUR SERVER IF DOESN'T WORK

-- VARS TO 1v1
count = 1
queue1v1 = {}
initialDimension1v1 = 1000
dimension1v1 = initialDimension1v1 -- INITIAL DIMENSION 1V1

-- VARS TO 2v2
queue2v2={}
initialDimension2v2 = 100
dimension2v2 = initialDimension2v2 -- INITIAL DIMENSION 2V2

-- DISABLE VEHICLES IN THE SOME DIMENSIONS
if Config.disableVehicles then
	for i = (initialDimension1v1+300),initialDimension1v1,-1 do 
		SetRoutingBucketEntityLockdownMode(i, "strict")
	end
	for i = (initialDimension2v2+300),initialDimension2v2,-1 do 
		SetRoutingBucketEntityLockdownMode(i, "strict")
	end
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


-- 1V1 WITH QUEUE
Citizen.CreateThread(function()
	while true do
	    if (#queue1v1>=2) then
		-- PLAYER 1
		function1v1(queue1v1[1], Config.firstSpawnCoords1v1[1], Config.firstSpawnCoords1v1[2], Config.firstSpawnCoords1v1[3], Config.firstSpawnCoords1v1Heading, dimension1v1) 
		-- PLAYER 2
		function1v1(queue1v1[2], Config.secondSpawnCoords1v1[1], Config.secondSpawnCoords1v1[2], Config.secondSpawnCoords1v1[3], Config.secondSpawnCoords1v1Heading, dimension1v1) 
		-- CHECK IF ANY PLAYER DIE
	    TriggerEvent("pvpsystem:die1v1", queue1v1[1], queue1v1[2])
		-- DIMENSIONS SETTINGS
	    dimension1v1 = dimension1v1 + 1 
	   	table.remove(queue1v1, 2)
		table.remove(queue1v1, 1)
		end
    Citizen.Wait(1200)
  	end
end)

-- 1V1 WITHOUT QUEUE, NEEDS AN ID OF A FRIEND (EX: /1v1 [id])
RegisterServerEvent("pvpsystem:comargs")
AddEventHandler("pvpsystem:comargs", function(player1, player2)
	-- PLAYER 1
	function1v1(player1, Config.firstSpawnCoords1v1[1], Config.firstSpawnCoords1v1[2], Config.firstSpawnCoords1v1[3], Config.firstSpawnCoords1v1Heading, dimension1v1) 
	-- PLAYER 2
	function1v1(tonumber(player2), Config.secondSpawnCoords1v1[1], Config.secondSpawnCoords1v1[2], Config.secondSpawnCoords1v1[3], Config.secondSpawnCoords1v1Heading, dimension1v1)  
	-- CHECK IF ANY PLAYER DIE
    TriggerEvent("pvpsystem:die1v1", player1, player2)
	-- DIMENSIONS SETTINGS
	dimension1v1 = dimension1v1 + 1 
end)

-- 1V1 COMMAND 
RegisterCommand("1v1", function(source, args)
	if (args[1]==nil) then
		TriggerClientEvent("pvpsystem:pvpqueue", source, 1)
	elseif (source==tonumber(args[1])) then
		TriggerClientEvent("pvpsystem:notify", source, "~r~You can't challenge yourself!", false)
	else
		TriggerClientEvent("pvpsystem:request", args[1], source, args[1])
	end
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
			if (GetEntityHealth(GetPlayerPed(player1))<=healthlimit or GetEntityHealth(GetPlayerPed(player2))<=healthlimit) then
				if (GetEntityHealth(GetPlayerPed(player1))<=healthlimit) then
					TriggerClientEvent("pvpsystem:notify", player1, "~r~You lost!", true)
					TriggerClientEvent("pvpsystem:notify", player2, "~g~You won!", true)
				elseif (GetEntityHealth(GetPlayerPed(player2))<=healthlimit) then
					TriggerClientEvent("pvpsystem:notify", player2, "~g~You won!", true)
					TriggerClientEvent("pvpsystem:notify", player1, "~g~You lost!", true)
				end
				Citizen.Wait(1500)
				-- REVIVE PLAYERS
				revivePlayer(player1, Config.respawnCoords[1], Config.respawnCoords[2], Config.respawnCoords[3], Config.respawnCoordsHeading)
				revivePlayer(player2, Config.respawnCoords[1], Config.respawnCoords[2], Config.respawnCoords[3], Config.respawnCoordsHeading)
				break
			end
			Citizen.Wait(1)
		end
	end)
end)

-- 2v2
Citizen.CreateThread(function()
	while true do
	    if (#queue2v2>=4) then
			for i=1,4 do 
				SetEntityCoords(queue2v2[i], Config.firstTeamSpawnCoords2v2[1], Config.firstTeamSpawnCoords2v2[2], Config.firstTeamSpawnCoords2v2[3], true, true, true, false) 
			end
	    	SetEntityHeading(queue2v2[1], Config.firstTeamSpawnCoords2v2Heading)
	    	SetEntityHeading(queue2v2[2], Config.firstTeamSpawnCoords2v2Heading)
	    	SetEntityHeading(queue2v2[3], Config.secondTeamSpawnCoords2v2Heading)
	    	SetEntityHeading(queue2v2[4], Config.secondTeamSpawnCoords2v2Heading)
			for i=4,1,-1 do
			    SetPlayerRoutingBucket(queue2v2[i], dimension2v2)
			    RemoveAllPedWeapons(queue2v2[i], false)
			    GiveWeaponToPed(queue2v2[i], GetHashKey("weapon_pistol_mk2"), 200, true)
			    SetCurrentPedWeapon(queue2v2[i], GetHashKey("weapon_pistol_mk2"), true)
				TriggerClientEvent("pvpsystem:notify", queue2v2[i], "You are in the arena: ~b~#2", true)
			end
		    TriggerEvent("pvpsystem:die2v2", queue2v2[1], queue2v2[2], queue2v2[3], queue2v2[4])
		    dimension2v2 = dimension2v2 + 1
			for i=4,1,-1 do 
				table.remove(queue2v2, i) 
			end
		end
    Citizen.Wait(1200)
  	end
end)

-- IF A TEAM DIES, THE PLAYERS GO TO A POINT (2V2)
RegisterServerEvent("pvpsystem:die2v2")
AddEventHandler("pvpsystem:die2v2", function(player1, player2, player3, player4) -- TEAM 1 - PLAYER 1 AND 2
	Citizen.CreateThread(function()						 -- TEAM 2 - PLAYER 3 AND 4
		while true do
			if (GetEntityHealth(GetPlayerPed(player1))<=healthlimit and GetEntityHealth(GetPlayerPed(player2))<=healthlimit or GetEntityHealth(GetPlayerPed(player3))<=healthlimit and GetEntityHealth(GetPlayerPed(player4))<=healthlimit) then
				if (GetEntityHealth(GetPlayerPed(player1))<=healthlimit and GetEntityHealth(GetPlayerPed(player2))<=healthlimit) then
					TriggerClientEvent("pvpsystem:notify", player1, "~r~You lost!", true)
					TriggerClientEvent("pvpsystem:notify", player2, "~r~You lost!", true)
					TriggerClientEvent("pvpsystem:notify", player3, "~g~You won!", true)
					TriggerClientEvent("pvpsystem:notify", player4, "~g~You won!", true)
				elseif (GetEntityHealth(GetPlayerPed(player3))<=healthlimit and GetEntityHealth(GetPlayerPed(player4))<=healthlimit) then
					TriggerClientEvent("pvpsystem:notify", player4, "~r~You lost!", true)
					TriggerClientEvent("pvpsystem:notify", player3, "~r~You lost!", true)
					TriggerClientEvent("pvpsystem:notify", player2, "~g~You won!", true)
					TriggerClientEvent("pvpsystem:notify", player1, "~g~You won!", true)
				end
				Citizen.Wait(1500)
				revivePlayer(player1, Config.respawnCoords[1], Config.respawnCoords[2], Config.respawnCoords[3], Config.respawnCoordsHeading)
				revivePlayer(player2, Config.respawnCoords[1], Config.respawnCoords[2], Config.respawnCoords[3], Config.respawnCoordsHeading)
				revivePlayer(player3, Config.respawnCoords[1], Config.respawnCoords[2], Config.respawnCoords[3], Config.respawnCoordsHeading)
				revivePlayer(player4, Config.respawnCoords[1], Config.respawnCoords[2], Config.respawnCoords[3], Config.respawnCoordsHeading)
				break
			end
			Citizen.Wait(1)
		end
	end)
end)

-- WHEN THE DIMENSION REACHES THE LIMIT, IT RETURNS TO THE INITIAL NUMBER
dimensions(dimension1v1, initialDimension1v1) -- 1v1 Dimension
dimensions(dimension1v1, initialDimension2v2) -- 2v2 Dimension