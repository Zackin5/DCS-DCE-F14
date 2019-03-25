--To put vehicles and ships from ground OOB into next mission
--Initiated by MAIN_NextMission.lua
-------------------------------------------------------------------------------------------------------

mission.coalition.blue.country = deepcopy(oob_ground.blue)											--copy blue oob into mission
mission.coalition.red.country = deepcopy(oob_ground.red)											--copy red oob into mission

--iterate through all vehicles and ships to remove those marked as dead during previous debriefings (static objects need not be removed, as these are spawned in a destroyed state)
for k1,v1 in pairs(mission.coalition) do															--side table(red/blue)	
	for k2,v2 in pairs(v1.country) do																--country table (number array)
		if v2.vehicle then																			--if country has vehicles
			local n = 1
			local nEnd = #v2.vehicle.group
			repeat																					--groups table (number array)
				local m = 1
				local mEnd = #v2.vehicle.group[n].units
				repeat																				--units table (number array)
					if v2.vehicle.group[n].units[m].dead then
						
						--dead units are replaced by dead static objects
						if v2.static == nil then													--country table has no other static objects
							v2.static = {															--create static objects table
								group = {}															--create group subtable
							}
						end
						
						local dead_static_group = {													--define dead static group to replace dead unit 
							["heading"] = v2.vehicle.group[n].units[m].heading,						--set static group heading according to dead unit
							["route"] = {
								["points"] = 
								{
									[1] = 
									{
										["alt"] = 0,
										["type"] = "",
										["name"] = "",
										["y"] = v2.vehicle.group[n].units[m].y,
										["speed"] = 0,
										["x"] = v2.vehicle.group[n].units[m].x,
										["formation_template"] = "",
										["action"] = "",
									},
								},
							},
							["groupId"] = GenerateID(),
							["hidden"] = true,
							["units"] = {
								[1] = {
									["category"] = "Unarmed",
									["canCargo"] = false,
									["type"] = v2.vehicle.group[n].units[m].type,
									["unitId"] = GenerateID(),
									["y"] = v2.vehicle.group[n].units[m].y,
									["x"] = v2.vehicle.group[n].units[m].x,
									["name"] = v2.vehicle.group[n].units[m].name,
									["heading"] = v2.vehicle.group[n].units[m].heading,
								},
							},
							["y"] = v2.vehicle.group[n].units[m].y,
							["x"] = v2.vehicle.group[n].units[m].x,
							["name"] = "Dead Static " .. v2.vehicle.group[n].units[m].name,
							["dead"] = true,
						}
						table.insert(v2.static.group, dead_static_group)							--add group to static table
						
						--remove dead unit from vehicle table
						if #v2.vehicle.group[n].units == 1 then										--if group has only one unit
							table.remove(v2.vehicle.group, n)										--remove group of dead unit from group table
							n = n - 1
							nEnd = nEnd - 1
						else
							table.remove(v2.vehicle.group[n].units, m)								--remove dead unit from units table
							v2.vehicle.group[n].route.points[1].x = v2.vehicle.group[n].units[1].x	--update group position to position of first units
							v2.vehicle.group[n].route.points[1].y = v2.vehicle.group[n].units[1].y	--update group position to position of first units
							m = m - 1
							mEnd = mEnd - 1
						end
					end
					m = m + 1
				until m > mEnd
				n = n + 1
			until n > nEnd
		end
		if v2.ship then																				--if country has ships
			local n = 1
			local nEnd = #v2.ship.group
			repeat																					--groups table (number array)
				local m = 1
				local mEnd = #v2.ship.group[n].units
				repeat																				--units table (number array)	
					if v2.ship.group[n].units[m].dead then
						if #v2.ship.group[n].units == 1 then										--if group has only one unit
							table.remove(v2.ship.group, n)											--remove group of dead unit from group table
							n = n - 1
							nEnd = nEnd - 1
						else
							table.remove(v2.ship.group[n].units, m)									--remove dead unit from units table
							m = m - 1
							mEnd = mEnd - 1
						end
					end
					m = m + 1
				until m > mEnd
				n = n + 1
			until n > nEnd
		end
	end
end