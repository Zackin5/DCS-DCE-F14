--To generate a flight route from base to target, evading as much threats as possible
--Returns route points, route lenght and route threat level (unavoided threats)
--Initiated by Main_NextMission.lua
------------------------------------------------------------------------------------------------------- 


function GetRoute(basePoint, targetPoint, profile, enemy, task, time)													--enemy: "blue" or "red"; time: "day" or "night"

	local route = {}																									--table to store the route to be built
	local route_axis = GetHeading(targetPoint, basePoint)																--axis base-target
	
	
	--define cruise and attack altitude band
	local cruise_alt
	if profile.hCruise >= 3000 then
		cruise_alt = "high"
	else
		cruise_alt = "low"
	end
	
	local attack_alt
	if profile.hAttack >= 3000 then
		attack_alt = "high"
	else
		attack_alt = "low"
	end	


	--function to check if a line between two points runs through a threat. Returns a table of threats
	local function ThreatOnLeg(point1, point2, leg_alt)
		local tbl = {}																									--local table to collect threats on route leg
		
		--check ground threats
		for t = 1, #groundthreats[enemy][leg_alt] do																	--iterate through all ground threats
			if time == "day" or groundthreats[enemy][leg_alt][t].night == true then										--during day or threat is night capable to be counted as threat
				local threat_route_distance = GetTangentDistance(point1, point2, groundthreats[enemy][leg_alt][t])		--get closest distance from threat to route between point 1 and point 2
				if threat_route_distance < groundthreats[enemy][leg_alt][t].range then									--if route passes threat
					table.insert(tbl, groundthreats[enemy][leg_alt][t])	
				end
			end
		end

		--check EWR threats
		for e = 1, #ewr[enemy][leg_alt] do																				--iterate through all ewr/awacs
			if ewr[enemy][leg_alt][e].class == "EWR" then																--only do for EWR, ignore AWACS (too large area to avoid)
				
				local entry = {
					level = 0
				}
				
				for t = 1, #fighterthreats[enemy] do																	--iterate through all fighter threats
					local ewr_required																					--boolean whether ewr is required for the fighter to be a threat
					if fighterthreats[enemy][t].class == "CAP" then														--if the fighter is CAP
						if leg_alt == "high" then																		--if route leg is at high altitude
							ewr_required = false																		--CAP does not need ewr to be a threat
						else																							--if route leg is at low altitude
							if fighterthreats[enemy][t].LDSD then														--if fighter is look down/shoot down capable
								ewr_required = false																	--CAP does not need ewr to be a threat
							else																						--if fighter is not look down/shoot down capable
								ewr_required = true																		--CAP needs ewr to be a threat
							end
						end
					elseif fighterthreats[enemy][t].class == "Intercept" then											--if the fighter is an interceptor
						ewr_required = true																				--ewr is required for fighter to be a threat (needs early warning to take off)
					end
					
					if ewr_required == true then																		--EWR stations that can command fighters that require ewr guidance are counted as threats (AWACS and fighter areas are ignored, since these are too large areas to avoid anyway)
						if GetDistance(ewr[enemy][leg_alt][e], fighterthreats[enemy][t]) < ewr[enemy][leg_alt][e].range + fighterthreats[enemy][t].range then	--if fighterthreats and ewr are overlapping
							if GetTangentDistance(point1, point2, fighterthreats[enemy][t]) < fighterthreats[enemy][t].range then								--if route leg is in range of fighterthreat
								if GetTangentDistance(point1, point2, ewr[enemy][leg_alt][e]) < ewr[enemy][leg_alt][e].range then								--if route leg is in range of ewr
									if fighterthreats[enemy][t].level > entry.level then								--fighterthreat level is higher than current entry for this ewr
										entry = ewr[enemy][leg_alt][e]													--make this ewr the entry
										entry.level = fighterthreats[enemy][t].level									--capability level of fighter becomes new threat level of EWR station
									end						
								end
							end
						end
					end
				end
				
				if entry.level > 0 then																					--if a threat level for this ewr was found
					table.insert(tbl, entry)																			--save ewr station as threat on this leg
				end
			end
		end
		
		return tbl
	end

	
	--function to define a set of nav points to make a route between two points that evades threats
	local function FindPath(from, to)
		local NavRoutes = {}																										--table to temporary store all possible nav routes
		local direct_distance = GetDistance(from, to)																				--distance of direct path between start and end of route
		
		local function FindPathLeg(point1, point2, pointEnd, distance, route, instance, leg_alt)									--find a route between point1 and point2
			instance = instance + 1																									--increase instance of the function
			
			local distance_remain = GetDistance(point1, pointEnd)																	--remaining distance to end
			local threat = ThreatOnLeg(point1, point2, leg_alt)																		--get the threat between point1 and point2
			
			--ignore threats that directly cover point1 or point2
			for t = #threat, 1, -1 do																								--iterate through threats from back to front
				if GetDistance(point1, threat[t]) <= threat[t].range or GetDistance(pointEnd, threat[t]) <= threat[t].range then	--if threat is in range of point1 or pointEnd it cannot be avoided and must be ignored
					table.remove(threat, t)																							--remove threat
				end
			end
			
			table.insert(NavRoutes, {navpoints = route, dist = distance + distance_remain, threats = #threat})						--save route variant directly to end from current route branch
			
			if instance > 7 then																									--if function instance is bigger than 7
				return																												--abort this route branch
			elseif distance + distance_remain > (direct_distance * 1.5) then														--if total route distance is bigger than 1.5 times the direct distance
				return																												--abort this route branch
			elseif #threat == 0 then																								--if no more threats on remaining route
				if point2 == pointEnd then																							--if point2 is the pointEnd
					return																											--abort further route finding
				else																												--if point2 is not the end
					distance = distance + GetDistance(point1, point2)																--complete route distance of this variant up to point2
					table.insert(route, point2)																						--add point2 to route
					FindPathLeg(point2, pointEnd, pointEnd, distance, route, instance, leg_alt)										--continue find route from point2 to end
				end
			else																													--if there is a threat on leg
				if leg_alt == "high" and attack_alt == "low" then																	--if the current leg is high (from cruise) but the attack alt is low, try leg again low
					FindPathLeg(point1, point2, pointEnd, distance, route, instance - 1, "low")										--try leg again low (do not increase instance)
				else
					--find left/right side alternates around threat
					local point1_point2_heading = GetHeading(point1, point2)														--get heading from point1 to point2
					
					for s = 1, -1, -2 do																							--repeat twice for left and right side
						local point2alt = GetOffsetPoint(threat[1], point1_point2_heading + (s * 90), threat[1].range * 4/3)		--get alternate point2 on left/right side of current threat (1/3 out of threat range)
						point2alt.h = leg_alt																						--set altitude
						local threat_leg = ThreatOnLeg(point1, point2alt, leg_alt)													--get threat between point1 and alternate point2
						
						--ignore threats that point1 is already in
						for t = #threat_leg, 1, -1 do																				--iterate through threats from back to front
							if GetDistance(point1, threat_leg[t]) <= threat_leg[t].range or GetDistance(pointEnd, threat_leg[t]) <= threat_leg[t].range then	--if threat is in range of point1 or pointEnd it cannot be avoided and must be ignored
								table.remove(threat_leg, t)																			--remove threat
							end
						end
						
						if #threat_leg == 0 then																					--if there is no threat between point 1 and alternate point2
							local distance_alt = distance + GetDistance(point1, point2alt)											--complete route distance of this variant up to point2alt
							local route_alt = {}																					--make a local copy of the route up to now
							for k, v in pairs(route) do
								route_alt[k] = {
									x = v.x,
									y = v.y,
									h = v.h,
								}
							end
							table.insert(route_alt, point2alt)																		--add point2alt to this route variant
							FindPathLeg(point2alt, pointEnd, pointEnd, distance_alt, route_alt, instance, leg_alt)					--continue route from point2alt
						else																										--if there is a threat between point1 and point2alt
							FindPathLeg(point1, point2alt, pointEnd, distance, route, instance, leg_alt)							--find new route to point2alt
						end
					end
				end
			end
		end

		FindPathLeg(from, to, to, 0, {}, 0, cruise_alt)																--find a route between start and end point. arguments: start, end, final end (same), initial route distance 0, initial route empty {}, initial instance of the function 0, cruise alt ("high" or "low")
		
		--Determine best nav route from NavRoutes table
		local temp_route = {																						--local table to store the currently selected optimal route
			navpoints = {},
			dist = GetDistance(from, to)
		}
		if #NavRoutes == 0 then
			return temp_route
		else
			for n = 1, #NavRoutes do																				--Go through all stored routes
				if n == 1 then
					temp_route = NavRoutes[n]																		--make first route the temp route
				else
					if NavRoutes[n].threats < temp_route.threats or (NavRoutes[n].threats == temp_route.threats and NavRoutes[n].dist < temp_route.dist) then	--if next route has either less threats or the same threats and shorter distance, make this the current temp route
						temp_route = NavRoutes[n]
					end
				end
			end
			return temp_route																						--return the selected route
		end
	end

	
	----- find a route depending on task -----
	if task == "Ground Attack" or task == "Pinpoint Strike" or task == "Anti-ship Strike" or task == "Runway Attack" or task == "CAS" or task == "Reconnaissance" then
	
		--set Initial Point IP
		local initialPoint = {}																				--initial point
		
		local standoff																						--standoff distance of attack WP from target
		if profile.standoff then																			--if standoff defined in loadout profile
			standoff = profile.standoff																		--use value from loadout profile
		else																								--if no standoff defined in loadout profile
			standoff = profile.hAttack + profile.vAttack * 25												--standoff distance is attack alt plus 25 seconds at attack speed
			if standoff < 7000 then																			--standoff should be at least 7000m
				standoff = 7000
			end
		end
		
		do
			local IP_distance = standoff + profile.vAttack * 60												--distance target-IP is standoff range from profile + 60 seconds run in at attack speed
			local IP_table = {}																				--table to store all possible IPs
			
			for n = 0, 90, 5 do																				--find IP by evaluating threat level for IPs between approach axis and 90° offset in 5° steps
				if initialPoint.x then																		--break loop if an IP is set																
					break
				else
					for m = 1, -1, -2 do																	--try left and right option for each offset from appraoch axis (*1, *-1)
						local draft_IP = GetOffsetPoint(targetPoint, route_axis + (n * m), IP_distance)		--draft IP for current offset
						local threat = ThreatOnLeg(draft_IP, targetPoint, attack_alt)						--all threats between draft IP and target
						local total_threat_level = 0														--cumulated threat level for this leg
						for t = 1, #threat do																--iterate through all threats on this option
							if threat[t].class ~= "EWR" then												--threat is not an EWR (EWR are ignored for evaluating draft IP)
								local threat_distance = GetTangentDistance(draft_IP, targetPoint, threat[t])	--distance to threat
								local threat_level = (1 - threat_distance / threat[t].range) * threat[t].level	--threat level for this indiviudal threat (% of total engagement distance * threat level)
								total_threat_level = total_threat_level + threat_level						--sum all threat levels to total threat level
							end
						end
						if total_threat_level == 0 then														--if there is no threat, make this the IP and stop evaluation
							initialPoint = draft_IP
							break
						else																				--if there are threats
							table.insert(IP_table, {point = draft_IP, threat = total_threat_level})			--store current draft IP in IP table
						end
					end
				end
			end

			if initialPoint.x == nil then																	--if IP is not yet set, find the best from IP table
				local current_threat = 1000000
				for n = 1, #IP_table do																		--iterate through all draft IPs to find to one with the lowest threat level
					if IP_table[n].threat < current_threat then												--if this draft IP has a lower threat level than the IP currently set
						initialPoint = IP_table[n].point													--make it the new IP
						current_threat = IP_table[n].threat													--this is the threat level of the currently set IP			
					end
				end
			end
		end
		
		
		--set attack point
		local target_ip_heading = GetHeading(targetPoint, initialPoint)
		local attackPoint = GetOffsetPoint(targetPoint, target_ip_heading, standoff)						--attack point is standoff range from target on straight IP-target line
		
		
		--set egress point
		local egressPoint = {}																				--egress point
		do
			local egress_point_start																		--point from where egress is initiated (target or attack point depending on standoff profile)
			local egress_table = {}
			local egress_distance = standoff + profile.vAttack * 90											--egress point is standoff range from target plus 90 seconds run out at attack speed
			local egress_heading
			
			if task == "Ground Attack" or task == "Pinpoint Strike" or task == "Anti-ship Strike" or task == "Runway Attack" or task == "CAS" then
				if standoff <= 15000 then																		--if standoff range is 15'000m or less, assume target will be overflown. Optimal egress should be 90° offset from ingress in direction of RTB
					egress_point_start = targetPoint															--egress starts from target
					if GetDeltaHeading(route_axis, target_ip_heading) < 0 then									--homebase is on left side of ingress heading
						egress_heading = target_ip_heading + 90													--optimal egress heading is 90° to left
					else																						--homebase is on right side of ingress heading
						egress_heading = target_ip_heading - 90													--optimal egress heading is 90° to right
					end
				else																							--if standoff range is bigger than 15'000m, optimal egrees should be in direction of ingress offset by 30° in direction of RTB
					egress_point_start = attackPoint															--egress starts from attack point
					if GetDeltaHeading(route_axis, target_ip_heading) < 0 then									--homebase is on left side of ingress heading
						egress_heading = target_ip_heading + 30													--optimal egress heading is 30° to left
					else																						--homebase is on right side of ingress heading
						egress_heading = target_ip_heading - 30													--optimal egress heading is 30° to right
					end
				end
					
				for n = 0, 135, 5 do																			--find egress point by evaluating threat level for egress between egress heading and +/- 135° offset in 5° steps
					if egressPoint.x then																		--break loop if an egress point is set																
						break
					else
						for m = 1, -1, -2 do																	--try left and right option for each offset from egress heading (*1, *-1)
							if GetDeltaHeading(egress_heading + n * m, target_ip_heading) >= 15 or GetDeltaHeading(egress_heading + n * m, target_ip_heading) <= -15 then	--valid egresses must be at least 15° offset from ingress
								local draft_egress = GetOffsetPoint(targetPoint, egress_heading + n * m, egress_distance)	--draft egress for current offset
								local threat = ThreatOnLeg(egress_point_start, draft_egress, attack_alt)			--all threats between attack point and draft egress point
								local total_threat_level = 0														--cumulated threat level for this leg
								for t = 1, #threat do																--iterate through all threats on this option
									if threat[t].class ~= "EWR" then												--threat is not an EWR (EWR are ignored for evaluating draft egress point)
										local threat_distance = GetTangentDistance(egress_point_start, draft_egress, threat[t])	--distance to threat
										local threat_level = (1 - threat_distance / threat[t].range) * threat[t].level	--threat level for this indiviudal threat (% of total engagement distance * threat level)
										total_threat_level = total_threat_level + threat_level						--sum all threat levels to total threat level
									end
								end
								if total_threat_level == 0 then														--if there is no threat, make this the egress point and stop evaluation
									egressPoint = draft_egress
									break
								else
									table.insert(egress_table, {point = draft_egress, threat = total_threat_level})	--store current draft IP in IP table
								end
							end
						end
					end
				end
				
			elseif task == "Reconnaissance" then																	--for recon missions
				egress_heading = GetHeading(initialPoint, targetPoint)
				for n = 0, 30, 5 do																					--find egress point by evaluating threat level for egress between egress heading and +/- 30° offset in 5° steps
					if egressPoint.x then																			--break loop if an egress point is set																
						break
					else
						for m = 1, -1, -2 do																		--try left and right option for each offset from egress heading (*1, *-1)
							local draft_egress = GetOffsetPoint(targetPoint, egress_heading + n * m, egress_distance)	--draft egress for current offset
							local threat = ThreatOnLeg(targetPoint, draft_egress, attack_alt)						--all threats between target point and draft egress point
							local total_threat_level = 0															--cumulated threat level for this leg
							for t = 1, #threat do																	--iterate through all threats on this option
								if threat[t].class ~= "EWR" then													--threat is not an EWR (EWR are ignored for evaluating draft egress point)
									local threat_distance = GetTangentDistance(targetPoint, draft_egress, threat[t])	--distance to threat
									local threat_level = (1 - threat_distance / threat[t].range) * threat[t].level	--threat level for this indiviudal threat (% of total engagement distance * threat level)
									total_threat_level = total_threat_level + threat_level							--sum all threat levels to total threat level
								end
							end
							if total_threat_level == 0 then															--if there is no threat, make this the egress point and stop evaluation
								egressPoint = draft_egress
								break
							else
								table.insert(egress_table, {point = draft_egress, threat = total_threat_level})		--store current draft IP in IP table
							end
						end
					end
				end
			end
			
			if egressPoint.x == nil then																			--if egress is not yet set, find the best from egress table
				local current_threat = 1000000
				for n = 1, #egress_table do																			--iterate through all draft egress points to find to one with the lowest threat level
					if egress_table[n].threat < current_threat then													--if this draft egress has a lower threat level than the egress currently set
						egressPoint = egress_table[n].point															--make it the new egress point
						current_threat = egress_table[n].threat														--this is the threat level of the currently set egress			
					end
				end
			end
		end

		
		--set outbound and inbound routes
		local outbound_navRoute = FindPath(basePoint, initialPoint)														--find the safest route between basePoint and initialPoint
		local inbound_navRoute = FindPath(basePoint, egressPoint)														--find the safest route between egressPoint and basePoint
	

		--set form-up point
		local joinPoint = {}																							--point where package joins on common flight route
		do
			local point																									--join point is between basePoint and this local point
			if #outbound_navRoute.navpoints == 0 then																	--if there is no outbound nav route
				point = initialPoint																					--point is IP
			else																										--if there is an outbound nav route
				point = outbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)
			
			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to climb from base elevation to cruise altitude with 8° pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--climb distance bigger than distance to first WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to first WP
			elseif distance < 15000 then																				--climb distance less than 15 km
				distance = 15000																						--join point should be at least 15 km from base
			end
			
			joinPoint = GetOffsetPoint(basePoint, heading, distance)													--define join point
		end
		
		
		--set split point
		local splitPoint = {}																							--point where package splits to land on individual airbases		
		do
			local point																									--split point is between basePoint and this local point
			if #inbound_navRoute.navpoints == 0 then																	--if there is no inbound nav route
				point = egressPoint																						--point is egress point
			else																										--if there is an inbound nav route
				point = inbound_navRoute.navpoints[#inbound_navRoute.navpoints]											--point is last nav point
			end
			local heading = GetHeading(basePoint, point)
			
			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to descend from cruise alt to base elevation with 8° pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--descend distance bigger than distance to last WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to last WP
			elseif distance < 15000 then																				--descend distance less than 15 km
				distance = 15000																						--split point should be at least 15 km from base
			end
			
			splitPoint = GetOffsetPoint(basePoint, heading, distance)													--define split point
		end
		
		
		--build complete route
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = 0})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h + 1000})
		table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = profile.hCruise})
		for n = 1, #outbound_navRoute.navpoints do
			local alt
			if outbound_navRoute.navpoints[n].h == "low" and cruise_alt == "high" then
				h = profile.hAttack
			else
				h = profile.hCruise
			end
			table.insert(route, {x = outbound_navRoute.navpoints[n].x, y = outbound_navRoute.navpoints[n].y, id = "Nav", alt = h})
		end
		table.insert(route, {x = initialPoint.x, y = initialPoint.y, id = "IP", alt = profile.hAttack})
		table.insert(route, {x = attackPoint.x, y = attackPoint.y, id = "Attack", alt = profile.hAttack})
		table.insert(route, {x = targetPoint.x, y = targetPoint.y, id = "Target", alt = profile.hAttack})
		table.insert(route, {x = egressPoint.x, y = egressPoint.y, id = "Egress", alt = profile.hAttack})
		for n = #inbound_navRoute.navpoints, 1, -1 do
			local alt
			if inbound_navRoute.navpoints[n].h == "low" and cruise_alt == "high" then
				h = profile.hAttack
			else
				h = profile.hCruise
			end
			table.insert(route, {x = inbound_navRoute.navpoints[n].x, y = inbound_navRoute.navpoints[n].y, id = "Nav", alt = h})
		end
		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = profile.hCruise})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Land", alt = profile.hCruise})
		
		
		--set descend and climb points in route
		if profile.hCruise ~= profile.hAttack then																		--if cruise and attack are not the same, a descend and a climb point must be inserted
			for n = 3, #route - 2 do																					--iterate through route between join and split point
				if route[n].alt > route[n + 1].alt then																	--descend route leg
					local leg_alt = "high"
					local threat = ThreatOnLeg(route[n], route[n + 1], leg_alt)
					if #threat == 0 or cruise_alt == attack_alt then													--if there is no threat on route (or cruise alt and attack alt are in the same altitude band), insert a single descend point
						local descendPoint = {}																			--point to start descend
						local heading = GetHeading(route[n + 1], route[n])												--descend point is on route leg
						local distance = math.abs((profile.hCruise - profile.hAttack) * 10)								--distance to descend is 10 times the altitude difference (~-6° pitch) (make sure is positive)
						if distance < GetDistance(route[n + 1], route[n]) then											--if descend distance is longer than route leg distance, ignore descend point
							descendPoint = GetOffsetPoint(route[n + 1], heading, distance)								--define descend point position
							descendPoint.id = "Nav"
							descendPoint.alt = profile.hCruise
							table.insert(route, n + 1, descendPoint)													--insert into route
						end
					else																								--if there are threats on route leg, insert two start decend/end decend points
						local descendPointEnd = {}																		--point where descend must be completed (here the high alt threat is entered)
						local distance = 100000000
						local heading = GetHeading(route[n], route[n + 1])
						for t = 1, #threat do
							local p1_t_heading = GetHeading(route[n], threat[t])
							local alpha = math.abs(heading - p1_t_heading)												--angle beteen route and p1-threat
							if alpha > 180 then
								alpha = math.abs(alpha - 360)
							end						
							local p1_t = GetDistance(route[n], threat[t])												--distance between p1 and threat
							local p1_p90t = math.cos(math.rad(alpha)) * p1_t											--distance between p1 and point on route perpendicular to threat
							local p90t_t = p1_t * math.sin(math.rad(alpha))												--distance between threat and point on route perpendicular to threat
							local p90t_pC = math.sqrt(math.pow(threat[t].range, 2) - math.pow(p90t_t, 2))				--distance between point on route perpendiculat to threat and point on route intersecting threat circle
							local p1_pC = p1_p90t - p90t_pC																--distance from p1 to point on route intersecting threat circle
							if p1_pC <= 0 then																			--if point on route intersecting threat circle is ahead of p1
								distance = 0
								break																					--p1 is already within a threat circle. No descend point is needed, alter p1 to low level instead
							elseif p1_pC < distance then
								distance = p1_pC																		--find the shortest distance to all threat circles (this is the point on route where the decend to low alt must be completed)
							end
						end
						
						if distance == 0 then																			--descend point is ahead of route[n]
							route[n].alt = profile.hAttack																--set route[n] to low alttude
						else																							--descend point is beyond of route[n]
							descendPointEnd = GetOffsetPoint(route[n], heading, distance)								--define descend point position
							descendPointEnd.id = "Nav"
							descendPointEnd.alt = profile.hAttack
							table.insert(route, n + 1, descendPointEnd)													--insert into route
						end
						
						local descend_distance = (profile.hCruise - profile.hAttack) * 5								--distance to descend is 5 times the altitude difference (~-11° pitch)
						if descend_distance < distance then
							local descendPointStart = {}																--point where descend starts
							descendPointStart = GetOffsetPoint(route[n], heading, (distance - descend_distance))		--define descend point position
							descendPointStart.id = "Nav"
							descendPointStart.alt = profile.hCruise
							table.insert(route, n + 1, descendPointStart)												--insert into route
						end
					end
					break
				end
			end
			for n = 3, #route - 2 do																					--iterate through route between join and split point
				if route[n].alt < route[n + 1].alt then																	--climb route leg
					local leg_alt = "high"
					local threat = ThreatOnLeg(route[n], route[n + 1], leg_alt)
					if #threat == 0 or cruise_alt == attack_alt then													--if there is no threat on route (or cruise and attack alt are in the same altitude band), insert a single climb point
						local climbPoint = {}																			--point to start climb
						local heading = GetHeading(route[n], route[n + 1])												--climb point is on route leg
						local distance = math.abs((profile.hCruise - profile.hAttack) * 10)								--distance to climb is 10 times the altitude difference (~6° pitch) (make sure is positive)
						if distance < GetDistance(route[n], route[n + 1]) then											--if climb distance is longer than route leg distance, ignore climb point
							climbPoint = GetOffsetPoint(route[n], heading, distance)									--define climb point position
							climbPoint.id = "Nav"
							climbPoint.alt = profile.hCruise
							table.insert(route, n + 1, climbPoint)														--insert into route
						end
					else																								--if there are threats on route leg, insert two start climb/end climb points
						local climbPointStart = {}																		--point where climb must start (here the high alt threat area is left)
						local distance = 100000000
						local heading = GetHeading(route[n + 1], route[n])
						for t = 1, #threat do
							local p1_t_heading = GetHeading(route[n + 1], threat[t])
							local alpha = math.abs(heading - p1_t_heading)												--angle beteen route and p1-threat
							if alpha > 180 then
								alpha = math.abs(alpha - 360)
							end
							local p1_t = GetDistance(route[n + 1], threat[t])											--distance between p1 and threat
							local p1_p90t = math.cos(math.rad(alpha)) * p1_t											--distance between p1 and point on route perpendicular to threat
							local p90t_t = p1_t * math.sin(math.rad(alpha))												--distance between threat and point on route perpendicular to threat
							local p90t_pC = math.sqrt(math.pow(threat[t].range, 2) - math.pow(p90t_t, 2))				--distance between point on route perpendiculat to threat and point on route intersecting threat circle
							local p1_pC = p1_p90t - p90t_pC																--distance from p1 to point on route intersecting threat circle
							if p1_pC <= 0 then																			--if point on route intersecting threat circle is ahead of p1
								distance = 0
								break																					--p1 is already within a threat circle. No climb point is needed, alter p1 to low level instead
							elseif p1_pC < distance then
								distance = p1_pC																		--find the shortest distance to all threat circles (this is the point on route where the climb to high alt can start)
							end
						end
						if distance == 0 then																			--climb point is beyond of route[n + 1]
							route[n + 1].alt = profile.hAttack															--set route[n + 1] to low alttude
						else																							--climb point is ahead of route[n + 1]
							climbPointStart = GetOffsetPoint(route[n + 1], heading, distance)							--define climb point position
							climbPointStart.id = "Nav"
							climbPointStart.alt = profile.hAttack
							table.insert(route, n + 1, climbPointStart)													--insert into route
						end
						
						local climb_distance = (profile.hCruise - profile.hAttack) * 10									--distance to climb is 10 times the altitude difference (~-6° pitch)
						if climb_distance < distance then
							local climbPointEnd = {}																	--point where climb ends
							climbPointEnd = GetOffsetPoint(route[n + 2], heading, (distance - climb_distance))			--define climb point position
							climbPointEnd.id = "Nav"
							climbPointEnd.alt = profile.hCruise
							table.insert(route, n + 2, climbPointEnd)													--insert into route
						end
					end
					break
				end
			end
		end
	

	elseif task == "CAP" or task == "AWACS" or task == "Refueling" or task == "Fighter Sweep" then
		
		--set orbit points
		local orbit_lenght
		if task == "CAP" then
			orbit_lenght = 15000
		elseif task == "Fighter Sweep" then
			orbit_lenght = 37000
		elseif task == "AWACS" then
			orbit_lenght = 50000
		elseif task == "Refueling" then
			orbit_lenght = 50000
		end
		
		local orbitStart = {}
		local orbitEnd = {}
		
		orbitStart = GetOffsetPoint(targetPoint, route_axis + 90, orbit_lenght / 2)
		orbitEnd = GetOffsetPoint(targetPoint, route_axis - 90, orbit_lenght / 2)
		
		
		--set outbound and inbound routes
		local outbound_navRoute = FindPath(basePoint, orbitStart)														--find the safest outbound route
		local inbound_navRoute = FindPath(basePoint, orbitEnd)															--find the safest inbound route
	

		--set form-up point
		local joinPoint = {}																							--point where package joins on common flight route
		do
			local point																									--join point is between basePoint and this local point
			if #outbound_navRoute.navpoints == 0 then																	--if there is no outbound nav route
				point = orbitStart																						--point is orbitStart
			else																										--if there is an outbound nav route
				point = outbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)
			
			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to climb from base elevation to cruise altitude with 8° pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--climb distance bigger than distance to first WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to first WP
			elseif distance < 15000 then																				--climb distance less than 15 km
				distance = 15000																						--join point should be at least 15 km from base
			end
			
			joinPoint = GetOffsetPoint(basePoint, heading, distance)													--define join point
		end
		
		
		--set split point
		local splitPoint = {}																							--point where package splits to land on individual airbases		
		do
			local point																									--split point is between basePoint and this local point
			if #inbound_navRoute.navpoints == 0 then																	--if there is no inbound nav route
				point = orbitEnd																						--point is orbitEnd
			else																										--if there is an inbound nav route
				point = inbound_navRoute.navpoints[#inbound_navRoute.navpoints]											--point is last nav point
			end
			local heading = GetHeading(basePoint, point)
			
			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to descend from cruise alt to base elevation with 8° pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--descend distance bigger than distance to last WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to last WP
			elseif distance < 15000 then																				--descend distance less than 15 km
				distance = 15000																						--split point should be at least 15 km from base
			end
			
			splitPoint = GetOffsetPoint(basePoint, heading, distance)													--define split point
		end
		
		
		--build complete route
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = 0})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h + 1000})
		table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = profile.hCruise})
		for n = 1, #outbound_navRoute.navpoints do
			local alt
			if outbound_navRoute.navpoints[n].h == "low" and cruise_alt == "high" then
				h = profile.hAttack
			else
				h = profile.hCruise
			end
			table.insert(route, {x = outbound_navRoute.navpoints[n].x, y = outbound_navRoute.navpoints[n].y, id = "Nav", alt = h})
		end
		if task == "Fighter Sweep" then
			table.insert(route, {x = orbitStart.x, y = orbitStart.y, id = "Sweep", alt = profile.hAttack})
			table.insert(route, {x = orbitEnd.x, y = orbitEnd.y, id = "Sweep", alt = profile.hAttack})
		else
			table.insert(route, {x = orbitStart.x, y = orbitStart.y, id = "Station", alt = profile.hAttack})
			table.insert(route, {x = orbitEnd.x, y = orbitEnd.y, id = "Station", alt = profile.hAttack})
		end
		for n = #inbound_navRoute.navpoints, 1, -1 do
			local alt
			if inbound_navRoute.navpoints[n].h == "low" and cruise_alt == "high" then
				h = profile.hAttack
			else
				h = profile.hCruise
			end
			table.insert(route, {x = inbound_navRoute.navpoints[n].x, y = inbound_navRoute.navpoints[n].y, id = "Nav", alt = h})
		end
		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = profile.hCruise})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Land", alt = profile.hCruise})

		
	elseif task == "Transport" or task == "Nothing" then
		
		--set outbound and inbound routes
		local outbound_navRoute = FindPath(basePoint, targetPoint)														--find the safest outbound route
	
		--set form-up point
		local joinPoint = {}																							--point where package joins on common flight route
		do
			local point																									--join point is between basePoint and this local point
			if #outbound_navRoute.navpoints == 0 then																	--if there is no outbound nav route
				point = targetPoint																						--point is targetPoint
			else																										--if there is an outbound nav route
				point = outbound_navRoute.navpoints[1]																	--point is first nav point
			end
			local heading = GetHeading(basePoint, point)
			
			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to climb from base elevation to cruise altitude with 8° pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--climb distance bigger than distance to first WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to first WP
			elseif distance < 15000 then																				--climb distance less than 15 km
				distance = 15000																						--join point should be at least 15 km from base
			end
			
			joinPoint = GetOffsetPoint(basePoint, heading, distance)													--define join point
		end
		
		--set split point
		local splitPoint = {}																							--point where package splits to land on individual airbases		
		do
			local point																									--split point is between basePoint and this local point
			if #outbound_navRoute.navpoints == 0 then																	--if there is no outbound nav route
				point = joinPoint																						--point is joinPoint
			else																										--if there is an outbound nav route
				point = outbound_navRoute.navpoints[#outbound_navRoute.navpoints]										--point is last nav point
			end
			local heading = GetHeading(targetPoint, point)
			
			local distance = math.abs((profile.hCruise - basePoint.h) * 7)												--distance to descend from cruise alt to base elevation with 8° pitch (make sure distance is positive)
			if distance >= GetDistance(basePoint, point) then															--descend distance bigger than distance to last WP
				distance = GetDistance(basePoint, point) / 3 * 2														--join point is 2/3 to last WP
			elseif distance < 15000 then																				--descend distance less than 15 km
				distance = 15000																						--split point should be at least 15 km from base
			end
			
			splitPoint = GetOffsetPoint(targetPoint, heading, distance)													--define split point
		end
		
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Taxi", alt = 0})
		table.insert(route, {x = basePoint.x, y = basePoint.y, id = "Departure", alt = basePoint.h + 1000})
		table.insert(route, {x = joinPoint.x, y = joinPoint.y, id = "Join", alt = profile.hCruise})
		table.insert(route, {x = splitPoint.x, y = splitPoint.y, id = "Split", alt = profile.hCruise})
		table.insert(route, {x = targetPoint.x, y = targetPoint.y, id = "Land", alt = profile.hCruise})
	end
	
	
	--measure lenght of complete route
	local route_lenght = 0
	for n = 1, #route - 1 do
		route_lenght = route_lenght + GetDistance(route[n], route[n + 1])
	end
	route.lenght = route_lenght
	
	
	--evauluate threat level of complete route
	do
		route.threats = {}																								--table to store threats for route
		
		--ground threats
		route.threats.ground = {}																						--table to store ground threats for route
		for alt,threat in pairs(groundthreats[enemy]) do																--iterate through all ground threat altitude bands (high/low)
			for t = 1, #threat do																						--iterate through all ground threats within altitude band
				for n = 1, #route - 1 do																				--iterate through all route segements
					local route_leg_alt
					if route[n].alt >= 3000 and route[n + 1].alt >= 3000 then
						route_leg_alt = "high"
					else
						route_leg_alt = "low"
					end
					if route_leg_alt == alt then																		--if route segement is in threat altitude band
						local distance = GetTangentDistance(route[n], route[n + 1], threat[t])							--distance of route segment to threat
						if distance < threat[t].range then																--if route segment is in range of threat
							if time == "day" or threat[t].night == true then											--during day or threat is night capable to be counted as threat							
								local adjusted_threat = threat[t].level - (threat[t].level / threat[t].range * distance)	--threat adjusted to distance to route leg
								if route.threats.ground[alt .. t] then													--if this ground threat already has a threat entry for this route
									if route.threats.ground[alt .. t].level < adjusted_threat then						--if the existing threat entry is lower than the new one
										route.threats.ground[alt .. t].level = adjusted_threat							--overwrite threat entry with new one
									end
								else																					--if this fighter unit has no threat entry for this route yet
									route.threats.ground[alt .. t] = {													--make new threat entry for this ground threat
										level = adjusted_threat,
										offset = threat[t].SEAD_offset
									}
								end
								if threat[t].class == "SAM" then														--threat is a SAM
									if route[n].SEAD_radius then														--waypoint has a SEAD radius entry
										if threat[t].range > route[n].SEAD_radius then									--find longest ranging threat that route segment penetrates
											route[n].SEAD_radius = threat[t].range										--store the range of the threat that route segment penetrates
										end
									else																				--waypoint has no SEAD radius entry
										route[n].SEAD_radius = threat[t].range											--store the range of the threat that route segment penetrates
									end
								end
							end
						end
					end
				end
			end
		end
		
		--air threats
		route.threats.air = {}																										--table to store air threats for route
		for t = 1, #fighterthreats[enemy] do																						--iterate through all fighter threats
			if fighterthreats[enemy][t].class == "CAP" or fighterthreats[enemy][t].class == "Intercept" then
				for n = 1, #route - 1 do																							--iterate through all route segements
					local route_leg_alt
					if route[n].alt >= 3000 and route[n + 1].alt >= 3000 then
						route_leg_alt = "high"
					else
						route_leg_alt = "low"
					end
					if GetTangentDistance(route[n], route[n + 1], fighterthreats[enemy][t]) < fighterthreats[enemy][t].range then	--if route segment is in range of fighter threat
						local ewr_required																							--boolean whether ewr is required for the fighter to be a threat
						if fighterthreats[enemy][t].class == "CAP" then																--if the fighter is CAP
							if route_leg_alt == "high" then																			--if route leg is at high altitude
								ewr_required = false																				--CAP does not need ewr to be a threat
							else																									--if route leg is at low altitude
								if fighterthreats[enemy][t].LDSD then																--if fighter is look down/shoot down capable
									ewr_required = false																			--CAP does not need ewr to be a threat
								else																								--if fighter is not look down/shoot down capable
									ewr_required = true																				--CAP needs ewr to be a threat
								end
							end
						elseif fighterthreats[enemy][t].class == "Intercept" then													--if the fighter is an interceptor
							ewr_required = true																						--ewr is required for fighter to be a threat (needs early warning to take off)
						end
						
						if ewr_required == true then																				--fighter needs ewr/awacs station to be a threat
							local break_loop = false
							for e = 1, #ewr[enemy][route_leg_alt] do																--iterate through all ewr/awacs
								if GetDistance(ewr[enemy][route_leg_alt][e], fighterthreats[enemy][t]) < ewr[enemy][route_leg_alt][e].range + fighterthreats[enemy][t].range then	--fighter operation area and ewr coverage are overlapping
									if GetTangentDistance(route[n], route[n + 1], fighterthreats[enemy][t]) < fighterthreats[enemy][t].range then				--if route leg is in range of fighter
										if GetTangentDistance(route[n], route[n + 1], ewr[enemy][route_leg_alt][e]) < ewr[enemy][route_leg_alt][e].range then	--if route leg is in range of ewr/awacs
											if route.threats.air[fighterthreats[enemy][t].name] then															--if this fighter unit already has a threat entry for this route
												if route.threats.air[fighterthreats[enemy][t].name].level < fighterthreats[enemy][t].level then					--if the existing threat entry is lower than the new one
													route.threats.air[fighterthreats[enemy][t].name].level = fighterthreats[enemy][t].level						--overwrite threat entry with new one
												end
											else																					--if this fighter unit has no threat entry for this route yet
												route.threats.air[fighterthreats[enemy][t].name] = {								--make new threat entry for this fighter unit
													level = fighterthreats[enemy][t].level,
												}
											end
											break_loop = true																		--two breaks would be required to break ewr loop and route loop
											break																					--ewr loop
										end
									end
								end
							end
							if break_loop == true then
								break																								--break route segemnt loop and go to next threat
							end
						else																										--no ewr is needed for fighter to be a threat
							if route.threats.air[fighterthreats[enemy][t].name] then												--if this fighter unit already has a threat entry for this route
								if route.threats.air[fighterthreats[enemy][t].name].level < fighterthreats[enemy][t].level then		--if the existing threat entry is lower than the new one
									route.threats.air[fighterthreats[enemy][t].name].level = fighterthreats[enemy][t].level			--overwrite threat entry with new one
								end
							else																									--if this fighter unit has no threat entry for this route yet
								route.threats.air[fighterthreats[enemy][t].name] = {												--make new threat entry for this fighter unit
									level = fighterthreats[enemy][t].level,
								}
							end
							break																									--break route segemnt loop and go to next threat
						end
					end
				end
			end
		end
		
		--combine route threats
		route.threats.SEAD_offset = 0																								--counter for SEAD sorties required to offset ground threats
		route.threats.ground_total = 0.5																							--cummulative route ground threat level (0.5 = no threat)
		route.threats.air_total = 0.5																								--cuumulative route air threat level (0.5 = no threat)

		for k,v in pairs(route.threats.ground) do																					--iterate through route ground threats
			route.threats.SEAD_offset = route.threats.SEAD_offset + v.offset														--collect combined SEAD offset
			route.threats.ground_total = route.threats.ground_total + v.level														--sum route ground threat levels
		end
		for k,v in pairs(route.threats.air) do																						--iterate through route air threats
			route.threats.air_total = route.threats.air_total + v.level																--sum route air threat levels
		end
	end
	
	return route
end


function GetEscortRoute(basePoint, orig_route)																					--get the escort route given the escort start point and an existing package route
	--make a local copy of the route table forwarded as function argument (otherwise the original route gets adjusted
	local route = deepcopy(orig_route)

	--adjust route for escort joining the package
	local split_distance = GetTangentDistance(route[3], route[4], basePoint)													--get the shortest distance from escort start point to package JoinPoint-Nav1/IP route leg
	if GetDistance(basePoint, route[3]) == split_distance then																	--if package Join Point is closest to escort start point
		route[1].x = basePoint.x																								--modify route to start at escort start point
		route[1].y = basePoint.y
		route[2].x = basePoint.x
		route[2].y = basePoint.y
	elseif GetDistance(basePoint, route[4]) == split_distance then																--if Nav1/IP is closest to escort start point
		route[1].x = basePoint.x																								--modify route to start at escort start point
		route[1].y = basePoint.y
		route[2].x = basePoint.x
		route[2].y = basePoint.y
		local mod_joinPoint = GetOffsetPoint(route[4], GetHeading(route[4], route[3]), 10)										--modify the Joint Point to be 10 km in front of Nav1/IP
		route[3].x = mod_joinPoint.x
		route[3].y = mod_joinPoint.y
	else																														--if a point between JoinPoint-Nav1/IP is closest to escort start point
		route[1].x = basePoint.x																								--modify route to start at escort start point
		route[1].y = basePoint.y
		route[2].x = basePoint.x
		route[2].y = basePoint.y
		local join_heading
		local heading1 = GetHeading(route[3], route[4])
		local heading2 = GetHeading(route[3], basePoint)
		if heading1 - heading2 > 180 then
			heading1 = heading1 - 360
		elseif heading2 - heading1 > 180 then
			heading2 = heading2 - 360
		end
		if heading1 <= heading2 then
			join_heading = heading1 - 90
		else
			join_heading = heading1 + 90
		end
		local mod_joinPoint = GetOffsetPoint(basePoint, join_heading, split_distance)											--modify the Joint Point to be between old Join Point and Nav1/IP
		route[3].x = mod_joinPoint.x
		route[3].y = mod_joinPoint.y
	end
	
	--adjust route for escort to leave the package
	local split_distance = GetTangentDistance(route[#route - 2], route[#route - 1], basePoint)									--get the shortest distance from escort land point to package Nav-Split route leg
	if GetDistance(basePoint, route[#route - 1]) == split_distance then															--if package Split Point is closest to escort land point
		route[#route].x = basePoint.x																							--modify route to end at escort land point
		route[#route].y = basePoint.y
	elseif GetDistance(basePoint, route[#route - 2]) == split_distance then														--if last Nav is closest to escort land point
		route[#route].x = basePoint.x																							--modify route to end at escort land point
		route[#route].y = basePoint.y
		local mod_splitPoint = GetOffsetPoint(route[#route - 2], GetHeading(route[#route - 2], route[#route - 1]), 10)			--modify the Split Point to be 10 km in front of last Nav
		route[#route - 1].x = mod_splitPoint.x
		route[#route - 1].y = mod_splitPoint.y
	else																														--if a point between last Nav and Split Point is closest to escort land point
		route[#route].x = basePoint.x																							--modify route to end at escort land point
		route[#route].y = basePoint.y
		local split_heading
		local heading1 = GetHeading(route[#route - 2], route[#route - 1])
		local heading2 = GetHeading(route[#route - 2], basePoint)
		if heading1 - heading2 > 180 then
			heading1 = heading1 - 360
		elseif heading2 - heading1 > 180 then
			heading2 = heading2 - 360
		end
		if heading1 <= heading2 then
			split_heading = heading1 - 90
		else
			split_heading = heading1 + 90
		end
		local mod_splitPoint = GetOffsetPoint(basePoint, split_heading, split_distance)											--modify the Split Point to be between last Nav and old Split Point
		route[#route - 1].x = mod_splitPoint.x
		route[#route - 1].y = mod_splitPoint.y
	end
	
	--measure lenght of complete route
	local route_lenght = 0
	for n = 1, #route - 1 do
		route_lenght = route_lenght + GetDistance(route[n], route[n + 1])
	end
	route.lenght = route_lenght
	
	
	return route
end