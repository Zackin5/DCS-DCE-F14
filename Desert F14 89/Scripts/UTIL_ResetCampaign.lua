--To create fresh status files when a new campaign is started
--Initiated by EventsTracker.lua running from within DCS if the mission was a first campaign mission
--Initated by BAT_FirstMission.lua if a campaign is reset manually
------------------------------------------------------------------------------------------------------- 

----- random seed -----
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
math.random(); math.random(); math.random()


require("Scripts/UTIL_Functions")

if FirstMission then																				--if the script is called by BAT_FirstMission.lua, then FirstMission is true and camp_status is reset to init. When called by EventsTracker.lua out of DCS mission, block is skipped and camp_camp status carried over in mission is used.
	require("Init/camp_init")
	local camp_str = "camp = " .. TableSerialization(camp, 0)										--make a string of campaign initial status table
	local campFile = io.open("Status/camp_status.lua", "w")											--open campaign status file
	campFile:write(camp_str)																		--write initial status
	campFile:close()
end

require("Init/oob_air_init")																		--run initial oob air
local air_str = "oob_air = " .. TableSerialization(oob_air, 0)										--make a string
local airFile = io.open("Status/oob_air.lua", "w")													--open oob air file
airFile:write(air_str)																				--write initial data
airFile:close()

require("Init/targetlist_init")																		--run initial targetlist
local tgt_str = "targetlist = " .. TableSerialization(targetlist, 0)								--make a string
local tgtFile = io.open("Status/targetlist.lua", "w")												--open targetlist file
tgtFile:write(tgt_str)																				--write initial data
tgtFile:close()

local ground_str = "oob_ground = {}"
local groundFile = io.open("Status/oob_ground.lua", "w")											--open oob ground file
groundFile:write(ground_str)																		--write initial data
groundFile:close()

local scen_str = "oob_scen = {}"
local scenFile = io.open("Status/oob_scen.lua", "w")												--open clientstats file
scenFile:write(scen_str)																			--write initial file
scenFile:close()

local client_str = "clientstats = {}"
local clientFile = io.open("Status/clientstats.lua", "w")											--open clientstats file
clientFile:write(client_str)																		--write initial file
clientFile:close()


--create new oob_ground (requires extraction of data of init mission)
do
	--unpack template mission file
	local minizip = require('minizip')
	local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

	zipFile:unzLocateFile('mission')
	local misStr = zipFile:unzReadAllCurrentFile()
	local misStrFunc = loadstring(misStr)()

	zipFile:unzLocateFile('l10n/DEFAULT/dictionary')
	local dicStr = zipFile:unzReadAllCurrentFile()
	local dicStrFunc = loadstring(dicStr)()

	zipFile:unzClose()

	
	oob_ground = {}
	oob_ground["blue"] = deepcopy(mission.coalition.blue.country)											--copy mission data
	oob_ground["red"] = deepcopy(mission.coalition.red.country)												--copy mission data

	--store group and unit names in oob_ground instead of pointers to dict table
	for side_name, side in pairs(oob_ground) do																--iterate through sides
		for country_n, country in pairs(side) do															--iterate through countries
			if country.vehicle then																			--country has vehicles
				for g = 1, #country.vehicle.group do														--iterate through vehicle groups
					local groupname = dictionary[country.vehicle.group[g].name]								--find groupname in dictionary table			
					country.vehicle.group[g].name = groupname												--give group the actual groupname instead of the pointer to the dictionary table
					for u = 1, #country.vehicle.group[g].units do											--iterate through units
						local unitname = dictionary[country.vehicle.group[g].units[u].name]					--find unitname in dictionary table
						country.vehicle.group[g].units[u].name = unitname									--give unit the actual unitname instead of the pointer to the dictionary table
					end
				end
			end
			if country.ship then																			--country has ships
				for g = 1, #country.ship.group do															--iterate through ship groups
					local groupname = dictionary[country.ship.group[g].name]								--find groupname in dictionary table
					country.ship.group[g].name = groupname													--give group the actual groupname instead of the pointer to the dictionary table
					for u = 1, #country.ship.group[g].units do												--iterate through units
						local unitname = dictionary[country.ship.group[g].units[u].name]					--find unitname in dictionary table
						country.ship.group[g].units[u].name = unitname										--give unit the actual unitname instead of the pointer to the dictionary table
					end
				end
			end
			if country.static then																			--country has static objects
				for g = 1, #country.static.group do															--iterate through static groups
					local groupname = dictionary[country.static.group[g].name]								--find groupname in dictionary table			
					country.static.group[g].name = groupname												--give group the actual groupname instead of the pointer to the dictionary table
					for u = 1, #country.static.group[g].units do											--iterate through units
						local unitname = dictionary[country.static.group[g].units[u].name]					--find unitname in dictionary table
						country.static.group[g].units[u].name = unitname									--give unit the actual unitname instead of the pointer to the dictionary table
					end
				end
			end
		end
	end
	
	--save oob_ground status file
	local ground_str = "oob_ground = " .. TableSerialization(oob_ground, 0)								--make a string
	local groundFile = io.open("Status/oob_ground.lua", "w")											--open oob ground file
	groundFile:write(ground_str)																		--write initial data
	groundFile:close()
end