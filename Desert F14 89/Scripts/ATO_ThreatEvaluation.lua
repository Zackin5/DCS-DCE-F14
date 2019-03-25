--To check oob_ground for threats and rate and store them in a table for later mission plannning
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 

--table to store ground/sea threats
groundthreats = {
	blue = {																		--blue threats (to red)
		high = {},																	--high atitude threats (above 10'000 ft)
		low = {},																	--low altitute threats (below 10'000 ft)
	},
	red = {																			--red threats (to blue)
		high = {},
		low = {},
	}
}


--function to check if a unit is a threat, assign threat values and add to threats table
local function AddThreat(unit, side)												--unput is side and unit-table from oob_ground								
	if unit.type == "Vulcan" then
		local lowthreatentry = {
			type = unit.type,
			class = "AAA",
			level = 1,																--threat level: 1 = low, 2 = medium, 3 = high
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,																--position x-coordinate
			y = unit.y,																--position y-coordinate
			range = 1500,															--range of threat
			night = false,															--night capable
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "ZSU-23-4 Shilka" then
		local lowthreatentry = {
			type = unit.type,
			class = "AAA",
			level = 1,
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 2000,
			night = true,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "Gepard" then
		local lowthreatentry = {
			type = unit.type,
			class = "AAA",
			level = 1,
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 4000,
			night = true,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "M1097 Avenger" then
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 3500,
			night = true,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "M48 Chaparral" then
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 4000,
			night = false,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "M6 Linebacker" then
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 3500,
			night = true,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "Stinger manpad" then
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 3500,
			night = false,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
			
	elseif unit.type == "SA-18 Igla-S manpad" then
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 3000,
			night = false,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "Strela-1 9P31" then
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 2500,
			night = false,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
	
	elseif unit.type == "Strela-10M3" then
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 3,
			SEAD_offset = 0,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 3000,
			night = false,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "2S6 Tunguska" then
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 5,
			SEAD_offset = 1,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 8500,
			night = true,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "Roland ADS" then
		local highthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 5,
			SEAD_offset = 1,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 8500,
			night = true,
		}
		table.insert(groundthreats[side].high, highthreatentry)
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 5,
			SEAD_offset = 1,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 8500,
			night = true,
		}
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "Hawk tr" then
		local highthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 1,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 46000,
			night = true,
		}
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 1,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 35000,
			night = true,
		}
		table.insert(groundthreats[side].high, highthreatentry)
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "Patriot str" then
		local highthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 74000,
			night = true,
		}
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 39000,
			night = true,
		}
		table.insert(groundthreats[side].high, highthreatentry)
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "snr s-125 tr" then
		local highthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 6,
			SEAD_offset = 2,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 23000,
			night = true,
		}
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 6,
			SEAD_offset = 2,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 18000,
			night = true,
		}
		table.insert(groundthreats[side].high, highthreatentry)
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "Kub 1S91 str" then
		local highthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 2,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 34000,
			night = true,
		}
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 2,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 22000,
			night = true,
		}
		table.insert(groundthreats[side].high, highthreatentry)
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "Osa 9A33 ln" then
		local highthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 1,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 15000,
			night = true,
		}
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 7,
			SEAD_offset = 1,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 10000,
			night = true,
		}
		table.insert(groundthreats[side].high, highthreatentry)
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "SA-11 Buk SR 9S18M1" then
		local highthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 39000,
			night = true,
		}
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 36000,
			night = true,
		}
		table.insert(groundthreats[side].high, highthreatentry)
		table.insert(groundthreats[side].low, lowthreatentry)
		
	elseif unit.type == "Tor 9A331" then
		local highthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 16000,
			night = true,
		}
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 8,
			SEAD_offset = 2,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 9000,
			night = true,
		}
		table.insert(groundthreats[side].high, highthreatentry)
		table.insert(groundthreats[side].low, lowthreatentry)
			
	elseif unit.type == "S-300PS 40B6M tr" then
		local highthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 66000,
			night = true,
		}
		local lowthreatentry = {
			type = unit.type,
			class = "SAM",
			level = 10,
			SEAD_offset = 4,														--number of SEAD sorties required to offset threat
			x = unit.x,
			y = unit.y,
			range = 50000,
			night = true,
		}
		table.insert(groundthreats[side].high, highthreatentry)
		table.insert(groundthreats[side].low, lowthreatentry)
		
	end
end
--add ships


--table to store ewr
ewr = {
	blue = {																		--blue EWR
		high = {},																	--high atitude EWR (above 10'000 ft)
		low = {},																	--low altitute EWR (below 10'000 ft)
	},
	red = {																			--red EWR
		high = {},
		low = {},
	}
}

--GCI table to store EWR radars (and later AWACS and interceptors)
GCI = {
	EWR = {
		["blue"] = {},
		["red"] = {},
	},
	Interceptor = {
		["blue"] = {
			ready = {},
			assigned = {},
		},
		["red"] = {
			ready = {},
			assigned = {},
		},
	},
	Flag = 500,
}

--function to add EWR units to EWR table
local function AddEWR(unit, side, freq, call)
	if unit.type == "1L13 EWR" then
		local high = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 300000,
			frequency = freq,
			callsign = call,
		}
		local low = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 80000,
			frequency = freq,
			callsign = call,
		}
		table.insert(ewr[side].high, high)
		table.insert(ewr[side].low, low)
		GCI.EWR[side][unit.name] = true
		
	elseif unit.type == "55G6 EWR" then
		local high = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 300000,
			frequency = freq,
			callsign = call,
		}
		local low = {
			type = unit.type,
			class = "EWR",
			x = unit.x,
			y = unit.y,
			range = 80000,
			frequency = freq,
			callsign = call,
		}
		table.insert(ewr[side].high, high)
		table.insert(ewr[side].low, low)
		GCI.ERW[side][unit.name] = true
	
	end
