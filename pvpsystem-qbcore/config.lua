-- CONFIG FILE -- PvP System
Config = {}

-- DEVELOPER MODE - IF YOU ARE TESTING WITHOUT ANOTHER PLAYER: TRUE - PLAYER IS ENABLE TO JOIN IN A QUEUE MORE THAN 1 TIME
Config.developerMode = false

-- ENABLE VEHICLES IN SOME DIMENSION 
Config.disableVehicles = true -- This resource disable the spawn of vehicles in some pvp dimensions. To disable this turn the variable to false.

-- WEAPONS - Default: Pistol MK2 = "weapon_pistol_mk2"
Config.weapon1v1 = "weapon_pistol_mk2" -- Weapon 1v1 
Config.weapon2v2 = "weapon_pistol_mk2" -- Weapon 2v2

-- COORDS
Config.respawnCoords = {-1497.45, 139.64, 55.65} -- Respawn point coords // {X, Y, Z} 
Config.respawnCoordsHeading = 314.48 -- Sets a point for the player to look at when teleported

Config.firstSpawnCoords1v1 = {-1748.63, 175.88, 64.37} -- First spawn point coords of 1v1 arena // {X, Y, Z} 
Config.firstSpawnCoords1v1Heading = 210.26 -- Sets a point for the player to look at when teleported
Config.secondSpawnCoords1v1 = {-1727.01, 145.06, 64.4} -- Second spawn point coords of 1v1 arena // {X, Y, Z} 
Config.secondSpawnCoords1v1Heading = 38.05 -- Sets a point for the player to look at when teleported

Config.firstTeamSpawnCoords2v2 = {1214.89, 3115.29, 40.41} -- (Team 1) First spawn point coords of 2v2 arena // {X, Y, Z} 
Config.firstTeamSpawnCoords2v2Heading = 286.34 -- Sets a point for the player to look at when teleported
Config.secondTeamSpawnCoords2v2 = {1115.73, 3090.54, 40.41} -- (Team 2) Third spawn point coords of 2v2 arena // {X, Y, Z} 
Config.secondTeamSpawnCoords2v2Heading = 108.94 -- Sets a point for the player to look at when teleported