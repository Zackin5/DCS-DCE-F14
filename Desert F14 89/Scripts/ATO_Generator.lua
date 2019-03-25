--To create the Air Tasking Order
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 

--status report counters
local status_counter_sorties = 0
local status_counter_escorts = 0
local status_counter_ATO = 0


--to track what caused lack of playable sortie for the player
playability_criterium = {}
function TrackPlayability(player_unit, criterium)																				--function that tracks whether a playability criterium has been met
	if player_unit == true then																									--unit in question is playable by player
		playability_criterium[criterium] = true																					--set playability criterium to be met
	end
end

--table to hold availability of aircraft
aircraft_availability = {}

--table to store draft sorties (all valid unit/task/loadout/target combinations)
draft_sorties = {
	blue = {},
	red = {}
}

--creat draft sorties
for side,unit in pairs(oob_air) do																								--iterate through all sides
	
	--determine enemy side
	local enemy																													--determine enemy side (opposite of unit side)
	if side == "blue" then
		enemy = "red"
	else
		enemy = "blue"
	end

	for n = 1, #unit do																											--iterate through all units
		if unit[n].inactive ~= true then																						--if unit is active
			TrackPlayability(unit[n].player, "active_unit")																		--track playabilty criterium has been met
			
			if db_airbases[unit[n].base].inactive ~= true then																	--base is active
				TrackPlayability(unit[n].player, "base")																		--track playabilty criterium has been met
				
				if unit[n].roster.ready > 0 then																				--has ready aircraft
					TrackPlayability(unit[n].player, "ready_aircraft")															--track playabilty criterium has been met
					
					aircraft_availability[unit[n].name] = {}																	--make an aircraft availability entry for this unit
					
					--serviceable aircraft
					local aircraft_serviceable = 0																						--serviceable aircraft of unit
					for s = 1, unit[n].roster.ready do																					--iterate through ready aircraft
						if math.random(1, 100) <= 80 then																				--80% chance that it is mission ready
							aircraft_serviceable = aircraft_serviceable + 1																--sum serviceable aircraft
						end
					end
					aircraft_availability[unit[n].name].unassigned = aircraft_serviceable												--store serviceable aircraft in availability table
					aircraft_availability[unit[n].name].rando = {}																		--table to hold randomization number for availability of each individual aircraft
					for r = 1, aircraft_serviceable do
						aircraft_availability[unit[n].name].rando[r] = math.random(1,100)
					end
					
					for task,task_bool in pairs(unit[n].tasks) do																		--iterate through all tasks of unit		
						if task_bool and task ~= "SEAD" and task ~= "Escort" then														--task is true and is not SEAD or escort
							aircraft_availability[unit[n].name][task] = {}																--make a task entry in availability table		
							
							--get possible loadouts
							local unit_loadouts = {}																					--table to hold all loadouts for this aircraft type and task
							for loadout_name, ltable in pairs(db_loadouts[unit[n].type]) do												--iterate through all loadouts for the aircraft type
								if ltable.description.task == task then																	--if loadout task matches requested task
									ltable.name = loadout_name																			--store loadout name
									table.insert(unit_loadouts, ltable)																	--add loadout to local table
								end
							end
							
							for l = 1, #unit_loadouts do																				--iterate through all available loadouts				
								
								--get possible Time on Target
								local tot_from = 0																						--earliest Time on Target for this loadout
								local tot_to = 0																						--latest Time on target for this loadout
								if unit_loadouts[l].description.day and unit_loadouts[l].description.night then							--loadout is day and night capable
									tot_from = 0																						--from mission start
									tot_to = camp.mission_duration																		--to mission end
								elseif unit_loadouts[l].description.day then															--loadout is day capable
									if daytime == "night-day" then
										tot_from = camp.dawn - camp.time																--from dawn
										tot_to = camp.mission_duration																	--to mission end
									elseif daytime == "day" then
										tot_from = 0																					--from missiom start
										tot_to = camp.mission_duration																	--to mission end
									elseif daytime == "day-night" then
										tot_from = 0																					--from mission start
										tot_to = camp.dusk - camp.time																	--to dusk
									end
								elseif unit_loadouts[l].description.night then															--loadout is night capable
									if daytime == "day-night" then
										tot_from = camp.dusk - camp.time																--from dusk
										tot_to = camp.mission_duration																	--to mission end
									elseif daytime == "night" then
										tot_from = 0																					--from mission start
										tot_to = camp.mission_duration																	--to mission end
									elseif daytime == "night-day" then
										tot_from = 0																					--from mission start
										tot_to = camp.dawn - camp.time																	--to dawn
									end
								end
								
								if tot_from ~= 0 or tot_to ~= 0 then																	--loadout has an eligible time on target
									
									if tot_from == 0 then																				--player is only allowed to start at mission start
										TrackPlayability(unit[n].player, "tot")															--track playabilty criterium has been met
									end
									
									--available aircraft
									local operating_hours																				--time a unit is operating each day
									if unit_loadouts[l].description.day and unit_loadouts[l].description.night then						--day/night loadout
										operating_hours = 86400																			--full day in seconds
									elseif unit_loadouts[l].description.day then														--day loadout
										operating_hours = camp.dusk - camp.dawn															--daytime in seconds
									elseif unit_loadouts[l].description.night then														--night loadout
										operating_hours = camp.dawn + (86400 - camp.dusk)												--nighttime in seconds
									end
									
									local pS																							--probability that each individual aircraft is available for a sortie in the current mission
									if task == "CAP" or task == "AWACS" or task == "Refueling" then										--on station tasks
										local sortie_duration = operating_hours / unit_loadouts[l].description.sortie_rate				--average sortie duration inclding time on ground between sorties
										pS = (tot_to - tot_from + unit_loadouts[l].description.tStation) / sortie_duration				--propability that sortie falls in current mission
									else																								--other tasks
										pS = unit_loadouts[l].description.sortie_rate / operating_hours * (tot_to - tot_from)			--probability that a sortie falls in current mission
									end
									local aircraft_available = 0																		--number of aircraft available for the current mission
									for a = 1, aircraft_serviceable do																	--iterate through serviceable aircraft
										if aircraft_availability[unit[n].name].rando[a] / 100 <= pS then								--check if aicraft if available
											aircraft_available = aircraft_available + 1													--sum available aircraft
										end
									end
									aircraft_availability[unit[n].name][task][unit_loadouts[l].name] = {								--store available aircraft for this loadout
										available = aircraft_available,
										unassigned = aircraft_available,
										assigned = 0,
									}
									
									for target_side_name, target_side in pairs(targetlist) do											--iterate through sides in targetlist				
										if side == target_side_name then																--if the target is hostile
											for target_name, target in pairs(target_side) do											--iterate through all hostile targets
												if target.inactive ~= true and (target.alive == nil or (target.alive and target.alive > 0)) then		--if target is active and alive (alive false is excluded)
													if target.task == task then															--if target is valid for aircaft-loadout
													
														--check target/loadout attributes
														local loadout_eligible = true																					--boolean if loadout matches all target attributes (default true, because target might have no attributes)
														for target_attribute_number, target_attribute in pairs(target.attributes) do									--Iterate through target attributes
															local attribute_match = false																				--boolean if current target attribute is matched by loadout attribute 
															for loadout_attribute_number, loadout_attribute in pairs(unit_loadouts[l].description.attributes) do		--Iterate through loadout attributes
																if target_attribute == loadout_attribute then															--if match is found
																	attribute_match = true																				--set variable true
																	break																								--break the loadout attributes iteration
																end
															end
															if attribute_match == false then																			--if no attribute match was found after all loadout attributes were checked
																loadout_eligible = false																				--loadout is not eligible
																break																									--break further target attributes itteration
															end
														end
														
														if loadout_eligible then																						--continue if loadout is eligible
															
															if (task == "Intercept" and target.base == unit[n].base) or (task == "Transport" and target.base == unit[n].base) or (task == "Nothing" and target.base == unit[n].base) or (task ~= "Intercept" and task ~= "Transport" and task ~= "Nothing") then	--intercept and transport missions are only assigned to units of a certain base as per targetlist	
																TrackPlayability(unit[n].player, "target")																--track playabilty criterium has been met
																
																if target.firepower.min <= aircraft_available * unit_loadouts[l].description.firepower then				--enough aircraft are available to satisfy minimum firepower requirement of target	
																	TrackPlayability(unit[n].player, "target_firepower")												--track playabilty criterium has been met
																
																	--check weather
																	local weather_eligible = true
																	if mission.weather["clouds"]["density"] > 8 then														--overcast clouds
																		local cloud_base = mission.weather["clouds"]["base"]
																		local cloud_top = mission.weather["clouds"]["base"] + mission.weather["clouds"]["thickness"]
																		if db_airbases[unit[n].base].elevation + 333 > cloud_base then										--cloud base is less than 1000 ft above airbase elevation
																			if unit_loadouts[l].description.adverseWeather == false then									--loadout is not adverse weather capable
																				weather_eligible = false																	--not eligible for this weather
																			end
																		else
																			if unit_loadouts[l].description.hCruise and unit_loadouts[l].description.hCruise > cloud_base and unit_loadouts[l].description.hCruise < cloud_top then			--cruise alt is in the clouds
																				if unit_loadouts[l].description.adverseWeather == false then								--loadout is not adverse weather capable
																					weather_eligible = false																--not eligible for this weather
																				end
																			elseif unit_loadouts[l].description.hAttack and unit_loadouts[l].description.hAttack > cloud_base and unit_loadouts[l].description.hAttack < cloud_top then		--attack alt is in the clouds
																				if unit_loadouts[l].description.adverseWeather == false then								--loadout is not adverse weather capable
																					weather_eligible = false																--not eligible for this weather
																				end
																			end
																			
																			if task == "CAS" or task == "Ground Attack" or task == "Pinpoint Strike" or task == "Runway Attack" or task == "Anti-ship Strike" or task == "Reconnaissance" then	--extra requirement for A-G tasks
																				if unit_loadouts[l].description.hAttack > cloud_base then									--attack alt is above cloud base
																					if unit_loadouts[l].description.adverseWeather == false then							--loadout is not adverse weather capable
																						weather_eligible = false															--not eligible for this weather
																					end
																				end
																			end	
																		end
																	end
																	if mission.weather["enable_fog"] == true then															--fog
																		if db_airbases[unit[n].base].elevation < mission.weather["fog"]["thickness"] then					--base elevation in fog
																			if mission.weather["fog"]["visibility"] < 5000 then												--less than 5000m visibility
																				if unit_loadouts[l].description.adverseWeather == false then								--loadout is not adverse weather capable
																					weather_eligible = false																--not eligible for this weather
																				end
																			end
																		end
																	end
																	
																	if weather_eligible then																				--continue of this loadout is eligible for weather
																		TrackPlayability(unit[n].player, "weather")															--track playabilty criterium has been met
																		
																		--get airbase position
																		local airbasePoint = {																				--get the x-y coordinates of the airbase where the unit is located
																			x = db_airbases[unit[n].base].x,
																			y = db_airbases[unit[n].base].y,
																			h = db_airbases[unit[n].base].elevation
																		}
																		
																		--determine route variants depending on daytime
																		local variant
																		if daytime == "day" then
																			variant = 1
																		elseif daytime == "night" then
																			variant = 2
																		elseif daytime == "night-day" then
																			variant = 3
																		elseif daytime == "day-night" then
																			variant = 4
																		end
																		
																		while variant > 0 do
																		
																			--determine route
																			status_counter_sorties = status_counter_sorties + 1													--status report
																			--print("ATO Generating Sortie (" .. status_counter_sorties .. ") - Calculating Route")	--DEBUG
																			local route
																			if task == "Intercept" then																			--intercept task only get a stub route
																				route = {
																					[1] = {
																						['y'] = airbasePoint.y,
																						['x'] = airbasePoint.x,
																						['alt'] = 0,
																						['id'] = 'Intercept',
																					},
																					threats = {
																						SEAD_offset = 0,
																						ground_total = 0.5,
																						air_total = 0.5
																					},
																					['lenght'] = target.radius * 2,																--interception task radius *2 because below it is compared with range *2
																				}
																			else																								--all other tasks than intercept
																				if variant == 1 or variant == 4 then
																					route = GetRoute(airbasePoint, target, unit_loadouts[l].description, enemy, task, "day")	--get the best route to this target at day
																				elseif variant == 2 or variant == 3 then
																					route = GetRoute(airbasePoint, target, unit_loadouts[l].description, enemy, task, "night")	--get the best route to this target at night
																				end
																			end

																			if route.lenght <= unit_loadouts[l].description.range * 2 then										--if sortie route lenght is within range of aircraft-loadout
																				TrackPlayability(unit[n].player, "target_range")												--track playabilty criterium has been met
																				
																				--determine number of aircraft needed for sortie
																				local aircraft_requested = target.firepower.max / unit_loadouts[l].description.firepower		--how many aircraft are needed to satisfy the maximum firepower requirement of the target
																				local flights_requested = nil																	--only needed for on-station tasks
																				if task == "CAP" or task == "AWACS" or task == "Refueling" then									--multiple flights are required to continously cover a station for the duration of the mission
																					flights_requested = math.ceil((tot_to - tot_from) / unit_loadouts[l].description.tStation) + 1	--how many flights are needed to keep continous coverage of station, plus 1 for on station before mission start
																					aircraft_requested = aircraft_requested * flights_requested									--total number of requested aircraft is number of aircraft needed to statisfy firepower requirement of station * number of flights needed for continous coverage
																				end
																				if task == "AWACS" or task == "Refueling" or task == "Transport" or task == "Nothing" or task == "Reconnaissance" then
																					aircraft_requested = math.ceil(aircraft_requested)											--round up
																				elseif unit[n].type == "F-117A" or unit[n].type == "B-1B" or unit[n].type == "B-52H" or unit[n].type == "Tu-22M3" or unit[n].type == "Tu-95MS" or unit[n].type == "Tu-142" or unit[n].type == "Tu-160" then
																					aircraft_requested = math.ceil(aircraft_requested)											--round up
																				else
																					aircraft_requested = math.ceil(aircraft_requested / 2) * 2									--round up to an even number
																				end
																				local aircraft_assign
																				if aircraft_requested > aircraft_available then													--if more aircraft are requested than are available from this unit
																					aircraft_assign = aircraft_available														--assign all available aircraft
																				else																							--enough available aircraft to satisfy requested aircraft
																					aircraft_assign = aircraft_requested														--assign all requested aicraft
																				end
																				
																				--self escort
																				if unit_loadouts[l].description.self_escort then												--if the loadout is capable of self-escort
																					route.threats.air_total = route.threats.air_total / 2										--reduce the fighter threat by half
																					if route.threats.air_total < 0.5 then
																						route.threats.air_total = 0.5
																					end
																				end
																				
																				--build sortie entry
																				local draft_sorties_entry = {
																					name = unit[n].name,
																					playable = unit[n].player,
																					type = unit[n].type,
																					number = aircraft_assign,
																					flights = flights_requested,
																					country = unit[n].country,
																					livery = unit[n].livery,
																					base = unit[n].base,
																					airdromeId = db_airbases[unit[n].base].airdromeId,
																					skill = unit[n].skill,
																					task = task,
																					loadout = unit_loadouts[l],
																					target = deepcopy(target),
																					target_name = target_name,
																					route = route,
																					tot_from = tot_from,
																					tot_to = tot_to,
																					properties = unit[n].properties,
																					radioCount = unit[n].radioCount,
																				}
																				
																				--score the sortie
																				local route_threat = route.threats.ground_total + route.threats.air_total									--combine route ground and air threat
																				if task == "CAP" or task == "Intercept" then
																					draft_sorties_entry.score = unit_loadouts[l].description.capability * target.priority					--route threat does not matter for CAP and intercept
																				else
																					draft_sorties_entry.score = unit_loadouts[l].description.capability * target.priority / route_threat	--calculate the score to measure the importance of the sortie
																				end
																				
																				--insert sortie entry into draft_sorties table sorted by score (highest first)
																				if #draft_sorties[side] == 0 then															--if draft_sorties table is empty
																					table.insert(draft_sorties[side], draft_sorties_entry)
																				else
																					for d = 1, #draft_sorties[side] do														--iterate through draft_sorties
																						if draft_sorties_entry.score > draft_sorties[side][d].score then					--score is bigger than current table entry
																							table.insert(draft_sorties[side], d, draft_sorties_entry)						--insert at current position in table
																							break
																						elseif draft_sorties_entry.score == draft_sorties[side][d].score then				--score is same as current table entry
																							local sum = 1
																							for s = d + 1, #draft_sorties[side] do											--iterate through subsequent table entries
																								if draft_sorties_entry.score == draft_sorties[side][s].score then			--if these entries also have the same score
																									sum = sum + 1															--sum them
																								else
																									break
																								end
																							end
																							table.insert(draft_sorties[side], d + math.random(0, sum), draft_sorties_entry)	--insert random position position in table
																							break
																						elseif d == #draft_sorties[side] then												--if end of table is reached
																							table.insert(draft_sorties[side], draft_sorties_entry)							--insert at end of table
																						end
																					end
																				end
																				
																				--print("ATO Generating Sortie (" .. status_counter_sorties .. ") - Complete")	--DEBUG
																			end
																		
																			variant = variant - 2																			--determines if while-loop does another route variant depending on daytime
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end


