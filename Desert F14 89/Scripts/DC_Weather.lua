--Weather
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 

mission.weather["atmosphere_type"] = 0									--set simple weather model

--Initial weather
if camp.weather.zone == nil then										--no weather exists yet
	camp.weather.zoneTemp = math.random(camp.weather.refTemp - 5, camp.weather.refTemp + 5)				--Set temperature of weather zone (+/- 5°C of reference tempereature)
	camp.weather.zoneNextTemp = math.random(camp.weather.refTemp - 5, camp.weather.refTemp + 5)			--Set temperature of next weather zone (+/- 5°C of reference tempereature)
	
	local chance = 100 / (camp.weather.pHigh + camp.weather.pLow) * camp.weather.pHigh					--chance of next weather zone being a high pressure system
	if math.random(1, 100) <= chance then								--High pressure system
		camp.weather.zoneNext = "high"									--set next weather zone
	else																--Low pressure system
		local rando = math.random(1,4)
		if rando == 1 then
			camp.weather.zoneNext = "low sector cold"					--next zone is a cold sector
		elseif rando == 2 then
			camp.weather.zoneNext = "low sector warm"					--next zone is a warm sector
		elseif rando == 3 then
			camp.weather.zoneNext = "low front cold"					--Next zone is a cold front
		elseif rando == 4 then
			camp.weather.zoneNext = "low front warm"					--Next zone is a warm front
		end
	end
	
	camp.weather.zoneEnd = -1											--Current (non-existing) zone end negative to trigger weather change
end 

local elapsed_time = (camp.day - 1) * 86400 + camp.time					--elapsed time since campaign start in seconds

--Weather change
if elapsed_time > camp.weather.zoneEnd then								--active weather zone has ended

	--Active zone
	camp.weather.zone = camp.weather.zoneNext							--make next weather zone the active weather zone
	camp.weather.zoneStart = camp.weather.zoneEnd						--time active weather zone has started
	if camp.weather.zone == "high" then
		camp.weather.zoneEnd = elapsed_time + math.random(86400, 432000)	--set duration of current weather zone (between 1 and 5 days for High system)
		camp.weather.zoneTemp = camp.weather.zoneNextTemp				--make next weather zone temperature the current temperature
	elseif camp.weather.zone == "low front cold" then
		camp.weather.zoneEnd = elapsed_time + math.random(14400, 28800)	--set duration of current weather zone (between 4 and 8 hours for cold front)
	elseif camp.weather.zone == "low front warm" then
		camp.weather.zoneEnd = elapsed_time + math.random(43200, 86400)	--set duration of current weather zone (between 12 and 24 hours for warm front)
	elseif camp.weather.zone == "low sector cold" then
		camp.weather.zoneEnd = elapsed_time + math.random(21600, 172800)	--set duration of current weather zone (between 6 and 48 hours for cold sector)
		camp.weather.zoneTemp = camp.weather.zoneNextTemp				--make next weather zone temperature the current temperature
	elseif camp.weather.zone == "low sector warm" then
		camp.weather.zoneEnd = elapsed_time + math.random(21600, 172800)	--set duration of current weather zone (between 6 and 48 hours for warm sector)
		camp.weather.zoneTemp = camp.weather.zoneNextTemp				--make next weather zone temperature the current temperature
	end
	
	--Next zone
	camp.weather.zoneNextTemp = math.random(camp.weather.refTemp - 5, camp.weather.refTemp + 5)			--Set temperature of next weather zone (+/- 5°C of reference tempereature)
	
	local chance = 100 / (camp.weather.pHigh + camp.weather.pLow) * camp.weather.pHigh					--chance of next weather zone being a high pressure system
	if math.random(1, 100) <= chance then								--High pressure system
		camp.weather.zoneNext = "high"									--set next weather zone
	else																--Low pressure system
		if camp.weather.zone == "low front cold" then					--active zone is a cold front
			camp.weather.zoneNext = "low sector cold"					--next zone is a cold sector
		elseif camp.weather.zone == "low front warm" then				--active zone is a warm front
			camp.weather.zoneNext = "low sector warm"					--next zone is a warm sector
		else															--active zone is a sector (warm or cold), next zone is a front (warm or cold)
			if camp.weather.zoneTemp > camp.weather.zoneNextTemp then	--Next zone is colder
				camp.weather.zoneNext = "low front cold"				--Next zone is a cold front
			elseif camp.weather.zoneTemp < camp.weather.zoneNextTemp then	--Next zone is warmer
				camp.weather.zoneNext = "low front warm"				--Next zone is a warm front
			else														--Next zone has same tempreature
				camp.weather.zoneNext = camp.weather.zone				--Next zone remains the same (warm or cold sectior)
			end
		end
	end
end


