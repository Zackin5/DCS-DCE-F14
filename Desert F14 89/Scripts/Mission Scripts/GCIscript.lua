--To run during mission to detect targets by EWR and launch interceptors
--Script attached to mission and executed via trigger
--Requires GCIdata.lua to be attached and run in mission in order to get access to table GCI
------------------------------------------------------------------------------------------------------- 


--example of data structure for table GCI supplied by GCIdata.lua
--[[
GCI = {
	EWR = {
		["blue"] = {
			["EWR 1"] = true,
			["EWR 2"] = true,
		},
		["red"] = {},
	},
	Interceptor = {
		["blue"] = {
			ready = {},
			assigned = {},
		},
		["red"] = {
			ready = {
				["Flight 1"] = {
					number = 2,
					range = 150000,
					x = 123,
					y = 123,
					tot_from,
					tot_to,
					airdromeId,
				},
			},
			assigned = {},
		}
	}
}
]]--

local ErrorMsg = ""																				--variable to store script status in case of error

--target tracks
local target_tracks = {
	["blue"] = {},
	["red"] = {}
}

local function GCI_Cycle()
	local current_time = timer.getTime()
	
	--remove old targets from target_tracks
	ErrorMsg = "Remove old tracks."																--Error message in case follow on code fails
	for track_side, side in pairs(target_tracks) do												--iterate through sides in target tracks table
		for target_name, target in pairs(side) do												--iterate through targets
			ErrorMsg = "Remove old tracks: " .. target_name .. " no time stamp."				--Error message in case follow on code fails
			if target.time + 1200 < current_time then											--if target was not detected for more than 20 minutes
				target = nil																	--remove target from tracks table
			end
		end
	end
	
	--update assigned interceptors table
	ErrorMsg = "Update interceptor table."														--Error message in case follow on code fails
	for side_name, side in pairs(GCI.Interceptor) do											--iterate through sides in Interceptor table
		for flight_name, flight in pairs(side.assigned) do										--iterate through assigned interceptors
			ErrorMsg = "Update interceptor table: "	.. 	flight_name								--Error message in case follow on code fails
			local group = Group.getByName(flight_name)											--get group of flight
			if group then
				local units = group:getUnits()													--get alive units array of group
				local difference = #units - flight.number										--number of of interceptors that died since last cylce										
				target_tracks[side_name][flight.target].assigned = target_tracks[side_name][flight.target].assigned + difference	--remove dead interceptors from assigned number of target track
				flight.number = #units															--store new number of interceptors
			else																				--group doesnt exist
				target_tracks[side_name][flight.target].assigned = target_tracks[side_name][flight.target].assigned - flight.number	--remove dead interceptors from assigned number of target track
				flight = nil																	--remove flight from Interceptors table
			end
		end
	end
	
	--EWR target detection
	ErrorMsg = "EWR target detection."															--Error message in case follow on code fails
	for ewr_side, ewr_table in pairs(GCI.EWR) do												--iterate through sides in EWR table
		for ewr_name, bool in pairs(ewr_table) do												--iterate through EWR radars	
			ErrorMsg = "EWR target detection: "	.. ewr_name										--Error message in case follow on code fails
			local unit = Unit.getByName(ewr_name)												--get EWR unit
			if unit then																		--if unit exists
				local ctr = unit:getGroup():getController()										--get unit controller
				local targets = ctr:getDetectedTargets()										--get detected targets of this EWR
				for t = 1, #targets do															--iterate through detected targets
					if targets[t].object then
						local objCat = targets[t].object:getCategory()								--get object category
						if objCat == 1 then															--object is a unit
							local desc = targets[t].object:getDesc()								--get descriptor descriptor
							if desc.category == 0 or desc.category == 1 then						--descriptor category is airplane or helicopter
								local target_name = targets[t].object:getGroup():getName()			--get target group name
								local target_number = targets[t].object:getGroup():getUnits()		--get target group size
								local target_point = targets[t].object:getPoint()					--get target point
								ErrorMsg = "EWR target detection: " .. ewr_name	.. "; Target: " .. target_name 	--Error message in case follow on code fails
								
								if target_tracks[ewr_side][target_name] then						--existing track
									target_tracks[ewr_side][target_name].number = #target_number
									target_tracks[ewr_side][target_name].time = current_time
									target_tracks[ewr_side][target_name].point = target_point
								else																--new track
									target_tracks[ewr_side][target_name] = {
										number = #target_number,
										time = current_time,
										point = target_point,
										assigned = 0,
									}
								end
							end
						end
					end
				end
			end
		end
	end
	
	--assign interceptors to targets
	ErrorMsg = "Assign interceptors."															--Error message in case follow on code fails
	for track_side, side in pairs(target_tracks) do												--iterate throug sides in target_tracks table
		for target_name, target in pairs(side) do												--iterate through targets
			ErrorMsg = "Assign interceptors; Target: " .. target_name							--Error message in case follow on code fails
			if target.assigned < target.number then												--if target has less interceptors assigned than it has aircraft in group
				
				--find all flights in range to intercept target
				local eligible_flights = {}														--table of flights eligible for interception of this target
				for flight_name, flight in pairs(GCI.Interceptor[track_side].ready) do			--iterate through ready intercepor flights
					ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Interceptor: " .. flight_name						--Error message in case follow on code fails
					if timer.getTime() >= flight.tot_from and timer.getTime() <= flight.tot_to then										--flight can operate at current time
						local distance = math.sqrt(math.pow(target.point.x - flight.x, 2) + math.pow(target.point.z - flight.y, 2))		--distance between interceptor airbase and target
						if distance < flight.range then											--target is in interception range
							eligible_flights[flight_name] = distance							--store flight name and interception distance in table
						end
					end
				end
				
				--select the flight closest to target for interception
				local selected_flight															--currently selected flight for interception
				local selected_distance = 9999999												--interception distance of currently selected flight
				for flight_name, distance in pairs(eligible_flights) do							--iterate through eligible flights
					if distance < selected_distance then										--if distance of current flight is lower than of currently selected flight
						selected_flight = flight_name											--select this flight instead
						selected_distance = distance											--make this the new distance
					end
				end
				
				--assign selected flight to target
				ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Select Flight."					--Error message in case follow on code fails
				if selected_flight then
					trigger.action.setUserFlag(GCI.Interceptor[track_side].ready[selected_flight].flag, true)	--set flag true to launch interceptor
					--trigger.action.outText(selected_flight .. " launched to intercept " .. target_name, 15)	--FOR DEBUG
					
					--assign mission task to interceptor flight
					ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Selected Flight: " .. selected_flight				--Error message in case follow on code fails
					local function AssignMission()												--function to set interception mission (to be executed with 2 seconds delay, in order for the group to activate first)
						local ctr = Group.getByName(selected_flight):getController()			--get controller of interceptor group
						local target_id = Group.getByName(target_name):getID()					--get target group ID
						local Mission = {														--define mission for interceptor group
							id = 'Mission', 
							params = {
								route = { 
									["points"] = {
										[1] = {
											["alt"] = 4000,
											["type"] = "Turning Point",
											["action"] = "Turning Point",
											["alt_type"] = "BARO",
											["formation_template"] = "",
											["ETA"] = 0,
											["y"] = GCI.Interceptor[track_side].assigned[selected_flight].y,
											["x"] = GCI.Interceptor[track_side].assigned[selected_flight].x,
											["speed"] = 250,
											["ETA_locked"] = true,
											["task"] = {
												["id"] = "ComboTask",
												["params"] = {
													["tasks"] = {
														[1] = {
															["number"] = 1,
															["auto"] = false,
															["id"] = "EngageGroup",
															["enabled"] = true,
															["params"] = {
																["visible"] = false,
																["groupId"] = target_id,
																["priority"] = 1,
															},
														},
														[2] = {
															["number"] = 2,
															["auto"] = false,
															["id"] = "EngageTargets",
															["enabled"] = true,
															["params"] = {
																["maxDist"] = GCI.Interceptor[track_side].assigned[selected_flight].range,
																["priority"] = 2,
															},
														},
													},
												},
											},
											["speed_locked"] = true,
										},
										[2] = {
											["alt"] = 10000,
											["type"] = "Land",
											["action"] = "Landing",
											["airdromeId"] = GCI.Interceptor[track_side].assigned[selected_flight].airdromeId,
											["alt_type"] = "BARO",
											["formation_template"] = "",
											["ETA"] = 0,
											["y"] = GCI.Interceptor[track_side].assigned[selected_flight].y,
											["x"] = GCI.Interceptor[track_side].assigned[selected_flight].x,
											["speed"] = 250,
											["ETA_locked"] = true,
											["task"] = {
												["id"] = "ComboTask",
												["params"] = {
													["tasks"] = {
													},
												},
											},
											["speed_locked"] = true,
										},
									},
								}
							}
						}
						Controller.setTask(ctr, Mission)																			--activate task with mission for interceptor group
					end
					timer.scheduleFunction(AssignMission, nil, timer.getTime() + 2)													--set intercept mission with 2 seconds delay
					
					ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Selected Flight: " .. selected_flight .. "; Update GCI Table."				--Error message in case follow on code fails
					GCI.Interceptor[track_side].assigned[selected_flight] = GCI.Interceptor[track_side].ready[selected_flight]		--move flight from ready to assigned status
					GCI.Interceptor[track_side].ready[selected_flight] = nil														--move flight from ready to assigned status
					GCI.Interceptor[track_side].assigned[selected_flight].target = target_name										--store target name
					target.assigned = target.assigned + GCI.Interceptor[track_side].assigned[selected_flight].number				--mark target as assigned for interception
				end
			end
		end
	end
	
	ControlTime = timer.getTime()																--update ControlTime to tell ControlFunction() that cylce is still running
	return timer.getTime() + 15																	--repeat GCI cycle every 15 seconds
end
timer.scheduleFunction(GCI_Cycle, nil, timer.getTime() + 1)										--start GCI cylce


--Control function to report when GCI_Cylce() stopped working
local function ControlFunction()
	if ControlTime + 30 < timer.getTime() then													--if ControlTime was not updated since 30 seconds
		trigger.action.outText("GCI_Cycle() Error: " .. ErrorMsg, 60)							--print error
	else
		return timer.getTime() + 15	
	end
end
timer.scheduleFunction(ControlFunction, nil, timer.getTime() + 2)	