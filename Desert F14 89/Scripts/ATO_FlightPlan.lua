--To create the flight plans in the mission file for all flights in the ATO
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 

----- function to create callsigns for aircraft in ATO -----
local callsign_west = {
	generic = {
		[1] = "Enfield",
		[2] = "Springfield",
		[3] = "Uzi",
		[4] = "Colt",
		[5] = "Dodge",
		[6] = "Ford",
		[7] = "Chevy",
		[8] = "Pontiac",
	},
	AWACS = {
		[1] = "Overlord",
		[2] = "Magic",
		[3] = "Wizard",
		[4] = "Focus",
		[5] = "Darkstar",
	},
	tanker = {
		[1] = "Texaco",
		[2] = "Arco",
		[3] = "Shell",
	}
}

local callsign_west_counter = {
	generic = math.random(0, #callsign_west.generic - 1),
	AWACS = math.random(0, #callsign_west.AWACS - 1),
	tanker = math.random(0, #callsign_west.tanker - 1),
}
local callsign_east_counter = 0

local function GetCallsign(country, flight_n, aircraft_n, task)
	local style
	if country == "Belgium" or country == "UK" or country == "Georgia" or country == "Denmark" or country == "Israel" or country == "Spain" or country == "Canada" or country == "Norway" or country == "USA" or country == "Turkey" or country == "France" or country == "The Netherlands" or country == "Italy" or country == "Australia" or country == "South Korea" or country == "Croatia" or country == "USAF Aggressors" then
		style = "west"
	else
		style = "east"
	end
	
	local callsign
	if style == "west" then
		local category
		if task == "AWACS" then
			category = "AWACS"
		elseif task == "Refueling" then
			category = "tanker"
		else
			category = "generic"
		end
	
		if flight_n == 1 and aircraft_n == 1 then
			callsign_west_counter[category] = callsign_west_counter[category] + 1
			if callsign_west_counter[category] > #callsign_west[category] then
				callsign_west_counter[category] = 1
			end
			callsign_flight = math.random(0, 8)
		end
		
		if aircraft_n == 1 then
			callsign_flight = callsign_flight + 1
			if callsign_flight > 9 then
				callsign_flight = 1
			end
		end
		
		callsign = {
			name = callsign_west[category][callsign_west_counter[category]] .. callsign_flight .. aircraft_n
		}
		
	elseif style == "east" then
		if aircraft_n == 1 then
			callsign_east_counter = callsign_east_counter + 1
		end
		callsign = 90 + callsign_east_counter * 10 + aircraft_n
	end
	
	return callsign
end


----- function to assign frquencies to packages -----
local assigned_freq = {}														--table to store frequencies in use
local package_freq = {															--table to store frequencies assigned to packages
	["blue"] = {},
	["red"] = {},
}

local function GetFrequency(side, pack_n)
	local freq

	if package_freq[side][pack_n] then											--if package already has a frequency
		return package_freq[side][pack_n]										--return frequency
	else																		--packe has no frequency yet
		repeat
			freq = math.random(camp.freq_min, camp.freq_max - 1)				--find random frequency in mHz
			local deci = math.random(0, 9) / 10									--random first decimal place
			local mil = math.random(0, 3) * 25 / 100							--random second and third decimal place (00/25/50/75)
			freq = freq + deci + mil											--combine to complete frequency
		until assigned_freq[freq] == nil										--repeat until a frequency is found that is not yet in use
		
		assigned_freq[freq] = true												--mark frequency in use
		package_freq[side][pack_n] = freq										--store frequency for package
		return freq																--return frequency
	end
end


----- create flight plans in mission file for all flights in ATO -----
for side, pack in pairs(ATO) do													--iterate through sides in ATO
	for p = 1, #pack do															--iterate through packages in sides
		for role,flight in pairs(pack[p]) do									--iterate through roles in package (main, SEAD, escort)		
			for f = 1, #flight do												--iterate through flights in roles
				
				local weaponType = "Auto"																				--Weapon types to use (default auto)
				if flight[f].loadout.description.weaponType == "Cannon" then
					weaponType = 805306368																				--Use cannon only
				elseif flight[f].loadout.description.weaponType == "Rockets" then
					weaponType = 30720																					--Use rockets only
				elseif flight[f].loadout.description.weaponType == "Bombs" then
					weaponType = 2032																					--Use unguided bombs only
				elseif flight[f].loadout.description.weaponType == "Guided bombs" then
					weaponType = 14																						--Use guided bombs only
				elseif flight[f].loadout.description.weaponType == "ASM" then
					weaponType = 4161536																				--Use ASM only
				end
				
				----- define waypoints -----
				local egress_wp													--local variable to store the Egress WP
				local wp_remove													--local variable for the target waypoint to be potentially removed for standoff ground attacks
				local spawn_time												--local variable to store spawn time
				local departure_time											--local variable to store departure time
				local waypoints = {}											--define waypoints of flight
				
				for w = 1, #flight[f].route do
					waypoints[w] = {
						["name"] = flight[f].route[w].id,
						["briefing_name"] = flight[f].route[w].id,				--not needed for actual mission creation, but added for navigation overview in briefing
						["alt"] = flight[f].route[w].alt,
						["type"] = "Turning Point",
						["action"] = "Turning Point",
						["alt_type"] = "BARO",
						["formation_template"] = "",
						["properties"] = 
						{
							["vnav"] = 1,
							["scale"] = 0,
							["angle"] = 0,
							["vangle"] = 0,
							["steer"] = 2,
						},
						["ETA"] = flight[f].route[w].eta,
						["y"] = flight[f].route[w].y,
						["x"] = flight[f].route[w].x,
						["speed"] = pack[p].main[1].loadout.description.vCruise,
						["ETA_locked"] = true,
						["task"] = 
						{
							["id"] = "ComboTask",
							["params"] = 
							{
								["tasks"] = {}
							},
						},
						["speed_locked"] = false,
						["number"] = w - 1,										--not needed for actual mission creation, but added for navigation overview in briefing where WP numbers start with 0
					}
					
					--navigation inormation on waypoint name for player flight
					if flight[f].player then																				--flight is player flight
						if waypoints[w - 1] then																			--previous waypoint exists
							local distance = GetDistance(waypoints[w - 1], waypoints[w])									--distance between waypoints
							if distance > 0 then																			--distance is not zero
								local heading = math.floor(GetHeading(waypoints[w - 1], waypoints[w]))						--heading between waypoints
								heading = heading - camp.variation															--adjust heading (true heading) with variation of map to get magnetix heading
								if heading < 0 then
									heading = heading + 360
								elseif heading > 359 then
									heading = heading - 360
								end
								if heading < 10 then
									heading = "00" .. heading
								elseif heading < 100 then
									heading = "0" .. heading
								end
								if camp.units == "metric" then
									distance = math.ceil(distance / 1000) .. "KM"
								else
									distance = math.ceil(distance / 1000 * 0.539957) .. "NM"
								end
								
								waypoints[w]["name"] = waypoints[w]["name"] .. ": " .. heading .. "/" .. distance			--add heading and distance to waypoint name
							end
						end
					end
					
					--store spawn and departure time for flight
					if flight[f].route[w].id == "Taxi" or flight[f].route[w].id == "Spawn" then
						spawn_time = flight[f].route[w].eta
					elseif flight[f].route[w].id == "Departure" then
						departure_time = flight[f].route[w].eta
					end
					
					--alter departure alt to prevent air spawn collisions of multiple packages
					if flight[f].route[w].id == "Departure" then
						waypoints[w]["alt"] = waypoints[w]["alt"] + ((p - 1) * 50)
					end
					
					--set attack speed for attack, target and egress waypoints
					if waypoints[w]["name"] == "Attack" or waypoints[w]["name"] == "Target" or waypoints[w]["name"] == "Egress" then
						waypoints[w]["ETA_locked"] = false
						waypoints[w]["speed_locked"] = true
						waypoints[w]["speed"] = pack[p].main[1].loadout.description.vAttack
					elseif waypoints[w]["name"] == "Join" or waypoints[w]["name"] == "Departure" then
						waypoints[w]["speed"] = pack[p].main[1].loadout.description.vCruise / 4 * 3							--speed to Join Point is 3/4 cruise speed
					end
					
					--attack waypoint is a fly over point
					if waypoints[w]["name"] == "Attack" then
						waypoints[w]["action"] = "Fly Over Point"
					end
					
					--fighter escorts fly with cruise speed to egress
					if waypoints[w]["name"] == "Egress" and flight[f].task == "Escort" then
						waypoints[w]["speed"] = pack[p].main[1].loadout.description.vCruise
					end
					
					--set speed locked for all WP after Egress or Station
					if flight[f].route[w].id == "Egress" or flight[f].route[w].id == "Station" and egress_wp == nil then	--find Egress or first Station WP
						egress_wp = w																						--store tgt wp number
					end
					if egress_wp and w > egress_wp then																		--for all WP after target or first station WP
						waypoints[w]["ETA_locked"] = false
						waypoints[w]["speed_locked"] = true
					end
					
					--altitudes below 1000m are AGL instead of MSL
					if waypoints[w]["alt"] <= 1000 then
						waypoints[w]["alt_type"] = "RADIO"
					end
					
					--take off and landing
					if flight[f].route[w].id == "Taxi" or flight[f].route[w].id == "Intercept" then
						waypoints[w]["type"] = "TakeOffParking"
						waypoints[w]["action"] = "From Parking Area"
						waypoints[w]["airdromeId"] = flight[f].airdromeId
						
						--if defined in camp, player flight starts with engines running
						if flight[f].player == true and camp.hotstart then
							waypoints[w]["action"] = "From Parking Area Hot"
							waypoints[w]["type"] = "TakeOffParkingHot"
						end
						
					elseif flight[f].route[w].id == "Land" then
						waypoints[w]["type"] = "Land"
						waypoints[w]["action"] = "Landing"
						waypoints[w]["airdromeId"] = flight[f].airdromeId
					end
					
					--target WP to be removed for non-player A-G attacks
					if flight[f].route[w].id == "Target" then											--WP is target WP
						if flight[f].task ~= "Reconnaissance" and (flight[f].task ~= "CAS" or flight[f].target.class ~= "airbase") then		--target WP is removed for all A-G tasks except recon or CAS against airbases (needs to aproach target to search for aircraft on ground)
							if flight[f].player ~= true then											--not the player flight (player always gets a target WP)
								wp_remove = w
							end
						end
					end
					
					--formations
					if flight[f].route[w].id == "Departure" or flight[f].route[w].id == "Split" then
						local task_entry = {															--Finger Four Close
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["auto"] = false,
							["id"] = "WrappedAction",
							["enabled"] = true,
							["params"] = 
							{
								["action"] = 
								{
									["id"] = "Option",
									["params"] = 
									{
										["variantIndex"] = 1,
										["name"] = 5,
										["formationIndex"] = 6,
										["value"] = 393217,
									},
								},
							},
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					elseif flight[f].route[w].id == "Join" or flight[f].route[w].id == "Spawn" then
						local task_entry = {															--Spread Four Close
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["auto"] = false,
							["id"] = "WrappedAction",
							["enabled"] = true,
							["params"] = 
							{
								["action"] = 
								{
									["id"] = "Option",
									["params"] = 
									{
										["variantIndex"] = 1,
										["name"] = 5,
										["formationIndex"] = 7,
										["value"] = 458753,
									},
								},
							},
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					end
					
					--attack tasks
					if flight[f].route[w].id == "Attack" then																	--Attack waypoint
						if flight[f].task == "Ground Attack" or flight[f].task == "Pinpoint Strike" then						--Tasks against scenery objects with multiple target sub-elements
							
							local target_element = {}																			--table to hold the target element number to be struck
							for e = 1, #flight[f].target.elements do															--iterate trough all target elements
								if flight[f].target.elements[e].dead ~= true then												--pick only elements that are not dead
									table.insert(target_element, e)																--add to target element table
								end
							end
							for n = 1, (f - 1) * 4 do																			--shift the order of target elements for subsequent flights in package, so that each flights starts attacking different elements (flight 1: element 1-4, flight 2: element 5-8, etc)
								table.insert(target_element, target_element[1])													--shift element order, copy first element to back
								table.remove(target_element, 1)																	--delete first element
							end
							
							--this is only to display attack markers in mission editor, task will be replaced in game by CustomMapObjectAttack
							-----------------------------------------------------------------------
							for n,e in ipairs(target_element) do
								local task_entry = {
									["enabled"] = false,
									["auto"] = false,
									["id"] = "AttackMapObject",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] = {
										["x"] = flight[f].target.elements[e].x,
										["y"] = flight[f].target.elements[e].y,
										["weaponType"] = weaponType,
										["expend"] = flight[f].loadout.description.expend,
										["direction"] = 0,
										["attackQtyLimit"] = false,
										["attackQty"] = 1,
										["directionEnabled"] = false,
										["groupAttack"] = true,
										["altitude"] = 2000,
										["altitudeEnabled"] = false,
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end
							-----------------------------------------------------------------------
							
							local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. f
							local expend = flight[f].loadout.description.expend
							local tgtlist = ""																					--list of of names of all target elements
							for n,e in ipairs(target_element) do
								tgtlist = tgtlist .. '{ x = ' .. flight[f].target.elements[e].x .. ', y = ' .. flight[f].target.elements[e].y .. '}, '
							end
							
							local task_entry = {																				--task is a command to run LUA code
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = 
								{
									["action"] = 
									{
										["id"] = "Script",
										["params"] = 
										{
											["command"] = 'CustomMapObjectAttack("' .. grpname .. '", {' .. tgtlist .. '}, "' .. expend .. '", "' .. weaponType .. '")',	--this is a custom written task to allow all aircraft in flight to attack multiple static objects simultenously
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						elseif flight[f].task == "Runway Attack" then
							
						elseif flight[f].task == "CAS" and flight[f].target.class == "vehicle" then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "AttackGroup",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = 
								{
									["groupId"] = flight[f].target.groupId,
									["weaponType"] = weaponType,
									["expend"] = flight[f].loadout.description.expend,
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						elseif flight[f].task == "CAS" and flight[f].target.class == "static" then
							
							local target_element = {}																			--table to hold the target element number to be struck
							for e = 1, #flight[f].target.elements do															--iterate trough all target elements
								if flight[f].target.elements[e].dead ~= true then												--pick only elements that are not dead
									table.insert(target_element, e)																--add to target element table
								end
							end
							for n = 1, (f - 1) * 4 do																			--shift the order of target elements for subsequent flights in package, so that each flights starts attacking different elements (flight 1: element 1-4, flight 2: element 5-8, etc)
								table.insert(target_element, target_element[1])													--shift element order, copy first element to back
								table.remove(target_element, 1)																	--delete first element
							end
							
							--this is only to display attack markers in mission editor, task will be replaced in game by CustomStaticAttack
							-----------------------------------------------------------------------
							for n,e in ipairs(target_element) do
								local task_entry = {
									["enabled"] = false,
									["auto"] = false,
									["id"] = "AttackGroup",
									["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
									["params"] = {
										["groupId"] = flight[f].target.elements[e].groupId,
										["weaponType"] = weaponType,
										["expend"] = flight[f].loadout.description.expend,
									},
								}
								table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
							end
							-----------------------------------------------------------------------
						
							local grpname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. f
							local expend = flight[f].loadout.description.expend
							local tgtlist = ""																					--list of of names of all target elements
							for n,e in ipairs(target_element) do
								tgtlist = tgtlist .. '"' .. flight[f].target.elements[e].name .. '", '
							end
							
							local task_entry = {																				--task is a command to run LUA code
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = 
								{
									["action"] = 
									{
										["id"] = "Script",
										["params"] = 
										{
											["command"] = 'CustomStaticAttack("' .. grpname .. '", {' .. tgtlist .. '}, "' .. expend .. '", "' .. weaponType .. '")',	--this is a custom written task to allow all aircraft in flight to attack multiple static objects simultenously
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						elseif flight[f].task == "CAS" and flight[f].target.class == "airbase" then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "EngageTargetsInZone",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = 
								{
									["targetTypes"] = 
									{
										[1] = "Air",
									},
									["x"] = flight[f].target.x,
									["y"] = flight[f].target.y,
									["priority"] = 0,
									["zoneRadius"] = 3000,
									["weaponType"] = weaponType,
									["expend"] = flight[f].loadout.description.expend,
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						elseif flight[f].task == "Anti-ship Strike" then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "AttackGroup",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = 
								{
									["groupId"] = flight[f].target.groupId,
									["weaponType"] = weaponType,
									["expend"] = flight[f].loadout.description.expend,
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end
					
					--SEAD engage tasks for each route segment
					if flight[f].task == "SEAD" then
						if flight[f].route[w].SEAD_radius then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "ControlledTask",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = 
								{
									["task"] = 
									{
										["id"] = "EngageTargets",
										["params"] = 
										{
											["targetTypes"] = 
											{
												[1] = "SAM TR",
											},
											["maxDistEnabled"] = true,
											["priority"] = 0,
											["maxDist"] = flight[f].route[w].SEAD_radius,
											["weaponType"] = 268402702,
										},
									},
									["stopCondition"] = 
									{
										["lastWaypoint"] = w,
									},
								}
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end
					
					--orbit on departure
					if flight[f].route[w].id == "Departure" and flight[f].task ~= "Transport" then
						local task_entry = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "ControlledTask",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] = 
							{
								["task"] = 
								{
									["id"] = "Orbit",
									["params"] = 
									{
										["altitude"] = waypoints[w]["alt"] + (f - 1) * 100,
										["pattern"] = "Circle",
										["speed"] = pack[p].main[1].loadout.description.vCruise / 3 * 2,
									},
								},
								["stopCondition"] = 
								{
									["time"] = departure_time
								}
							}
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					end
					
					--orbit on station
					if flight[f].route[w].id == "Station" and flight[f].route[w + 1].id == "Station" then
						local task_entry = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "ControlledTask",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] = 
							{
								["task"] = 
								{
									["id"] = "Orbit",
									["params"] = 
									{
										["altitude"] = flight[f].loadout.description.hAttack,
										["pattern"] = "Race-Track",
										["speed"] = flight[f].loadout.description.vAttack,
									},
								},
								["stopCondition"] = 
								{
									["time"] = flight[f].route[w + 1].eta
								}
							}
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					end
					
					--orbit on egress
					if flight[f].route[w].id == "Egress" and (flight[f].task == "SEAD" or flight[f].task == "Escort") then
						local task_entry = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "ControlledTask",
							["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
							["params"] = 
							{
								["task"] = 
								{
									["id"] = "Orbit",
									["params"] = 
									{
										["altitude"] = waypoints[w]["alt"],
										["pattern"] = "Circle",
										["speed"] = pack[p].main[1].loadout.description.vCruise,
									},
								},
								["stopCondition"] = 
								{
									["time"] = flight[f].route[w].eta
								}
							}
						}
						table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
					end
					
					--restrict RTB on winchester from IP on
					if flight[f].route[w].id == "IP" and (flight[f].task == "SEAD" or flight[f].task == "CAS" or flight[f].task == "Ground Attack" or flight[f].task == "Pinpoint Strike" or flight[f].task == "Runway Attack" or flight[f].task == "Anti-ship Strike") then
						if flight[f].player ~= true then
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = 
								{
									["action"] = 
									{
										["id"] = "Option",
										["params"] = 
										{
											["value"] = 0,
											["name"] = 10,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end
					
					--restrict weapon jettison from IP on
					if flight[f].route[w].id == "IP" and (flight[f].task == "CAS" or flight[f].task == "Ground Attack" or flight[f].task == "Pinpoint Strike" or flight[f].task == "Runway Attack" or flight[f].task == "Anti-ship Strike") then
						if flight[f].player ~= true then	
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = 
								{
									["action"] = 
									{
										["id"] = "Option",
										["params"] = 
										{
											["value"] = true,
											["name"] = 15,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end
					
					--allow weapon jettison from egress on
					if flight[f].route[w].id == "Egress" and (flight[f].task == "SEAD" or flight[f].task == "CAS" or flight[f].task == "Ground Attack" or flight[f].task == "Pinpoint Strike" or flight[f].task == "Runway Attack" or flight[f].task == "Anti-ship Strike") then
						if flight[f].player ~= true then	
							local task_entry = {
								["enabled"] = true,
								["auto"] = false,
								["id"] = "WrappedAction",
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["params"] = 
								{
									["action"] = 
									{
										["id"] = "Option",
										["params"] = 
										{
											["value"] = false,
											["name"] = 15,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end
					
					--IP/egress reaction on threat for recon
					if flight[f].task == "Reconnaissance" and flight[f].route[w].id == "IP" then
						if flight[f].player ~= true then	
							local task_entry = {
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["auto"] = false,
								["id"] = "WrappedAction",
								["enabled"] = true,
								["params"] = 
								{
									["action"] = 
									{
										["id"] = "Option",
										["params"] = 
										{
											["value"] = 1,
											["name"] = 1,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					elseif flight[f].task == "Reconnaissance" and flight[f].route[w].id == "Egress" then
						if flight[f].player ~= true then	
							local task_entry = {
								["number"] = #waypoints[w]["task"]["params"]["tasks"] + 1,
								["auto"] = false,
								["id"] = "WrappedAction",
								["enabled"] = true,
								["params"] = 
								{
									["action"] = 
									{
										["id"] = "Option",
										["params"] = 
										{
											["value"] = 2,
											["name"] = 1,
										},
									},
								},
							}
							table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
						end
					end
				end

				--remove target WP for certain flights
				if wp_remove then
					table.remove(waypoints, wp_remove)
				end
				
				--remove taxi waypoint for non-player flights
				if flight[f].player ~= true then
					if waypoints[1].name == "Taxi" then
						table.remove(waypoints, 1)
						waypoints[1]["type"] = "TakeOffParking"
						waypoints[1]["action"] = "From Parking Area"
						waypoints[1]["airdromeId"] = flight[f].airdromeId
						waypoints[1]["ETA"] = spawn_time
					end
				else
					if waypoints[1].name == "Taxi" then
						waypoints[1]["speed"] = 5.138
					end
				end
				
				--lock speed of first waypoint
				waypoints[1]["speed_locked"] = true
				if waypoints[1]["speed"] == nil then
					waypoints[1]["speed"] = 1
				end
				
				--first waypoint RTB on winchester
				if flight[f].task == "SEAD" or flight[f].task == "CAS" or flight[f].task == "Ground Attack" or flight[f].task == "Pinpoint Strike" or flight[f].task == "Runway Attack" or flight[f].task == "Anti-ship Strike" then
					if flight[f].player ~= true then
						local task_entry = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
							["params"] = 
							{
								["action"] = 
								{
									["id"] = "Option",
									["params"] = 
									{
										["value"] = weaponType,
										["name"] = 10,
									},
								},
							},
						}
						table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
					end
				end
				
				--first waypoint reaction to threat
				local task_entry = {
					["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
					["auto"] = false,
					["id"] = "WrappedAction",
					["enabled"] = true,
					["params"] = 
					{
						["action"] = 
						{
							["id"] = "Option",
							["params"] = 
							{
								["value"] = 2,
								["name"] = 1,
							},
						},
					},
				}
				table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
				
				--first waypoint restrict jettison for SEAD
				if flight[f].task == "SEAD" then
					local task_entry = {
						["enabled"] = true,
						["auto"] = false,
						["id"] = "WrappedAction",
						["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
						["params"] = 
						{
							["action"] = 
							{
								["id"] = "Option",
								["params"] = 
								{
									["value"] = true,
									["name"] = 15,
								},
							},
						},
					}
					table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
				end
				
				--first waypoint enroute tasks
				if flight[f].task == "CAP" then
					local task_entry = {
						["enabled"] = true,
						["auto"] = false,
						["id"] = "EngageTargets",
						["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
						["params"] = 
						{
							["targetTypes"] = 
							{
								[1] = "Planes",
							},
							["maxDistEnabled"] = true,
							["priority"] = 0,
							["maxDist"] = flight[f].loadout.description.standoff,
						},
					}
					table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)							
				elseif flight[f].task == "Fighter Sweep" then
					local task_entry = {
						["enabled"] = true,
						["auto"] = false,
						["id"] = "EngageTargets",
						["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
						["params"] = 
						{
							["targetTypes"] = 
							{
								[1] = "Planes",
							},
							["maxDistEnabled"] = true,
							["priority"] = 0,
							["maxDist"] = flight[f].loadout.description.standoff,
						},
					}
					table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)	
				elseif flight[f].task == "Escort" then
					local task_entry = {
						["enabled"] = true,
						["auto"] = false,
						["id"] = "EngageTargets",
						["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
						["params"] = 
						{
							["targetTypes"] = 
							{
								[1] = "Fighters",
							},
							["maxDistEnabled"] = true,
							["priority"] = 0,
							["maxDist"] = flight[f].loadout.description.standoff,
						},
					}
					table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
				elseif flight[f].task == "AWACS" then
					local task_entry = {
						["enabled"] = true,
						["auto"] = false,
						["id"] = "AWACS",
						["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
						["params"] = 
						{
						},
					}
					table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
				elseif flight[f].task == "Refueling" then
					local task_entry = {
						["enabled"] = true,
						["auto"] = false,
						["id"] = "Tanker",
						["number"] = #waypoints[1]["task"]["params"]["tasks"] + 1,
						["params"] = 
						{
						},
					}
					table.insert(waypoints[1]["task"]["params"]["tasks"], task_entry)
				end
				
				
				----- define units -----
				local units = {}
				for n = 1, flight[f].number do
					units[n] = {
						["alt"] = waypoints[1].alt,
						["heading"] = 0,
						["callsign"] = GetCallsign(flight[f].country, f, n, flight[f].task),
						["psi"] = 0,
						["livery_id"] = flight[f].livery,
						["onboard_num"] = "0" .. math.random(1, 99),
						["type"] = flight[f].type,
						["y"] = waypoints[1]["y"] + ((n - 1) * 100),
						["x"] = waypoints[1]["x"] + ((n - 1) * 100),
						["name"] = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. f .. "-" .. n,
						["payload"] = flight[f].loadout.stores,
						["speed"] = waypoints[1].speed,
						["unitId"] = GenerateID(),
						["alt_type"] = waypoints[1].alt_type,
						["skill"] = flight[f].skill,
						["hardpoint_racks"] = true,
						["AddPropAircraft"] = flight[f].properties,
						["parking_id"] = getParkingId(flight[f].base),
						--["parking"] = "" .. n,
					}
					
					--multiple skins for aircraft
					if type(units[n]["livery_id"]) == "table" then												--if skin is a table
						units[n]["livery_id"] = units[n]["livery_id"][math.random(1, #units[n]["livery_id"])]	--chose a random skin from table
					end
				end
				
			
				----- define group -----
				local group = {				
					['frequency'] = GetFrequency(side, p),
					['taskSelected'] = true,
					['modulation'] = 0,
					['groupId'] = GenerateID(),
					['tasks'] = {
					},
					['route'] = {
						['points'] = waypoints,
					},
					['hidden'] = true,
					['units'] = units,
					['radioSet'] = true,
					["name"] = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. f,
					['communication'] = true,
					['x'] = waypoints[1]["x"],
					['y'] = waypoints[1]["y"],
					['start_time'] = 1,
					['task'] = flight[f].task,
					['uncontrolled'] = false,
				}
				
				if flight[f].task == "Escort" then												--if task is escort
					group['task'] = "Fighter Sweep"												--make task fighter sweep, because escort does not have engage tasks
				end
				
				if camp.player and camp.player.pack_n == p and camp.player.EWR_freq then		--player package and player has an EWR frequency (site that detected targets to intercept)
					group['frequency'] = tonumber(camp.player.EWR_freq)							--put player package on EWR frequency
				end
				
				---- unhide player package -----
				if camp.debug then																--debug is on
					group.hidden = false														--unhide all groups
				elseif camp.player and camp.player.side == side then							--player side										
					if camp.player.pack_n == p then												--package is player package
						group.hidden = false													--unhide group
					elseif flight[f].task == "AWACS" then										--flight is an AWACS on player side
						group.hidden = false													--unhide group
					elseif flight[f].task == "Refueling" then									--flight is a tanker on player side
						group.hidden = false													--unhide group
					end
				end
				
				----- late groups spawn uncontrolled at mission start -----
				if group['route']['points'][1]["ETA"] > 0 and flight[f].task ~= "Intercept" then		--group launches after mission start
					group['route']['points'][1]["ETA"] = 2										--first waypoint ETA is 2 for uncontrolled group to spawn at mission start
					
					if flight[f].player ~= true then											--for non-player groups
						group['uncontrolled'] = true											--make group uncontrolled
						
						--triggered action to start uncontrolled group
						group['tasks'] = {
							[1] = {
								["number"] = 1,
								["name"] = group.name,
								["id"] = "WrappedAction",
								["auto"] = false,
								["enabled"] = true,
								["params"] = {
									["action"] = {
										["id"] = "Start",
										["params"] = {},
									},
								},
							},
						}
						
						--mission trigger to initiate triggered action
						local trig_n = #mission.trig.func + 1										--next available trigger number
						mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
						mission.trig.flag[trig_n] = true
						mission.trig.conditions[trig_n] = "return(c_time_after(" .. spawn_time .. ") )"
						mission.trig.actions[trig_n] = "a_set_ai_task(" .. group.groupId .. ", 1); mission.trig.func[" .. trig_n .. "]=nil;"
						mission.trigrules[trig_n] = {
							['rules'] = {
								[1] = {
									["seconds"] = spawn_time,
									["coalitionlist"] = "red",
									["predicate"] = "c_time_after",
									["zone"] = "",
								},
							},
							['eventlist'] = '',
							['comment'] = 'Trigger ' .. trig_n,
							['predicate'] = 'triggerOnce',
							['actions'] = {
								[1] = {
									["ai_task"] = {
										[1] = "",
										[2] = "",
									},
									["predicate"] = "a_set_ai_task",
									["set_ai_task"] = {
										[1] = group.groupId,
										[2] = 1,
									}
								},
							},
						}
					end
				end
				
				
				----- provisions for interceptors/GCI/AWACS -----
				if flight[f].task == "Intercept" and flight[f].player ~= true then
					group['uncontrolled'] = true												--make interceptor groups uncontrolled at mission start
					
					GCI.Flag = GCI.Flag + 1														--go to next trigger flag number
					
					--build Interceptor table
					GCI.Interceptor[side].ready[group.name] = {
						number = #group.units,
						range = flight[f].target.radius,
						x = group.x,
						y = group.y,
						flag = GCI.Flag,
						tot_from = flight[f].tot_from,
						tot_to = flight[f].tot_to,
						airdromeId = flight[f].airdromeId,
					}
					
					--triggered action to start uncontrolled group
					group['tasks'] = {
						[1] = {
							["number"] = 1,
							["name"] = group.name,
							["id"] = "WrappedAction",
							["auto"] = false,
							["enabled"] = true,
							["params"] = {
								["action"] = {
									["id"] = "Start",
									["params"] = {},
								},
							},
						},
					}
					
					--mission trigger to initiate triggered action
					local trig_n = #mission.trig.func + 1										--next available trigger number
					mission.trig.func[trig_n] = "if mission.trig.conditions[" .. trig_n .. "]() then mission.trig.actions[" .. trig_n .. "]() end"
					mission.trig.flag[trig_n] = true
					mission.trig.conditions[trig_n] = "return(c_flag_is_true(" .. GCI.Flag .. ") )"
					mission.trig.actions[trig_n] = "a_set_ai_task(" .. group.groupId .. ", 1); mission.trig.func[" .. trig_n .. "]=nil;"
					mission.trigrules[trig_n] = {
						['rules'] = {
							[1] = {
								["flag"] = GCI.Flag,
								["coalitionlist"] = "red",
								["predicate"] = "c_flag_is_true",
								["zone"] = "",
							},
						},
						['eventlist'] = '',
						['comment'] = 'Trigger ' .. trig_n,
						['predicate'] = 'triggerOnce',
						['actions'] = {
							[1] = {
								["ai_task"] = {
									[1] = "",
									[2] = "",
								},
								["predicate"] = "a_set_ai_task",
								["set_ai_task"] = {
									[1] = group.groupId,
									[2] = 1,
								}
							},
						},
					}
				elseif flight[f].task == "AWACS" then
					GCI.EWR[side][units[1].name] = true											--add AWACS to EWR table
				end
				
				if flight[f].player == true then												--if this is the player flight
					if camp.coop == 1 then
						units[1]["skill"] = "Player"											--make first aircraft in flight the player aircraft
					elseif camp.coop == 2 then
						units[1]["skill"] = "Client"
						units[2]["skill"] = "Client"
					elseif camp.coop == 3 then
						units[1]["skill"] = "Client"
						units[2]["skill"] = "Client"
						units[3]["skill"] = "Client"
					elseif camp.coop == 4 then
						units[1]["skill"] = "Client"
						units[2]["skill"] = "Client"
						units[3]["skill"] = "Client"
						units[4]["skill"] = "Client"
					end
				end
				
				if type(units[1].callsign) == "number" then										--Russian style
					ATO[side][p][role][f].callsign = units[1].callsign							--store flight callsign in ATO
				else																			--NATO style
					ATO[side][p][role][f].callsign = units[1].callsign.name						--store flight callsign in ATO									
				end
				
				ATO[side][p][role][f].frequency = group.frequency								--store package frequency in ATO
				
				------ add group to mission -----
				for c = 1, #mission.coalition[side].country do
					if mission.coalition[side].country[c].name == flight[f].country then
						if mission.coalition[side].country[c].plane == nil then
							mission.coalition[side].country[c].plane = {
								group = {}
							}
						end
						table.insert(mission.coalition[side].country[c].plane.group, group)
						
						if flight[f].player == true then										
							camp.player.group = mission.coalition[side].country[c].plane.group[#mission.coalition[side].country[c].plane.group]	--store a link to the group table in the mission file
						end
					end
				end
			end
		end
	end
end