end


--find ground threats and EWR in vehicles and ships
for sidename, side in pairs(oob_ground) do									--Iterate through all sides
	for country_n, country in pairs(side) do								--Iterate through all countries
		if country.vehicle then												--If country has vehicles
			for group_n, group in pairs(country.vehicle.group) do			--Iterate through all groups
				if group.hidden == false then								--group is not hidden
					for unit_n, unit in pairs(group.units) do				--Iterate through all units
						if unit.dead ~= true then							--If unit is not dead					
							AddThreat(unit, sidename)						--Evaluate unit as threat and add to groundthreats table
							
							local ewr_task = false							--group has EWR task
							local ewr_freq = nil							--group has a communications frequency
							local ewr_call = nil							--group has a communications callsign
							for t = 1, #group.route.points[1].task.params.tasks do												--Iterate through WP1 tasks of group
								if group.route.points[1].task.params.tasks[t].id == "EWR" then									--If there is a EWR task
									ewr_task = true																				--set ewr_task true
								end
								if group.route.points[1].task.params.tasks[t].params.action then
									if group.route.points[1].task.params.tasks[t].params.action.id == "SetFrequency" then			--if group has a frequency set
										ewr_freq = group.route.points[1].task.params.tasks[t].params.action.params.frequency		--set frequency
										ewr_freq = tostring(ewr_freq / 1000000)														--make a string
									end
									if group.route.points[1].task.params.tasks[t].params.action.id == "SetCallsign" then			--if group has a callsign set
										ewr_call = group.route.points[1].task.params.tasks[t].params.action.params.callsign			--set callsign
									end
								end
							end

							if ewr_task then
								AddEWR(unit, sidename, ewr_freq, ewr_call)	--Add to EWR table
							end
						end
					end
				end
			end
		end
		if country.ship then												--If country has ships
			for group_n, group in pairs(country.ship.group) do				--Iterate through all groups
				if group.hidden == false then								--group is not hidden
					for unit_n, unit in pairs(group.units) do				--Iterate through all units
						if unit.dead ~= true then							--If unit is not dead
							AddThreat(unit, sidename)						--Evaluate unit as threat and add to groundthreats table
							AddEWR(unit, sidename)							--Evaluate unit as EWR and add to EWR table
						end
					end
				end
			end
		end
	end
end


--table to store fighter threats (CAP and intercept)
fighterthreats = {
	blue = {},																					--blue threats (to red)
	red = {}																					--red threats (to blue)
}


--find AWACS, CAP and interceptors in aircraft units and populate ewr/fighterthreats table
for side,unit in pairs(oob_air) do																--iterate through all sides
	for n = 1, #unit do																			--iterate through all units
		if unit[n].inactive ~= true and unit[n].roster.ready > 0 and db_airbases[unit[n].base].inactive ~= true then		--if unit is active and has ready aircraft and its airbase is active
			for task,task_bool in pairs(unit[n].tasks) do										--iterate through all tasks of unit
				if task_bool then																--task is true
					for loadout_name, loadout in pairs(db_loadouts[unit[n].type]) do			--iterate through all loadout.descriptions for a given aircraft type
						if task == loadout.description.task then								--if unit task is loadout.description task
							if loadout.description.task == "AWACS" then							--if loadout is AWACS
								local entry = {													--define fighterthreats table entry
									name = unit[n].name,										--unit name
									class = "AWACS",											--class
									x = db_airbases[unit[n].base].x,							--unit homebase position
									y = db_airbases[unit[n].base].y,
									level = 0,
									range = loadout.description.range + 250000,					--AWACS surveilance radius = AWACS mission range + radar range,
								}
								
								table.insert(ewr[side].high, entry)
								table.insert(ewr[side].low, entry)
							elseif loadout.description.task == "CAP" then						--if loadout is CAP
								local entry = {													--define fighterthreats table entry
									name = unit[n].name,										--unit name
									class = "CAP",												--class
									x = db_airbases[unit[n].base].x,							--unit homebase position
									y = db_airbases[unit[n].base].y,
									level = loadout.description.capability * loadout.description.firepower * (unit[n].roster.ready / 3) / 100,		--total unit threat is capability * firepower * one third of ready aircraft divided by 100
									range = loadout.description.range + 400000,					--Fighter action radius = Fighter mission range + engagement range,
									LDSD = loadout.description.LDSD,							--Look Down/Shoot Down
								}
								
								table.insert(fighterthreats[side], entry)
							elseif task == "Intercept" then										--if loadout is Intercept
								local entry = {													--define fighterthreats table entry
									name = unit[n].name,										--unit name
									class = "Intercept",										--class
									x = db_airbases[unit[n].base].x,							--unit homebase position
									y = db_airbases[unit[n].base].y,
									level = loadout.description.capability * loadout.description.firepower * (unit[n].roster.ready / 3) / 100,		--total unit threat is capability * firepower * one third of ready aircraft divided by 100
									range = loadout.description.range + 400000,					--Fighter action radius = Fighter mission range + engagement range,
								}
								
								table.insert(fighterthreats[side], entry)
							end
						end
					end
				end
			end
		end
	end
end