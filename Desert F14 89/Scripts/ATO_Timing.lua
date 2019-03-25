--To define Time on target for all packages and ETA for all aircraft waypoints
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 

for side, pack in pairs(ATO) do																					--iterate through sides in ATO
	for p = 1, #pack do																							--iterate through packages in sides
		local player_start_shift = 0																			--waypoint time shift to start player at mission start
	
		local tot 																								--set time on target in seconds after mission start
		
		if pack[p].main[1].tot then																				--package already has a tot (target package for player intercept)
			tot = pack[p].main[1].tot																			--set package tot
		else
			tot = math.random(pack[p].main[1].tot_from + 600, pack[p].main[1].tot_to)							--set random tot
		end
		
		local vCruise = pack[p].main[1].loadout.description.vCruise												--set package cruise speed
		local vAttack = pack[p].main[1].loadout.description.vAttack												--set package attack speed
		
		local target_wp = 1																						--local variable to store the target waypoint number
		local partial_station = 0																				--local variable to hold time that an orbiting flight is already on station at mission start

		for role,flight in pairs(pack[p]) do																	--iterate through roles in package (main, SEAD, escort)
			
			--flight route offset within package (lateral and ETA)
			for f = 1, #flight do																				--iterate through flights in roles	
				flight[f].eta_offset = 0																		--ETA delay in seconds for longitudinal flight separation
				if flight[f].task ~= "CAP" and flight[f].task ~= "AWACS" and flight[f].task ~= "Refueling" and flight[f].task ~= "Intercept" and flight[f].task ~= "Transport" then	--not any of these tasks, as these do not operate with simultaneous flights on the same route
					
					local tSeparation = 8																		--basic separation between flights in seconds at cruise speed
					local separation = tSeparation * vCruise													--basic separation between flights in meters
					local offset																				--lateral offset of flight route in meters from route of lead flight
					
					if role == "main" then
						if math.floor((f - 1) / 3) == (f - 1) / 3 then											--flight 1, 4, 7...
							offset = 0
							flight[f].eta_offset = tSeparation * ((f - 1) / 3 * 2)								--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 2) / 3) == (f - 2) / 3 then										--flight 2, 5, 8...
							offset = separation																	--to the right side of lead flight
							flight[f].eta_offset = tSeparation * ((f - 2) / 3 * 2 + 1)							--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 3) / 3) == (f - 3) / 3 then										--flight 3, 6, 9...
							offset = separation * -1															--to the left side of lead flight
							flight[f].eta_offset = tSeparation * ((f - 3) / 3 * 2 + 1)							--ETA delay in seconds for longitudinal flight separation
						end
					elseif role == "SEAD" then
						offset = separation / 2																	--all SEAD routes are offset slightly to the right
						if math.floor((f - 1) / 3) == (f - 1) / 3 then											--flight 1, 4, 7...
							flight[f].eta_offset = -60 + tSeparation * ((f - 1) / 3)							--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 2) / 3) == (f - 2) / 3 then										--flight 2, 5, 8...
							offset = offset - separation														--to the left side of lead flight
							flight[f].eta_offset = -60 + tSeparation * ((f - 2) / 3)							--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 3) / 3) == (f - 3) / 3 then										--flight 3, 6, 9...
							offset = offset + separation														--to the right side of lead flight
							flight[f].eta_offset = -60 + tSeparation * ((f - 3) / 3)							--ETA delay in seconds for longitudinal flight separation
						end
					elseif role == "escort" then
						offset = separation / -2																--all escort routes are offset slightly to the left
						if math.floor((f - 1) / 4) == (f - 1) / 4 then											--flight 1, 5, 9...
							flight[f].eta_offset = -90 + tSeparation * ((f - 1) / 4)							--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 2) / 4) == (f - 2) / 4 then										--flight 2, 6, 10...
							offset = offset + separation * (3 + ((f - 2) / 4))									--to the right side of lead flight
							flight[f].eta_offset = tSeparation * ((f - 2) / 4)									--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 3) / 4) == (f - 3) / 4 then										--flight 3, 7, 11...
							offset = offset - separation * (3 + ((f - 3) / 4))									--to the left side of lead flight
							flight[f].eta_offset = tSeparation * ((f - 3) / 4)									--ETA delay in seconds for longitudinal flight separation
						elseif math.floor((f - 4) / 4) == (f - 4) / 4 then										--flight 4, 8, 12...
							flight[f].eta_offset = -240 + tSeparation * ((f - 4) / 4)							--ETA delay in seconds for longitudinal flight separation
						end
					end
					
					for w = 3, #flight[f].route - 1 do															--iterate through all waypoints that require lateral offset (taxi, departure and landing WP exluded)			
						if flight[f].route[w].id ~= "Target" then												--Target WP does not need lateral offset
							local inbound_heading = GetHeading(pack[p].main[1].route[w - 1], pack[p].main[1].route[w])		--inbound heading to WP of lead flight
							local outbound_heading = GetHeading(pack[p].main[1].route[w], pack[p].main[1].route[w + 1])		--outbound heading from WP of lead flight
							local delta_heading = GetDeltaHeading(inbound_heading, outbound_heading)			--amount of heading change at WP
							
							if delta_heading < 66 and delta_heading > -66 then									--if heading change is small, flights stay at the present side of lead flight (check turn)
								local alpha = inbound_heading + 90 + (delta_heading / 2)
								local dist = offset / math.cos(math.rad(delta_heading / 2))
								local offset_WP = GetOffsetPoint(flight[f].route[w], alpha, dist)
								flight[f].route[w].x = offset_WP.x
								flight[f].route[w].y = offset_WP.y
							else																				--if heading change is big, flights switch side from lead flight (tactical turn and cross turn)
								local alpha = outbound_heading - 90 + ((180 - delta_heading) / 2)
								local dist = offset / math.cos(math.rad((180 - delta_heading) / 2))
								local offset_WP = GetOffsetPoint(flight[f].route[w], alpha, dist)
								flight[f].route[w].x = offset_WP.x
								flight[f].route[w].y = offset_WP.y
								offset = offset * -1															--switch side
							end
						end
					end
				end
			end
			
			for f = 1, #flight do																					--iterate through flights in roles
			
				--flight TOT for packages continously covering a station
				if flight[f].task == "CAP" or flight[f].task == "AWACS" or flight[f].task == "Refueling" then		--flight is part of a package that continously covers a station
					local flights_needed = (flight[f].tot_to - flight[f].tot_from) / flight[f].loadout.description.tStation	--number of flights needed to continously cover station for duration of mission
					
					if #flight >= flights_needed then																--if package has enough flights to cover station
						tot = flight[f].tot_from + (f - 1) * flight[f].loadout.description.tStation + 1				--flight TOT (+1 second so that first flight spanwns at mission start a little ahead of station)
					else																							--if package does not have enough flights to cover station
						local station_idle = flight[f].tot_to - flight[f].tot_from - (#flight * flight[f].loadout.description.tStation)		--total time that station remains uncovered during a mission
						local idle_between_flight = station_idle / (#flight + 1)									--time the station is idle between flights
						tot = flight[f].tot_from + (f - 1) * flight[f].loadout.description.tStation + (idle_between_flight * f)	--flight TOT
					end
					if f == 1 and flight[f].player ~= true then														--if first flight in package and not the player flight
						partial_station = math.random(0, flight[f].loadout.description.tStation)					--set time that first flight was already on station at mission start
						if camp.time - partial_station < camp.dawn and flight[f].loadout.description.night == false then	--if before dawn and not night capable
							partial_station = camp.time - camp.dawn													--make partial_station to match dawn
						elseif camp.time - partial_station < camp.dusk and flight[f].loadout.description.day == false then	--if before dusk and not day capable
							partial_station = camp.time - camp.dusk													--make partial_station to match dusk
						end
					else																							--if remaining flights in package
						tot = tot - partial_station																	--remove time that the first flight was already on station at mission start
					end
				end
				
				--flight TOT for interceptors
				if flight[f].task == "Intercept" then
					flight[f].route[1].eta = 2									--interceptors only have one waypoint and start at mission start (but idle until activated by EWR)
				end
								
				--find target WP
				local eta = tot + flight[f].eta_offset							--Make ETA at target the TOT plus ETA offset for flight tSeparation within package
				for w = 1, #flight[f].route do									--iterate through all waypoints of flight
					if flight[f].route[w].id == "Target" or flight[f].route[w].id == "Station" or flight[f].route[w].id == "Sweep" then	--if target WP is found (target or orbit start)
						flight[f].route[w].eta = eta							--set ETA for target WP
						target_wp = w											--store target WP number
						if flight[f].player then								--if this is the player flight
							camp.player.tgt_wp = w								--store the target wp for the player
						end
						break
					end
				end
				
				--flight TOT for ferry flight (Nothing task)
				if flight[f].task == "Nothing" then
					flight[f].route[#flight[f].route].eta = eta					--set ETA for target WP (desitination WP)
					target_wp = #flight[f].route								--store target WP number (destination WP)
					if flight[f].player then									--if this is the player flight
						camp.player.tgt_wp = #flight[f].route					--store the target wp for the player
					end
				end
				
				--set WP ETAs going forward from target to landing
				local speed
				for w = target_wp + 1, #flight[f].route  do						--iterate through flight waypoints from target foward
					if flight[f].route[w].id == "Station" then					--if WP is the end point of an orbit station
						eta = flight[f].route[w - 1].eta + flight[f].loadout.description.tStation	--WP ETA is orbit start WP ETA plus on station time
						if f == 1 then											--for first flight in package	
							eta = eta - partial_station							--remove time that first flight was already on station before mission start
						end
						if eta > camp.dawn and flight[f].loadout.description.day == false then	--if ETA after dawn and not day capable
							eta = camp.dawn										--make dawn the orbit end ETA
						elseif eta > camp.dusk and flight[f].loadout.description.night == false then	--if ETA after dusk and not night capable
							eta = camp.dusk										--make dusk the orbit end ETA
						end
						flight[f].route[w].eta = eta							--set ETA at waypoint
					else
						if flight[f].route[w].id == "Egress" then
							speed = vAttack										--egress from target is at attack seed
						else
							speed = vCruise										--everything else is at cruise speed
						end
						if pack[p].main[1].loadout.description.standoff and pack[p].main[1].loadout.description.standoff > 15000 and flight[f].route[w].id == "Egress" then		--if the package has a standoff from target bigger than 15 km, proceed from attack point directly to egress
							local tgt_ap_dist = GetDistance(flight[f].route[target_wp], flight[f].route[target_wp - 1])		--distance from target to attack point
							local ap_eta = eta - tgt_ap_dist / speed			--eta at attack point
							local ap_egress_dist = GetDistance(flight[f].route[target_wp - 1], flight[f].route[target_wp + 1])	--distance from attack point to egress point
							eta = ap_eta + ap_egress_dist / speed				--calculate ETA at egress
						else
							local leg = GetDistance(flight[f].route[w - 1], flight[f].route[w])	--measure lenght of the next route leg
							eta = eta + leg / speed								--calculate ETA at next waypoint
						end
						flight[f].route[w].eta = eta							--set ETA at waypoint
					end
				end
				
				--set WP ETAs going backwards from target to take off
				local start_up_time = 480 + (flight[f].number - 1 * 20) 		--8 minutes and 20 seconds for each wingman for start up and taxi
				if flight[f].player == true then
					start_up_time = 900											--15 minutes for start up and taxi
				end
				
				eta = tot + flight[f].eta_offset								--reset target WP ETA
				for w = target_wp, 2, -1 do										--iterate through flight waypoints from target backwards
					if flight[f].route[w].id == "Attack" or flight[f].route[w].id == "Target" then	--WP is target point or attack point
						speed = vAttack											--ingress to target is at attack seed
					elseif flight[f].route[w].id == "Join" then					--WP is join point
						speed = vCruise / 4 * 3									--speed to Join Point is 3/4 of cruise speed to allow for the climb
					else
						speed = vCruise											--everything else is at cruise speed
					end
					local leg = GetDistance(flight[f].route[w], flight[f].route[w - 1])	--measure lenght of the previous route leg
					eta = eta - leg / speed										--calcualte ETA at previous waypoint
					if w - 1 == 1 then											--WP is first WP
						eta = eta - start_up_time								--subtract time for start up
					end
					
					flight[f].route[w - 1].eta = eta							--set ETA at previous waypoint
					
					if flight[f].player == true and w - 1 == 1 then				--for player flight and first waypoint
						player_start_shift = 2 - eta							--time shift to start player at mission start
					end
				end
				
				--set WP ETAs for transport tasks
				if flight[f].task == "Transport" then
					eta = math.random(flight[f].tot_from + 600, flight[f].tot_to)	--make destination ETA for each transport flight in package random
					flight[f].route[#flight[f].route].eta = eta					--set ETA at destination waypoint
					for w = #flight[f].route, 2, -1 do							--iterate through flight waypoints from destination backwards
						local leg = GetDistance(flight[f].route[w], flight[f].route[w - 1])	--measure lenght of the previous route leg
						eta = eta - leg / vCruise								--calcualte ETA at previous waypoint
						if w - 1 == 1 then										--WP is first WP
							eta = eta - start_up_time							--subtract time for start up
						end
						
						flight[f].route[w - 1].eta = eta						--set ETA at previous waypoint
						
						if flight[f].player == true and w - 1 == 1 then			--for player flight and first waypoint
							player_start_shift = 2 - eta						--time shift to start player at mission start
						end
					end
				end
			end
		end
		for role,flight in pairs(pack[p]) do													--iterate through roles in package (main, SEAD, escort)
			for f = 1, #flight do																--iterate through all flights
				for w = 1, #flight[f].route do													--iterate through all waypoints
					flight[f].route[w].eta = flight[f].route[w].eta + player_start_shift		--adjust WP eta by time difference for player to start at mission start
				end

				--Air starts
				local airstart = false															--if TOT causes a take off before mission start, flight becomes air start and this variable gets the number of the spawn WP
					
				for w = target_wp - 1, 1, -1 do													--iterate through waypoints backwards
					if flight[f].route[w].eta < 0 then											--ETA before mission start
						--find flight position at mission start and make it a WP
						local h = GetHeading(flight[f].route[w + 1], flight[f].route[w])		--heading from last WP with positive ETA
						local dist = flight[f].route[w + 1].eta * vCruise						--distance covered from mission start to first positive ETA
						if dist > GetDistance(flight[f].route[w], flight[f].route[w + 1]) then	--if distance is ahead of WP (caused by extra minutes at take off WP), keep spawn point over take off point but adjust id and alt for air spawn
							flight[f].route[w].id = "Spawn"
							flight[f].route[w].alt = flight[f].route[w + 1].alt
							flight[f].route[w].eta = 0											--ETA of WP is at mission start
						else																	--else move the spawn point to new location
							flight[f].route[w] = {
								x = flight[f].route[w + 1].x + math.cos(math.rad(h)) * dist,
								y = flight[f].route[w + 1].y + math.sin(math.rad(h)) * dist,
								eta = 0,														--ETA of WP is at mission start
								id = "Spawn",													--WP is spawn point
								alt = flight[f].route[w + 1].alt
							}
						end
						airstart = w															--store the number of the spawn WP (WPs ahead will be removed)
						break
					end
				end
			
				--remove WPs ahead of spawn WP
				local flight_tgt_wp = target_wp													--local copy of the target waypoint number for this flight only
				if airstart then																--if the flight is an air start
					for w = airstart - 1, 1, -1 do												--iterate through all the WPs from airstart WP to first WP
						table.remove(flight[f].route, w)										--remove all WPs ahead of spwan WP
						flight_tgt_wp = flight_tgt_wp - 1										--adjust flight target_wp
					end
				end
				
				--remove target and attack WP for escort tasks
				if flight[f].task == "Escort" then
					table.remove(flight[f].route, flight_tgt_wp)								--remove target WP from route
					if flight[f].route[flight_tgt_wp - 1].id ~= "Spawn" then
						table.remove(flight[f].route, flight_tgt_wp - 1)						--remove attack WP from route
					end
					if flight[f].player then													--if this is the player flight
						camp.player.tgt_wp = camp.player.tgt_wp - 2								--update the target WP (IP for Escort and SEAD)
					end
				end
				if flight[f].task == "SEAD" then
					table.remove(flight[f].route, flight_tgt_wp)								--remove target WP from route
					if flight[f].player then													--if this is the player flight
						camp.player.tgt_wp = camp.player.tgt_wp - 1								--update the target WP (IP for Escort and SEAD)
					end
				end
			end
		end
	end
end