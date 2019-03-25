--To add unused ready aircraft as uncontrolled static aircraft to mission
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 

--Count all aircraft assigned in ATO
local count = {}

for side_name, side in pairs(ATO) do										--Iterate through sides in ATO
	for pack_n, pack in pairs(side) do										--Iterate through packages
		for role_name, role in pairs(pack) do								--Iterate throug roles
			for flight_n, flight in pairs(role) do							--Iterate through flights
				if count[flight.name] then									--Unit already has a count entry
					count[flight.name] = count[flight.name] + flight.number	--Sum number
				else														--Unit has no count entry
					count[flight.name] = flight.number						--Create count entry
				end
			end
		end
	end
end


--Function to add a number of uncontrolled aircraft per unit to mission
local function AddUncontrolledAircraft(side, unit, number)
	for u = 1, number do													--Repeat for each unasisgned aircraft
		local group = {														--Define group to spawn
			['frequency'] = 124,
			['taskSelected'] = true,
			['modulation'] = 0,
			['groupId'] = GenerateID(),
			['tasks'] = {},
			['route'] = {
				['points'] = {
					[1] = {
						["name"] = "Static",
						["alt"] = 0,
						["type"] = "TakeOffParking",
						["action"] = "From Parking Area",
						["airdromeId"] = db_airbases[unit.base].airdromeId,
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
						["ETA"] = 1,
						["y"] = db_airbases[unit.base].y,
						["x"] = db_airbases[unit.base].x,
						["speed"] = 0,
						["ETA_locked"] = true,
						["task"] = 
						{
							["id"] = "ComboTask",
							["params"] = 
							{
								["tasks"] = {}
							},
						},
						["speed_locked"] = true,
					},
				},
			},
			['hidden'] = true,
			['units'] = {
				[1] = {
					["alt"] = 0,
					["heading"] = 0,
					["callsign"] = "123",
					["psi"] = 0,
					["livery_id"] = unit.livery,
					["onboard_num"] = "0" .. u,
					["type"] = unit.type,
					["y"] = db_airbases[unit.base].y,
					["x"] = db_airbases[unit.base].x,
					["name"] = "Static " .. unit.name .. " " .. u .. "-1",
					["payload"] = {
						["pylons"] = {},
						["fuel"] = "0",
						["flare"] = 0,
						["chaff"] = 0,
						["gun"] = 0,
					},
					["speed"] = 0,
					["unitId"] = GenerateID(),
					["alt_type"] = "BARO",
					["skill"] = unit.skill,
					["hardpoint_racks"] = true,
					--["parking"] = "1",
				},
			},
			['radioSet'] = true,
			['name'] = "Static " .. unit.name .. " " .. u,
			['communication'] = true,
			['x'] = db_airbases[unit.base].x,
			['y'] = db_airbases[unit.base].y,
			['start_time'] = 1,
			['task'] = "Nothing",
			['uncontrolled'] = true,
		}
		
		--multiple skins for aircraft
		if type(group.units[1]["livery_id"]) == "table" then															--if skin is a table
			group.units[1]["livery_id"] = group.units[1]["livery_id"][math.random(1, #group.units[1]["livery_id"])]		--chose a random skin from table
		end
		
		--add group to mission
		for c = 1, #mission.coalition[side].country do
			if mission.coalition[side].country[c].name == unit.country then
				if mission.coalition[side].country[c].plane == nil then
					mission.coalition[side].country[c].plane = {
						group = {}
					}
				end
				table.insert(mission.coalition[side].country[c].plane.group, group)
			end
		end
	end
end



--Count unassigned aircraft and add them to mission as idle at airbase
for side,unit in pairs(oob_air) do												--Iterate through sides in oob_air
	for n = 1, #unit do															--iterate through units
		if unit[n].inactive ~= true then										--unit is active
			if db_airbases[unit[n].base].airdromeId then						--check if airbase has an id (aircraft at "virtual" airfields, such as reserves, are not placed in mission as static aircraft)
				local unassigned												--number of unassigned aircraft
				for unit_name, assigned in pairs(count) do						--Iterate through count table
					if unit[n].name == unit_name then							--Unit found
						unassigned = unit[n].roster.ready - assigned			--Number of unassigned aircaft is ready aircraft - assigned aircraft
						break													--End count iteration
					end
				end
				if unassigned == nil then										--If unassigned is still nil (unit has no aircraft in ATO)
					unassigned = unit[n].roster.ready							--All ready aircraft are unassigned
				end
				if unassigned > 12 then											--if more than 12
					unassigned = 12 + math.floor((unassigned - 12) * 0.5)		--amount above 12 is halfed
				end
				AddUncontrolledAircraft(side, unit[n], unassigned)				--Add uncontrolled aircraft for this unit
			end
		end
	end
end