--Set current weather
----- HIGH -----
if camp.weather.zone == "high" then

	--clouds
	mission.weather["clouds"] = {
		["thickness"] = 0,
		["density"] = 0,
		["base"] = 0,
		["iprecptns"] = 0,
	}

	--wind
	local windDir = math.random(0, 359)
	local windSpeed = math.random(0, 1)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 3,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence
	mission.weather["turbulence"] = {
		["at8000"] = math.random(0, 10),
		["at2000"] = math.random(0, 10),
		["atGround"] = math.random(0, 10),
	}
	
	--temperature
	mission.weather["season"]["temperature"] = camp.weather.zoneTemp
	
	--pressure
	mission.weather["qnh"] = math.random(760, 790)

	
----- COLD FRONT -----
elseif camp.weather.zone == "low front cold" then
	
	local front_remaining = (camp.weather.zoneEnd - elapsed_time) / 3600					--hours until end of cold front
	local front_duration = (camp.weather.zoneEnd - camp.weather.zoneStart) / 3600			--duration of the front in hours
	local strength = 10 - front_remaining * 10 / front_duration								--strength of the front on a scale of 0-10
	
	--clouds
	mission.weather["clouds"] = {
		["thickness"] = math.random(4000, 8000),
		["density"] = math.random(9, 10),
		["base"] = math.random(100, 500),
		["iprecptns"] = math.random(1, 2),
	}

	--wind
	local windDir = math.random(0, 359)
	local windSpeed = math.random(3, 7)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 3,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence
	mission.weather["turbulence"] = {
		["at8000"] = math.random(10, 60),
		["at2000"] = math.random(10, 60),
		["atGround"] = math.random(10, 60),
	}
	
	--temperature
	mission.weather["season"]["temperature"] = math.ceil(camp.weather.zoneTemp + strength * (camp.weather.zoneNextTemp - camp.weather.zoneTemp) / 10)
	
	--pressure
	mission.weather["qnh"] = math.random(720, 760)


------ WARM FRONT -----
elseif camp.weather.zone == "low front warm" then
	
	local front_remaining = (camp.weather.zoneEnd - elapsed_time) / 3600					--hours until end of warm front
	local front_duration = (camp.weather.zoneEnd - camp.weather.zoneStart) / 3600			--duration of the front in hours
	local strength = 10 - front_remaining * 10 / front_duration								--strength of the front on a scale of 0-10
	
	--clouds
	local dens = math.ceil(strength * 1.5)
	if dens > 10 then
		dens = 10
	end
	mission.weather["clouds"] = {
		["thickness"] = math.ceil(strength * 200),
		["density"] = dens,
		["base"] = math.ceil(8000 - strength * 800),
		["iprecptns"] = math.floor(strength * 0.2),
	}

	--wind
	local windDir = math.random(0, 359)
	local windSpeed = math.random(2, 5)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 3,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence
	mission.weather["turbulence"] = {
		["at8000"] = math.random(5, 30),
		["at2000"] = math.random(5, 30),
		["atGround"] = math.random(5, 30),
	}
	
	--temperature
	mission.weather["season"]["temperature"] = math.ceil(camp.weather.zoneTemp + strength * (camp.weather.zoneNextTemp - camp.weather.zoneTemp) / 10)
	
	--pressure
	mission.weather["qnh"] = math.random(720, 760)

	
----- COLD SECTOR ------
elseif camp.weather.zone == "low sector cold" then
	
	--clouds
	mission.weather["clouds"] = {
		["thickness"] = math.random(100, 1000),
		["density"] = math.random(0, 1),
		["base"] = math.random(4000, 6000),
		["iprecptns"] = 0,
	}

	--wind
	local windDir = math.random(0, 359)
	local windSpeed = math.random(1, 4)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 3,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence
	mission.weather["turbulence"] = {
		["at8000"] = math.random(5, 30),
		["at2000"] = math.random(5, 30),
		["atGround"] = math.random(5, 30),
	}
	
	--temperature
	mission.weather["season"]["temperature"] = camp.weather.zoneTemp
	
	--pressure
	mission.weather["qnh"] = math.random(720, 760)


----- WARM SECTOR -----
elseif camp.weather.zone == "low sector warm" then

	--clouds
	mission.weather["clouds"] = {
		["thickness"] = math.random(100, 1000),
		["density"] = math.random(1, 4),
		["base"] = math.random(4000, 6000),
		["iprecptns"] = 0,
	}

	--wind
	local windDir = math.random(0, 359)
	local windSpeed = math.random(1, 4)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 3,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence
	mission.weather["turbulence"] = {
		["at8000"] = math.random(5, 30),
		["at2000"] = math.random(5, 30),
		["atGround"] = math.random(5, 30),
	}
	
	--temperature
	mission.weather["season"]["temperature"] = camp.weather.zoneTemp
	
	--pressure
	mission.weather["qnh"] = math.random(720, 760)
	
	
end


