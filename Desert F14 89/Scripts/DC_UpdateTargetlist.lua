--To update the targetlist (target position depending on current vehcile/ship position, alive precentage)
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 

GroundTarget = {																				--count total and alive ground targets for each side
	["red"] = {
		total = 0,
		alive = 0,
	},
	["blue"] = {
		total = 0,
		alive = 0,
	},
}

for side_name, side in pairs(targetlist) do														--Iterate through all side
	for target_name, target in pairs(side) do													--Iterat through all targets
		if target.inactive ~= true then															--target is active
			
			local targetside = "red"															--variable which side the target is on
			if side_name == "red" then
				targetside = "blue"
			end
		
			if target.task == "Ground Attack" or target.task == "Pinpoint Strike" then			--For scenery object targets
				target.alive = 100																--Introduce percentage of alive target elements
				target.x = 0																	--Introduce x coordinate for target
				target.y = 0																	--Introduce y coordinate for target
				target.dead_last = 0															--Introduce percentage of elements that died in last mission (for debriefing)
				for e = 1, #target.elements do													--Iterate through elements of target
					target.x = target.x + target.elements[e].x									--Sum x coordinates of all elements
					target.y = target.y + target.elements[e].y									--Sum y coordinates of all elements
					if target.elements[e].dead then												--if target element is dead		
						target.alive = target.alive - 100 / #target.elements					--reduce target alive percentage	
					end
					if target.elements[e].dead_last then
						target.dead_last = target.dead_last + 100 / #target.elements			--add target died in last mission percentage
					end
				end
				target.alive = math.floor(target.alive)
				target.dead_last = math.floor(target.dead_last)
				target.x = target.x / #target.elements											--target x coordinate is average x coordinate of all elements
				target.y = target.y / #target.elements											--target y coordinate is average y coordinate of all elements
			
			elseif target.task == "CAS" then													--For vehicle group targets
				if target.class == "vehicle" then												--target consist of vehciles
					target.alive = 100															--Introduce percentage of alive target elements
					for country_n, country in pairs(oob_ground[targetside]) do					--iterate through countries
						if country.vehicle then
							for group_n, group in pairs(country.vehicle.group) do				--iterate through groups in country.vehcile.group table
								if group.name == target.name then								--if the target is found in group table
									target.groupId = group.groupId								--store target group ID
									target.x = group.x											--add x coordinate of target
									target.y = group.y											--add y coordinate of target
									target.elements = {}										--add elements table
									target.dead_last = 0										--Introduce percentage of elements that died in last mission (for debriefing)
									for unit_n, unit in pairs(group.units) do					--Iterate through all units of group
										target.elements[unit_n] = {								--add new element
											name = unit.name,									--store unit name
											dead = unit.dead,									--store unit status
										}
									end
									for unit_n, unit in pairs(group.units) do						--Iterate through all units of group
										if unit.dead then											--Unit is dead
											target.alive = target.alive - 100 / #target.elements	--reduce target alive percentage	
										end
										if unit.dead_last then
											target.dead_last = target.dead_last + 100 / #target.elements	--add target died in last mission percentage
										end
									end
									target.alive = math.floor(target.alive)
									target.dead_last = math.floor(target.dead_last)
									break
								end
							end
						end
					end
				elseif target.class == "static" then											--target consists of static objects
					target.alive = 100															--Introduce percentage of alive target elements
					target.x = 0																--Introduce x coordinate for target
					target.y = 0																--Introduce y coordinate for target
					target.dead_last = 0														--Introduce percentage of elements that died in last mission (for debriefing)
					for country_n, country in pairs(oob_ground[targetside]) do					--iterate through countries
						if country.static then													--country has static objects
							for group_n, group in pairs(country.static.group) do				--iterate through groups in country.static.group table
								for e = 1, #target.elements do									--Iterate through elements of target						
									if group.name == target.elements[e].name then				--if the target element is found in group table								
										target.x = target.x + group.x							--Sum x coordinates of all elements
										target.y = target.y + group.y							--Sum y coordinates of all elements
										target.elements[e].groupId = group.groupId				--store target element group ID
										target.elements[e].dead = group.units[1].dead			--store unit status
										target.elements[e].dead_last = group.units[1].dead_last			--store unit status
										if target.elements[e].dead then									--Unit is dead
											target.alive = target.alive - 100 / #target.elements		--reduce target alive percentage										
										end
										if target.elements[e].dead_last then
											target.dead_last = target.dead_last + 100 / #target.elements	--add target died in last mission percentage
										end
										break
									end
								end
							end
						end
					end
					target.alive = math.floor(target.alive)
					target.dead_last = math.floor(target.dead_last)
					target.x = target.x / #target.elements										--target x coordinate is average x coordinate of all elements
					target.y = target.y / #target.elements										--target y coordinate is average y coordinate of all elements
				elseif target.class == "airbase" then											--target consists of aircraft on ground
					target.alive = false														--target alive false makes sure that target is not included in ATO (gets reverted below if target airfield has ready aircraft)
					for n = 1, #oob_air[targetside] do											--iterate through enemy aviation units
						if oob_air[targetside][n].base == target.name then						--aviation unit is on target base
							if oob_air[targetside][n].roster.ready > 0 then						--aviation unit has ready aircraft
								target.alive = nil												--alive nil makes sure that target is included in ATO but is not listed in briefing ground OOB
								target.unit = {													--add entry for aviation unit at target airbase
									name = oob_air[targetside][n].name,							--name of aviation unit at target airbase
									type = oob_air[targetside][n].type,							--type of aircraft at target airbase
									number = oob_air[targetside][n].roster.ready,				--ready aircraft of aviation unit at target airbase
								}
								if db_airbases[target.name] then								--if the target airbase has an entry in db_airbases table
									target.x = db_airbases[target.name].x						--add x coordinate of target
									target.y = db_airbases[target.name].y						--add y coordinate of target
								end
							end
						end
					end
				end
			
			elseif target.task == "Anti-ship Strike" then										--For ship group targets
				for country_n, country in pairs(oob_ground[targetside]) do						--iterate through countries
					if country.ship then
						for group_n, group in pairs(country.ship.group) do						--Iterate through groups in country.ship.group table
							if group.name == target.name then									--If the target is found in group table
								target.alive = 100												--Introduce percentage of alive target elements
								target.groupId = group.groupId									--store target group ID
								target.x = group.x												--add x coordinate of target
								target.y = group.y												--add y coordinate of target
								target.elements = {}											--add elements table
								target.dead_last = 0											--Introduce percentage of elements that died in last mission (for debriefing)
								for unit_n, unit in pairs(group.units) do						--Iterate through all units of group
									target.elements[unit_n] = {									--add new element
										name = unit.name,										--store unit name
										dead = unit.dead,										--store unit status
									}
								end
								for unit_n, unit in pairs(group.units) do						--Iterate through all units of group
									if unit.dead then											--Unit is dead
										target.alive = target.alive - 100 / #target.elements	--reduce target alive percentage	
									end
									if unit.dead_last then
										target.dead_last = target.dead_last + 100 / #target.elements	--add target died in last mission percentage
									end
								end
								target.alive = math.floor(target.alive)
								target.dead_last = math.floor(target.dead_last)
								break
							end
						end
					end
				end
				if target.x == nil then															--if target x coordinate is still nil, group was not found in oob_table
					target = nil																--remove target from targetlist
				end
				
			elseif target.task == "Transport" or target.task == "Nothing" then					--For transport or ferry tasks
				target.x = db_airbases[target.destination].x
				target.y = db_airbases[target.destination].y
				
			end
			
			if target.alive then																--target has an alive value (is a ground target)
				if target.alive < 0 then														--if target alive is lower than 0 (due to rounding errors)
					target.alive = 0															--set target alive 0
				end
				
				GroundTarget[side_name].total = GroundTarget[side_name].total + 1				--count the number of all ground targets for each side
				if target.alive > 0 then														--target is not destroyed
					GroundTarget[side_name].alive = GroundTarget[side_name].alive + 1			--count the number of all alive ground targets for each side
				end
			end
		end
	end
	
	if GroundTarget[side_name].total > 0 then
		GroundTarget[side_name].percent = math.ceil(100 / GroundTarget[side_name].total * GroundTarget[side_name].alive)	--calculate percentage of alive ground targets per side
	end
end

