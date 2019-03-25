--To assign the player to a flight in the ATO
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 

local playable = {}																		--local table to store playable flights

for side, pack in pairs(ATO) do															--iterate through sides in ATO
	for p = 1, #pack do																	--iterate through packages in sides
		for role,flight in pairs(pack[p]) do											--iterate through roles in package (main, SEAD, escort)
			for f = 1, #flight do														--iterate through flights in roles
				if flight[f].playable == true then										--if flight is playable by player
					if flight[f].tot_from == 0 then										--flight is allowed to fly at mission start
						if flight[f].number >= camp.coop then							--flight has enough aircraft for all players
							TrackPlayability(flight[f].playable, "coop")				--track playabilty criterium has been met
								
							if flight[f].task == "Intercept" then						--if the task is intercept, check if there is an enemy strike with target in range of player interceptor
								local enemy = "blue"
								if side == "blue" then
									enemy = "red"
								end
								for enemy_pack_n, enemy_pack in pairs(ATO[enemy]) do							--iterate through enemy packages
									if enemy_pack.main[1].tot_from == 0 then									--enemy package is allowed to fly at mission start
										for wp_n, wp in pairs(enemy_pack.main[1].route) do						--iterate through waypoints of first enemy main flight
											if wp.id == "Target" then											--waypoint is a target
												local dist = GetDistance(wp, flight[f].route[1])				--measure distance from interceptor base to target
												if dist <= flight[f].target.radius then							--target is in range for interception
													TrackPlayability(flight[f].playable, "intercept")			--track playabilty criterium has been met
													
													playable[#playable + 1] = {									--add flight to playable table
														side = side,
														pack = p,
														role = role,
														flight = f,
														unitname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. f .. "-" .. 1,
														target_side = enemy,
														target_pack = enemy_pack_n,
													}
												end
											end
										end
									end
								end
							elseif flight[f].task ~= "CAP" or (flight[f].task == "CAP" and f == 1 ) then		--if the task is CAP, allow only the first flight in package
								playable[#playable + 1] = {														--add flight to playable table
									side = side,
									pack = p,
									role = role,
									flight = f,
									unitname = "Pack " .. p .. " - " .. flight[f].name .. " - " .. flight[f].task .. " " .. f .. "-" .. 1,
								}
							end
						end
					end
				end
			end
		end
	end
end