--create additional draft sorties with escorts assigned
for side,unit in pairs(oob_air) do																		--iterate through all sides
	
	--determine enemy side
	local enemy																							--determine enemy side (opposite of unit side)
	if side == "blue" then
		enemy = "red"
	else
		enemy = "blue"
	end
	
	for n = 1, #unit do																					--iterate through all units
		local temp_draft_sorties = {}																	--temporary table to hold additional draft sorties with escorts assigned
		if unit[n].inactive ~= true and db_airbases[unit[n].base].inactive ~= true and unit[n].roster.ready > 0 then	--if unit is active, its base is active and has ready aircraft
			
			for loop = 1, 2 do																			--loop twice, one for each escort variant (SEAD and fighter escort)
				for task,task_bool in pairs(unit[n].tasks) do											--iterate through all tasks of unit
					if ((task == "SEAD" and loop == 1) or (task == "Escort" and loop == 2)) and task_bool then --task is SAED in first loop, or task is escort in second loop; and task is true
						
						aircraft_availability[unit[n].name][task] = {}									--make a task entry in availability table
						
						--get possible loadouts
						local unit_loadouts = {}														--table to hold all loadouts for this aircraft type and task
						for loadout_name, ltable in pairs(db_loadouts[unit[n].type]) do					--iterate through all loadouts for the aircraft type
							if ltable.description.task == task then										--if loadout task matches requested task
								ltable.name = loadout_name
								table.insert(unit_loadouts, ltable)										--add loadout to local table
							end
						end
						
						for l = 1, #unit_loadouts do													--iterate through all available loadouts				
							
							--get possible Time on Target
							local tot_from = 0															--earliest Time on Target for this loadout
							local tot_to = 0															--latest Time on target for this loadout
							if unit_loadouts[l].description.day and unit_loadouts[l].description.night then		--loadout is day and night capable
								tot_from = 0															--from mission start
								tot_to = camp.mission_duration											--to mission end
							elseif unit_loadouts[l].description.day then								--loadout is day capable
								if daytime == "night-day" then
									tot_from = camp.dawn - camp.time									--from dawn
									tot_to = camp.mission_duration										--to mission end
								elseif daytime == "day" then
									tot_from = 0														--from missiom start
									tot_to = camp.mission_duration										--to mission end
								elseif daytime == "day-night" then
									tot_from = 0														--from mission start
									tot_to = camp.dusk - camp.time										--to dusk
								end
							elseif unit_loadouts[l].description.night then								--loadout is night capable
								if daytime == "day-night" then
									tot_from = camp.dusk - camp.time									--from dusk
									tot_to = camp.mission_duration										--to mission end
								elseif daytime == "night" then
									tot_from = 0														--from mission start
									tot_to = camp.mission_duration										--to mission end
								elseif daytime == "night-day" then
									tot_from = 0														--from mission start
									tot_to = camp.dawn - camp.time										--to dawn
								end
							end
							
							if tot_from ~= 0 or tot_to ~= 0 then										--loadout has an eligible time on target
								
								--available aircraft
								local operating_hours																				--time a unit is operating each day
								if unit_loadouts[l].description.day and unit_loadouts[l].description.night then						--day/night loadout
									operating_hours = 86400																			--full day in seconds
								elseif unit_loadouts[l].description.day then														--day loadout
									operating_hours = camp.dusk - camp.dawn															--daytime in seconds
								elseif unit_loadouts[l].description.night then														--night loadout
									operating_hours = camp.dawn + (86400 - camp.dusk)												--nighttime in seconds
								end
								
								local pS																							--probability that each individual aircraft is available for a sortie in the current mission
								if task == "CAP" or task == "AWACS" or task == "Refueling" then										--on station tasks
									local sortie_duration = operating_hours / unit_loadouts[l].description.sortie_rate				--average sortie duration inclding time on ground between sorties
									pS = (tot_to - tot_from + unit_loadouts[l].description.tStation) / sortie_duration				--propability that sortie falls in current mission
								else																								--other tasks
									pS = unit_loadouts[l].description.sortie_rate / operating_hours * (tot_to - tot_from)			--probability that a sortie falls in current mission
								end
								local aircraft_available = 0																		--number of aircraft available for the current mission
								for a = 1, #aircraft_availability[unit[n].name].rando do											--iterate through all serviceable aircraft
									if aircraft_availability[unit[n].name].rando[a] / 100 <= pS then								--check if aicraft if available
										aircraft_available = aircraft_available + 1													--sum available aircraft
									end
								end
								aircraft_availability[unit[n].name][task][unit_loadouts[l].name] = {								--store available aircraft for this loadout
									available = aircraft_available,
									unassigned = aircraft_available,
									assigned = 0,
								}
								
								for draft_n, draft in pairs(draft_sorties[side]) do													--iterate through all draft sorties beginning with the highest scored
								
									if draft.task ~= "CAP" and draft.task ~= "AWACS" and draft.task ~= "Refueling" and draft.task ~= "Fighter Sweep" and draft.task ~= "Intercept" and draft.task ~= "Transport" and draft.task ~= "Nothing" then	--certain tasks should not receive direct support
									
										if (task == "SEAD" and draft.route.threats.SEAD_offset > 0) or (task == "Escort" and draft.route.threats.air_total > 0.5) then		--sortie has an escort requirement	
											
											if (unit_loadouts[l].description.day and draft.loadout.description.day) or (unit_loadouts[l].description.night and draft.loadout.description.night) then	--escort can support package at either day or night
												TrackPlayability(unit[n].player, "tot")														--track playabilty criterium has been met
											
												if unit_loadouts[l].description.vCruise >= draft.loadout.description.vCruise then				--escort has a cruise speed equal or higher than main body
													TrackPlayability(unit[n].player, "target")													--track playabilty criterium has been met
													
													--check weather
													local weather_eligible = true
													if mission.weather["clouds"]["density"] > 8 then											--overcast clouds
														local cloud_base = mission.weather["clouds"]["base"]
														local cloud_top = mission.weather["clouds"]["base"] + mission.weather["clouds"]["thickness"]
														if db_airbases[unit[n].base].elevation + 333 > cloud_base then							--cloud base is less than 1000 ft above airbase elevation
															if unit_loadouts[l].description.adverseWeather == false then						--loadout is not adverse weather capable
																weather_eligible = false														--not eligible for this weather
															end
														else
															if draft.loadout.description.hCruise > cloud_base and draft.loadout.description.hCruise < cloud_top then		--cruise alt is in the clouds
																if unit_loadouts[l].description.adverseWeather == false then					--loadout is not adverse weather capable
																	weather_eligible = false													--not eligible for this weather
																end
															elseif draft.loadout.description.hAttack > cloud_base and draft.loadout.description.hAttack < cloud_top then	--attack alt is in the clouds
																if unit_loadouts[l].description.adverseWeather == false then					--loadout is not adverse weather capable
																	weather_eligible = false													--not eligible for this weather
																end
															end
														end
													end
													if mission.weather["enable_fog"] == true then												--fog
														if db_airbases[unit[n].base].elevation < mission.weather["fog"]["thickness"] then		--base elevation in fog
															if mission.weather["fog"]["visibility"] < 5000 then									--less than 5000m visibility
																if unit_loadouts[l].description.adverseWeather == false then					--loadout is not adverse weather capable
																	weather_eligible = false													--not eligible for this weather
																end
															end
														end
													end
													
													if weather_eligible then																	--continue of this loadout is eligible for weather
														TrackPlayability(unit[n].player, "weather")												--track playabilty criterium has been met
														
														--get airbase position
														local airbasePoint = {																	--get the x-y coordinates of the airbase where the unit is located
															x = db_airbases[unit[n].base].x,
															y = db_airbases[unit[n].base].y
														}
														
														local route = GetEscortRoute(airbasePoint, draft.route)									--get the route to escort this sortie
														if route.lenght <= unit_loadouts[l].description.range * 2 then							--escort route lenght is within range capability of loadout
															TrackPlayability(unit[n].player, "target_range")									--track playabilty criterium has been met
															
															--determine number of escorts
															local escort_num = 0
															if task == "SEAD" then
																escort_num = math.ceil(draft.route.threats.SEAD_offset / 2) * 2					--round up requested escorts to even number
															elseif task == "Escort" then
																local escort_offset_level = unit_loadouts[l].description.capability * unit_loadouts[l].description.firepower / 100	--threat level that each fighter escort can offset
																escort_num = (route.threats.air_total - 0.5) / escort_offset_level				--number of escorts needed to offset total air threat (-0.5 because that is no air threat)
																if escort_num > draft.number * 3 then											--when more escorts 3 times escorts than escorted aircraft
																	escort_num = draft.number * 3												--limit escort number to 3 times escorted aircraft
																end
																escort_num = math.ceil(escort_num / 2) * 2										--round up requested escorts to even number
															end
															if escort_num > aircraft_available then												--if more escorts are requested than available
																escort_num = aircraft_available													--reduce requested escorts to number of available escorts
															end
															
															while escort_num > 0 do																--repeat to make multiple new sorties with various even number of escorts (from all requested down to 2)
																TrackPlayability(unit[n].player, "target_firepower")							--track playabilty criterium has been met
																
																--make a local copy of the sortie entry
																local draft_sorties_entry = deepcopy(draft)
																
																--add escort table to sortie
																draft_sorties_entry[task] = {
																	name = unit[n].name,
																	playable = unit[n].player,
																	type = unit[n].type,
																	number = escort_num,
																	country = unit[n].country,
																	livery = unit[n].livery,
																	base = unit[n].base,
																	airdromeId = db_airbases[unit[n].base].airdromeId,
																	skill = unit[n].skill,
																	task = task,
																	loadout = unit_loadouts[l],
																	route = route,
																	target = deepcopy(draft.target),
																	target_name = draft.target_name,
																	tot_from = draft.tot_from,
																	tot_to = draft.tot_to,
																	properties = unit[n].properties,
																	radioCount = unit[n].radioCount,
																}
																
																--recalculate threat level for sortie adjusted by number of escort
																local route_threat_recalc = 0.5														--recalculated route threat with escort in place (0.5 == no threat)
																if task == "SEAD" then
																	local escort_pool = escort_num													--number escort aircraft available to offset threats
																	for k,v in pairs(draft.route.threats.ground) do									--iterate through route ground threats
																		if v.offset > 0 then														--if threat can be offset by SEAD
																			if escort_pool >= v.offset then											--some SEAD aircraft remain to offset the threat
																				escort_pool = escort_pool - v.offset								--use these SEAD aircraft to offset and ignore the therat
																			else																	--no SEAD aircraft remain unassignedd
																				route_threat_recalc = route_threat_recalc + v.level					--sum route ground threat levels
																			end
																		else																		--threat cannot be offset by SEAD
																			route_threat_recalc = route_threat_recalc + v.level						--sum route ground threat levels
																		end
																	end
																	draft_sorties_entry.route.threats.ground_total = route_threat_recalc			--recalculated total route grund threat
																elseif task == "Escort" then
																	local escort_offset_level = unit_loadouts[l].description.capability * unit_loadouts[l].description.firepower / 100		--threat level that each fighter escort can offset
																	route_threat_recalc = route.threats.air_total - escort_offset_level * escort_num										--recalculated total route air threat
																	if route_threat_recalc < 0.5 then
																		route_threat_recalc = 0.5
																	end
																	draft_sorties_entry.route.threats.air_total = route_threat_recalc
																end
																
																local route_threat = draft_sorties_entry.route.threats.ground_total + draft_sorties_entry.route.threats.air_total		--combine adjusted ground and air threat levels (1 equald no threat)
																draft_sorties_entry.score = draft.loadout.description.capability * draft.target.priority / route_threat		--calculate the score to measure the importance of the sortie
																
																--adjust sortie Time on Target
																if tot_from > draft.tot_from then									--if earliest escort Time on Target is later than main body TOT
																	draft_sorties_entry.tot_from = tot_from							--make earliest escort TOT the draft sortie earliest TOT 
																end
																if tot_to < draft.tot_to then										--if latest escort Time on Target is sooner than main body TOT
																	draft_sorties_entry.tot_to = tot_to								--make latest escort TOT the draft sortie latest TOT
																end
																
																table.insert(temp_draft_sorties, draft_sorties_entry)				--insert into temp table. Temp content to be entered into the draft_sorties table according to score later
																
																escort_num = escort_num - 2											--reduce number of escorts and repeat loop until number of escorts reaches 0
																
																--status report
																status_counter_escorts = status_counter_escorts + 1
																--print("ATO Assigning Escorts (" .. status_counter_escorts .. ")")	--DEBUG
															end
														end
													end
												end
											end
										end
									end
								end	
							end
						end
					end
				end
			end
		end
		--insert additional escorted sorties into draft_sorties table sorted by score (highest first)
		for t = 1, #temp_draft_sorties do
			for d = 1, #draft_sorties[side] do													--iterate through draft_sorties
				if temp_draft_sorties[t].score > draft_sorties[side][d].score then
					table.insert(draft_sorties[side], d, temp_draft_sorties[t])					--insert at current position in table
					break
				elseif temp_draft_sorties[t].score == draft_sorties[side][d].score then			--draft_sortie entry score is the same
					local sum = 1																--sum how many draft_sortie entries also have the same score
					for s = d + 1, #draft_sorties[side] do										--iterate through subsequent table entries
						if temp_draft_sorties[t].score == draft_sorties[side][s].score then		--if these entries also have the same score
							sum = sum + 1														--sum them
						else
							break
						end
					end
					table.insert(draft_sorties[side], d + math.random(0, sum), temp_draft_sorties[t])	--insert random position position in table
					break
				elseif d == #draft_sorties[side] then											--if end of table is reached
					table.insert(draft_sorties[side], temp_draft_sorties[t])					--insert at end of table
				end
			end
		end
	end