--Time of day temperature modification, min at 5 0'clock, max at 17 o'clock, deltaT 1 °C per hour
local hour = math.floor(camp.time / 3600)								--convert time to hours rounded down
if hour <= 5 then														--before 5 o'clock in the morning
	mission.weather["season"]["temperature"] = mission.weather["season"]["temperature"] - 7 - hour
elseif hour <= 17 then													--between 5 and 17 o'clock
	mission.weather["season"]["temperature"] = mission.weather["season"]["temperature"] - 17 + hour
else																	--after 17 o'clock
	mission.weather["season"]["temperature"] = mission.weather["season"]["temperature"] + 17 - hour
end


--Fog
if mission.weather["wind"]["atGround"]["speed"] < 2 then															--Fog is possible at speeds below 2 m/s
	if mission.weather["season"]["temperature"] < 12 and mission.weather["season"]["temperature"] > -2 then			--Fog is possoble at temperatures between -2 and 12 °C
		if math.random(1, 5) == 1 then																				--20% chance of fog
			mission.weather["enable_fog"] = true
			mission.weather["fog"] = {
				["thickness"] = math.random(0, 1000),
				["visibility"] = math.random(0,10000),
			}
		end
	end
end


----- Build METAR -----
METAR = "METAR "

--time and date
if camp.date.day < 10 then
	METAR = METAR .. "0" .. camp.date.day
else
	METAR = METAR .. camp.date.day
end
local t = math.floor(camp.time / 3600)
if t < 10 then
	METAR = METAR .. "0" .. t
else
	METAR = METAR .. t
end
local minute = math.floor((camp.time / 3600 - t) * 60)
if minute < 10 then
	minute = "0" .. minute
end
METAR = METAR .. minute .. " "

--wind
local direction = mission.weather["wind"]["atGround"]["dir"] - 180
if direction < 0 then
	direction = direction + 360
end
direction = math.floor(direction / 10) * 10
if direction < 10 then
	direction = "00" .. direction
elseif direction < 100 then
	direction = "0" .. direction
end
local speed = mission.weather["wind"]["atGround"]["speed"]
if camp.units == "imperial" then
	speed = math.ceil(speed * 1.94384)
end
if speed < 10 then
	speed = "0" .. speed
end
if camp.units == "imperial" then
	if mission.weather["wind"]["atGround"]["speed"] == 0 then
		METAR = METAR .. "00000KT "
	else
		METAR = METAR .. direction .. speed .. "KT "
	end
else
	if mission.weather["wind"]["atGround"]["speed"] == 0 then
		METAR = METAR .. "00000MPS "
	else
		METAR = METAR .. direction .. speed .. "MPS "
	end
end

--visilility
if mission.weather["enable_fog"] == true then
	local vis = math.floor(mission.weather["fog"]["visibility"] / 100) * 100
	if vis < 10 then
		vis = "000" .. vis
	elseif vis < 100 then
		vis = "00" .. vis
	elseif vis < 1000 then
		vis = "0" .. vis
	end
	METAR = METAR .. vis .. " " 
else
	if mission.weather["clouds"]["iprecptns"] == 1 then
		METAR = METAR .. "9999 "
	elseif mission.weather["clouds"]["iprecptns"] == 2 then
		METAR = METAR .. "9999 "
	else
		METAR = METAR .. "CAVOK "
	end
end

--fog
if mission.weather["enable_fog"] == true then
	METAR = METAR .. "FG "
end

--precipitation
if mission.weather["clouds"]["iprecptns"] == 1 then
	if mission.weather["season"]["temperature"] <= 0 then
		METAR = METAR .. "SN "
	else
		METAR = METAR .. "RA "
	end
elseif mission.weather["clouds"]["iprecptns"] == 2 then
	METAR = METAR .. "TS "
else
	METAR = METAR .. "NSW "
end

--clouds
local ceiling = mission.weather["clouds"]["base"]
if camp.units == "imperial" then
	ceiling = mission.weather["clouds"]["base"] * 3.28084
end
if ceiling < 100 then
	ceiling = "000"
elseif ceiling < 1000 then
	ceiling = "00" .. math.floor(ceiling / 100)
elseif ceiling < 10000 then
	ceiling = "0" .. math.floor(ceiling / 100)
else
	ceiling = "" .. math.floor(ceiling / 100)
end
if mission.weather["clouds"]["density"] == 0 then
	METAR = METAR .. "SKC "
elseif mission.weather["clouds"]["density"] < 4 then
	METAR = METAR .. "FEW" .. ceiling .. " "
elseif mission.weather["clouds"]["density"] < 7 then
	METAR = METAR .. "SCT" .. ceiling .. " "
elseif mission.weather["clouds"]["density"] < 9 then
	METAR = METAR .. "BKN" .. ceiling .. " "
else
	METAR = METAR .. "OVC" .. ceiling .. " "
end

--QNH
local qnh = math.floor(mission.weather["qnh"] / 760 * 1013.25)
METAR = METAR .. "Q" .. qnh .. "="

print(METAR)
print("\nPlease Wait...\n")