if #playable > 0 then																--there are playable flights
	local r = math.random(1, #playable)												--pick random flight number
	ATO[playable[r].side][playable[r].pack][playable[r].role][playable[r].flight].player = true		--mark ATO entry as player flight
	
	camp.player = {
		side = playable[r].side,
		pack = ATO[playable[r].side][playable[r].pack],
		pack_n = playable[r].pack,
		role = playable[r].role,
		flight = playable[r].flight,
		unitname = playable[r].unitname,
		target = ATO[playable[r].side][playable[r].pack][playable[r].role][playable[r].flight].target,
		tgt_side = playable[r].target_side,
		tgt_pack = playable[r].target_pack,
		tgt_wp = 1,
	}
	
	PlayerFlight = true																--set true to end mission generation loop
	
	--for intercept task, modify target package spawn to enter EWR coverage at mission start
	if ATO[playable[r].side][playable[r].pack][playable[r].role][playable[r].flight].task == "Intercept" then		--player task is intercept
		local pack = ATO[playable[r].target_side][playable[r].target_pack]											--pointer to target package
		
		--find point where target package enters EWR coverage
		for w = 1, #pack.main[1].route - 1 do																		--iterate through waypoints of first main flight
		
			local base_route_distance = GetTangentDistance(pack.main[1].route[w], pack.main[1].route[w + 1], ATO[playable[r].side][playable[r].pack][playable[r].role][playable[r].flight].route[1])	--get closest distance from interceptor base to route between WP w and WP w+1
			if base_route_distance <= ATO[playable[r].side][playable[r].pack][playable[r].role][playable[r].flight].target.radius then		--route segement is in range of interceptor
				
				local leg_alt = "high"																					--define leg altitude between WP w and WP w+1
				if pack.main[1].route[w + 1].alt <= 1000 then
					leg_alt = "low"
				end
				
				local detected = false
				local distance = 100000000																				--distance from WP w to point where EWR coverage is entered
				local heading = GetHeading(pack.main[1].route[w], pack.main[1].route[w + 1])							--heading between WP w and WP w+1
				
				for e = 1, #ewr[playable[r].side][leg_alt] do															--iterate through all ewr/awacs
					local radar_route_distance = GetTangentDistance(pack.main[1].route[w], pack.main[1].route[w + 1], ewr[playable[r].side][leg_alt][e])		--get closest distance from radar to route between WP w and WP w+1
					if radar_route_distance < ewr[playable[r].side][leg_alt][e].range then								--if route passes radar range circle
						local p1_ewr_heading = GetHeading(pack.main[1].route[w], ewr[playable[r].side][leg_alt][e])		--heading from p1 to radar
						local alpha = math.abs(heading - p1_ewr_heading)												--angle beteen route and p1-ewr
						if alpha > 180 then
							alpha = math.abs(alpha - 360)
						end						
						local p1_ewr = GetDistance(pack.main[1].route[w], ewr[playable[r].side][leg_alt][e])			--distance between p1 and ewr
						local p1_p90ewr = math.cos(math.rad(alpha)) * p1_ewr											--distance between p1 and point on route perpendicular to ewr
						local p90ewr_ewr = p1_ewr * math.sin(math.rad(alpha))											--distance between ewr and point on route perpendicular to ewr
						local p90t_pC = math.sqrt(math.pow(ewr[playable[r].side][leg_alt][e].range, 2) - math.pow(p90ewr_ewr, 2))	--distance between point on route perpendiculat to ewr and point on route intersecting ewr circle
						local p1_pC = p1_p90ewr - p90t_pC																--distance from p1 to point on route intersecting ewr circle
						
						local p1_base = GetDistance(pack.main[1].route[w], ATO[playable[r].side][playable[r].pack][playable[r].role][playable[r].flight].route[1])	--distance between p1 and interceptor base
						local p1_p90base = math.cos(math.rad(alpha)) * p1_base											--distance between p1 and point on route perpendicular to base
						local p90base_base = p1_base * math.sin(math.rad(alpha))										--distance between base and point on route perpendicular to base
						local p90b_pB = math.sqrt(math.pow(ATO[playable[r].side][playable[r].pack][playable[r].role][playable[r].flight].target.radius, 2) - math.pow(p90base_base, 2))	--distance between point on route perpendiculat to base and point on route intersecting base circle
						local p1_pB = p1_p90base - p90b_pB																--distance from p1 to point on route intersecting base circle
						
						if p1_pC <= 0 then																				--if point on route intersecting ewr circle is ahead of p1
							distance = 0																				--p1 is already within a ewr circle
							camp.player.EWR_freq = ewr[playable[r].side][leg_alt][e].frequency							--store frequency of EWR station (stores nil for AWACS)
							camp.player.EWR_call = ewr[playable[r].side][leg_alt][e].callsign							--store callsign of EWR station (stores nil for AWACS)
						elseif p1_pC < distance then
							distance = p1_pC																			--find the shortest distance to all ewr circles (this is the point on route where first EWR area is entered)
							camp.player.EWR_freq = ewr[playable[r].side][leg_alt][e].frequency							--store frequency of EWR station (stores nil for AWACS)
							camp.player.EWR_call = ewr[playable[r].side][leg_alt][e].callsign							--store callsign of EWR station (stores nil for AWACS)
						end
						if distance < p1_pB then
							distance = p1_pB
						end
						detected = true																					--route entered EWR coverage
					end					
				end
			
				if detected then																						--route entered EWR coverage
					
					--set package TOT
					local route_time = 0
					for n = w, #pack.main[1].route - 1 do																--iterate through waypoints again, starting from current WP
						local leg_speed																					--speed on route leg
						if pack.main[1].route[n].id == "IP" or pack.main[1].route[n].id == "Attack" then
							leg_speed = pack.main[1].loadout.description.vAttack										--attack speed
						else
							leg_speed = pack.main[1].loadout.description.vCruise										--cruise speed
						end
						local leg_time = GetDistance(pack.main[1].route[n], pack.main[1].route[n + 1]) / leg_speed		--time of flight for route leg
						route_time = route_time + leg_time																--collect complete route time
						if pack.main[1].route[n].id == "Attack" then													--continue until last leg to target
							break																						--stop second route loop
						end
					end
					route_time = route_time - distance / pack.main[1].loadout.description.vCruise						--subtract time of flight for undetected part on detection route leg
					
					pack.main[1].tot = route_time																		--set package TOT for spawn at misison start when entering EWR detection area
					
					break																								--stop first route loop
				end
			end
		end
	end
end