end


--table to store the final ATO
ATO = {
	blue = {},
	red = {}
}


--assign draft sorties to ATO and build packages/flights
for side, draft in pairs(draft_sorties) do																		--iterate through all sides
	for n = 1, #draft do																						--iterate through all draft sorties beginning with the highest scored
		if draft[n].target.firepower.max > 0 and draft[n].target.firepower.max >= draft[n].target.firepower.min then	--the target of this draft sortie must have a need for firepower above the minimum firepower threshold
			
			local available = aircraft_availability[draft[n].name][draft[n].task][draft[n].loadout.name].unassigned		--shortcut for available aircraft for this draft sortie
	
			if available * draft[n].loadout.description.firepower >= draft[n].target.firepower.min then					--enough aircraft are available to satisfy minimum firepower requirement for target
				
				--adjust the number of requested aircraft to the number of available aircraft
				if draft[n].number > available then
					draft[n].number = available
				end
				
				--check if there are enough escorts available if escorts are required		
				local escorts_available = false
				if draft[n].SEAD and draft[n].Escort then														--draft sortie requires SEAD and fighter escorts
					local SEAD_available = aircraft_availability[draft[n].SEAD.name][draft[n].SEAD.task][draft[n].SEAD.loadout.name].unassigned				--available SEAD aircraft for this draft sortie
					local escort_available = aircraft_availability[draft[n].Escort.name][draft[n].Escort.task][draft[n].Escort.loadout.name].unassigned		--available escort aircraft for this draft sortie
					if draft[n].SEAD.name == draft[n].Escort.name and draft[n].SEAD.name == draft[n].name then								--SEAD, fighter escort and main body from same unit
						if draft[n].SEAD.number + draft[n].Escort.number <= available - draft[n].number then								--enough aircraft available for main body, SEAD and fighter escort from same unit
							escorts_available = true
						end
					elseif draft[n].SEAD.name == draft[n].Escort.name and draft[n].SEAD.name ~= draft[n].name then							--SEAD and fighter escort from the same unit, different than main body
						if draft[n].SEAD.number + draft[n].Escort.number <= SEAD_available then												--enough aircraft for SEAD and fighter escort from same unit
							escorts_available = true
						end	
					elseif draft[n].SEAD.name == draft[n].name then																			--SEAD and main body from the same unit, different than fighter escort
						if draft[n].SEAD.number <= available - draft[n].number then															--enough aircraft available for main body and SEAD from same unit
							escorts_available = true
						end
					elseif draft[n].Escort.name == draft[n].name then																		--fighter escort and main body from the same unit, different than SEAD
						if draft[n].Escort.number <= available - draft[n].number then														--enough aircraft available for main body and fighter escort from same unit
							escorts_available = true
						end	
					else																													--SEAD, fighter escorts and main body are from different units
						if draft[n].SEAD.number <= SEAD_available and draft[n].Escort.number <= escort_available then						--enough aircraft for SEAD and fighter escort available
							escorts_available = true
						end
					end	
				elseif draft[n].SEAD then																		--draft sortie requires SEAD escort only
					local SEAD_available = aircraft_availability[draft[n].SEAD.name][draft[n].SEAD.task][draft[n].SEAD.loadout.name].unassigned		--available SEAD aircraft for this draft sortie
					if draft[n].SEAD.name == draft[n].name then																				--SEAD escort and main body are from the same unit
						if draft[n].SEAD.number <= available - draft[n].number then															--enough aircraft available for both main body and SEAD
							escorts_available = true
						end
					else																													--SEAD escort and main body not from the same unir
						if draft[n].SEAD.number <= SEAD_available then																		--sufficient SEAD escort available
							escorts_available = true
						end
					end
				elseif draft[n].Escort then																		--draft sortie requires fighter escort only
					local escort_available = aircraft_availability[draft[n].Escort.name][draft[n].Escort.task][draft[n].Escort.loadout.name].unassigned		--available escort aircraft for this draft sortie
					if draft[n].Escort.name == draft[n].name then																			--escort and main body are from the same unit
						if draft[n].Escort.number <= available - draft[n].number then														--enough aircraft available for both main body and escort
							escorts_available = true
						end
					else																													--escort and main body not from the same unir
						if draft[n].Escort.number <= escort_available then																	--sufficient escort available
							escorts_available = true
						end
					end
				else																							--no SEAD or fighter escorts required
					escorts_available = true
				end
				
				if escorts_available then																		--continue if no escorts are required or enough escorts are available to create package
					
					--add new package to ATO
					local pack_n = #ATO[side]
					ATO[side][pack_n + 1] = {
						main = {},																				--package main body
						escort = {},																			--Fighter escort
						SEAD = {},																				--SEAD escort
					}
					pack_n = pack_n + 1
					
					--add flights of 1, 2 or 4 aircraft to package
					local function AddFlight(assign, role, entry)
						while assign > 0 do																		--loop as long as there are aircraft to assign
							local assigned
							if entry.task == "AWACS" or entry.task == "Refueling" or entry.task == "Transport" then		--for AWACS, tanker and transport
								assigned = 1																	--assigne one aircraft per flight
							elseif entry.task == "CAP" then														--for CAP
								if assign == 1 then																--if there is one aircraft left to assign, stop assigning
									break
								elseif entry.flights * 2 >= assign then											--if aircraft to be assigned are enough to make remaining flights of 2 max
									assigned = 2																--assign flight of 2 aircaft
								else
									assigned = 4																--else assign flight of 4 aicraft
								end
								entry.flights = entry.flights - 1
							elseif entry.task == "Intercept" then
								if assign >= 2 then																--if more than 2 aircraft are to be assigned
									assigned = 2																--assign flight of 2 aircaft
								else
									assigned = 1																--else assign flight of 1 aicraft
								end
							elseif entry.type == "F-117A" or entry.type == "B-1B" or entry.type == "B-52H" or entry.type == "Tu-22M3" or entry.type == "Tu-95MS" or entry.type == "Tu-142" or entry.type == "Tu-160" then	--for bombers
								assigned = 1																	--assigne one aircraft per flight
							elseif entry.task == "Reconnaissance" then											--for recon
								if assign >= 2 then																--if more than 2 aircraft are to be assigned
									assigned = 2																--assign flight of 2 aircaft
								else
									assigned = 1																--else assign flight of 1 aicraft
								end
							else																				--for everything else
								if assign == 1 then																--if there is one aircraft left to assign, stop assigning
									break
								elseif assign >= 4 then															--if more than 4 aircraft are to be assigned
									assigned = 4																--assign flight of 4 aircaft
								else
									assigned = 2																--else assign flight of 2 aicraft
								end
							end

							local flight = {																	--build ATO flight entry
								name = entry.name,
								playable = entry.playable,
								type = entry.type,
								number = assigned,																--number of aircraft in flight
								country = entry.country,
								livery = entry.livery,
								base = entry.base,
								airdromeId = entry.airdromeId,
								skill = entry.skill,
								task = entry.task,
								loadout = entry.loadout,
								route = {},																		--route is a table and connot be copied as a whole
								target = deepcopy(entry.target),
								target_name = entry.target_name,
								firepower = assigned * entry.loadout.description.firepower,
								tot_from = entry.tot_from,
								tot_to = entry.tot_to,
								properties = entry.properties,
								radioCount = entry.radioCount,
							}
							for r = 1, #entry.route do															--make copy of route table
								flight.route[r] = {}
								for k,v in pairs(entry.route[r]) do
									flight.route[r][k] = v
								end
							end
							table.insert(ATO[side][pack_n][role], flight)										--add flight to package role (main, SEAD or escort)
							
							assign = assign - assigned															--continue loop until are aircraft are assigned
						end
					end
					
					AddFlight(draft[n].number, "main", draft[n])												--add main body flights to package
					if draft[n].SEAD then
						AddFlight(draft[n].SEAD.number, "SEAD", draft[n].SEAD)									--add SEAD escort flights to package
					end
					if draft[n].Escort then
						AddFlight(draft[n].Escort.number, "escort", draft[n].Escort)							--add fighter escort flights to package
					end
					
					--remove aircraft assigned to this package from available aicraft
					for role,flight in pairs(ATO[side][pack_n]) do																				--iterate through all roles in package (main, SEAD, escort)
						for f = 1, #flight do																									--iterate through all flights in roles
							aircraft_availability[flight[f].name].unassigned = aircraft_availability[flight[f].name].unassigned - flight[f].number		--remove assigned aircraft from total number of available aircraft for this unit
							aircraft_availability[flight[f].name][flight[f].task][flight[f].loadout.name].assigned = aircraft_availability[flight[f].name][flight[f].task][flight[f].loadout.name].assigned + flight[f].number	--sum assigned aircraft number for this loadout
							if flight[f].task == "CAS" or flight[f].task == "Ground Attack" or flight[f].task == "Pinpoint Strike" or flight[f].task == "Runway Attack" or flight[f].task == "Anti-ship Strike" then	--for A-G tasks, remove assigned aircraft from available aircaft in loadouts of all other A-G tasks
								for task,v in pairs(aircraft_availability[flight[f].name]) do																															--iterate through tasks in aircraft availability table
									if task == "CAS" or task == "Ground Attack" or task == "Pinpoint Strike" or task == "Runway Attack" or task == "Anti-ship Strike" then												--if task is an A-G task
										for loadout_name,loadout in pairs(aircraft_availability[flight[f].name][task]) do																								--iterate through all loadouts of same task in availability table
											loadout.unassigned = loadout.unassigned - flight[f].number																													--remove assigned aircraft from loadout in availabilty table
										end
									end
								end
							else																												--for all remeaining tasks, remove assigned aircraft frim available aircraft in loadouts of same task only
								for loadout_name,loadout in pairs(aircraft_availability[flight[f].name][flight[f].task]) do						--iterate through all loadouts of same task in availability table
									loadout.unassigned = loadout.unassigned - flight[f].number													--remove assigned aircraft from loadout in availabilty table
								end
							end
							
							--adjust all unassigned aircraft in loadouts based on total number of available aicraft for squadron
							for taskname,task in pairs(aircraft_availability[flight[f].name]) do												--iterate through all tasks in aircraft availability table
								if type(task) == "table" then																					--to make sure that this is a task, there are also some other values that are not tables (total)
									for loadout_name,loadout in pairs(task) do																	--iterate through all loadouts in availability table
										if type(loadout) == "table" then																		--to make sure that this is a loadout, there are also some other values that are not tables (rando)
											if aircraft_availability[flight[f].name].unassigned < loadout.unassigned then						--check if total available aircraft for squadron is less than unassigned value in loadout
												loadout.unassigned = aircraft_availability[flight[f].name].unassigned							--adjust unassigned in loadout to match remaining aircraft for squadron
											end
										end
									end
								end
							end
						end
					end
					
					--remove the firepower applied by package to target from maximum firepower of all other draft sorties to the same target
					local firepower_applied = 0																	--collect the amount of firepower combined by all main body flights of this package
					for f = 1, #ATO[side][pack_n].main do														--iterate through all main body flights
						firepower_applied = firepower_applied + ATO[side][pack_n].main[f].firepower				--sum firepower
					end
					for m = 1, #draft do																		--iterate through all draft sorties again
						if draft[n].target_name == draft[m].target_name then									--if draft sortie with same target as present package is found
							draft[m].target.firepower.max = draft[m].target.firepower.max - firepower_applied	--remove the firepower applied by current package from maximum firepower for this sortie
						end
					end
					
					--status report
					status_counter_ATO = status_counter_ATO + 1
					--print("ATO Generation (" .. status_counter_ATO .. ")")	--DEBUG
				end
			end
		end
	end
end