--To create the briefing for the next mission
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 

----- Mission Title -----
mission.sortie = camp.title .. " - " .. camp.mission


--Order of Battle
do
	local s = "Order of Battle:\\n\\n"																--make lists of the air order of battle for all sides
	
	--air units
	for side_name,side in pairs(oob_air) do															--iterate through sides in oob_air
		if side_name == "blue" then
			s = s .. "Blue Air Units:\\n"															--side header
		else
			s = s .. "Red Air Units:\\n"															--side header
		end
	
		--define list entries
		local entries = {
			[1] = {
				header = "Unit",
				values = {},
			},
			[2] = {
				header = "Type",
				values = {},
			},
			[3] = {
				header = "Base",
				values = {},
			},
			[4] = {
				header = "Lst",
				values = {},
			},
			[5] = {
				header = "Dm",
				values = {},
			},
			[6] = {
				header = "Rdy",
				values = {},
			},
		}
	
		--add list values
		for unit_n,unit in ipairs(side) do															--iterate through units
			if unit.inactive ~= true then															--unit is active
				table.insert(entries[1].values, unit.name)											--unit name
				table.insert(entries[2].values, unit.type)											--unit type
				table.insert(entries[3].values, unit.base)											--unit base
				table.insert(entries[4].values, unit.roster.lost)									--unit lost aircraft
				table.insert(entries[5].values, unit.roster.damaged)								--unit damaged aircraft
				table.insert(entries[6].values, unit.roster.ready)									--unit ready aircraft
			end
		end
		
		--determine maximum string length for each entry
		for e = 1, #entries do																		--iterate through entries
			entries[e].str_length = string.len(entries[e].header)									--store string length of header for this entry
			for n = 1, #entries[e].values do														--iterate through values of this entry
				local l = string.len(tostring(entries[e].values[n]))								--get string length of value of this entry
				if l > entries[e].str_length then													--if the string length is larger than the previous
					entries[e].str_length = l														--make it the new length (find the largest)
				end
			end
		end
		
		--build the list header
		for e = 1, #entries do																		--iterate through entries
			s = s .. entries[e].header																--add header
			if e < #entries then																	--if this is not the last header, add spaces to the next header	
				local space = entries[e].str_length + 3 - string.len(entries[e].header)				--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for m = 1, space * 1.5 do															
					s = s .. " "																	--add 1.5 spaces for every missing letter
				end
			end
		end
		s = s .. "\\n"
	
		--build the list		
		for n = 1, #entries[1].values do															--iterate through number of values (number of units)
			for e = 1, #entries do																	--iterate through entries
				s = s .. entries[e].values[n]														--add value to list
				if e < #entries then																--if this is not the last header, add spaces to the next header	
					local space = entries[e].str_length + 3 - string.len(tostring(entries[e].values[n]))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
					for m = 1, space * 1.5 do													
						s = s .. " "																--add 1.5 spaces for every missing letter
					end
				end
			end
			s = s .. "\\n"																			--make a new line after each unit
		end
		
		--add oob description text (reinforcements and repairs)
		if PlayerFlight and camp.player.side == side_name then										--only do it for player side
			if side_name == "blue" then
				if briefing_oob_text_blue ~= "" then
					s = s .. "\\n" .. briefing_oob_text_blue .. "\\n"
				else
					s = s .. "\\n\\n"
				end
			elseif side_name == "red" then
				if briefing_oob_text_red ~= "" then
					s = s .. "\\n" .. briefing_oob_text_red .. "\\n"
				else
					s = s .. "\\n\\n"
				end
			end
		else
			s = s .. "\\n\\n"																		--make a new line after each side
		end
	end
	
	
	--ground targets
	for side_name,side in pairs(targetlist) do														--iterate through sides in targetlist
		if side_name == "blue" then																	--owner of the target is the opposite of targetlist side
			s = s .. "Red Ground Assets:\\n"														--side header
		else
			s = s .. "Blue Ground Assets:\\n"														--side header
		end
		
		local sort_table = {}																		--array to sort the targetlist
		for k,v in pairs(side) do
			table.insert(sort_table, k)																--insert key into sort table
		end
		table.sort(sort_table)																		--sort the table
		for i, v in ipairs(sort_table) do															--iterate through sort table
			if side[v].inactive ~= true then														--target is active
				if side[v].alive then																--if target has an alive value it is a scenery, vehicle or ship target and should be listed
					s = s .. "- " .. v .. " (" .. math.ceil(side[v].alive) .. "%)\\n"				--add target name and alive percentage
				end
			end
		end
		s = s .. "\\n\\n"																			--make a new line after each side
	end
	
	
	--Assign briefing text to mission file
	mission.descriptionText = briefing_status .. s
end


--Air Tasking Order
if PlayerFlight then																			--if the mission has a player flight
	local s = "Air Tasking Order:\\n"
	
	--define list entries
	local entries = {
		[1] = {
			header = "Sorties",
			values = {},
		},
		[2] = {
			header = "Mission",
			values = {},
		},
		[3] = {
			header = "TOT",
			values = {},
		},
	}

	--add list values
	for pack_n,pack in pairs(ATO[camp.player.side]) do											--iterate through packages	
		--package sortie number
		local sortie_n = 0																		--number of aircraft (sorties) in package
		for role,flight in pairs(pack) do														--iterate through roles in package
			for n = 1, #flight do																--iterate through flights in role
				sortie_n = sortie_n + flight[n].number											--count number of aircraft
			end
		end
		table.insert(entries[1].values, sortie_n)												--number of sorties in package
		
		--package target
		table.insert(entries[2].values, pack.main[1].target_name)								--package target
		
		--package time on target
		local tot = FormatTime(camp.time + pack.main[1].route[1].eta, "hh:mm:ss")				--time on target (use first wapoint if no Target or Station WP is found below)
		for wp_n,wp in pairs(pack.main[1].route) do												--iterate through waypoints of first main flight
			if wp.id == "Target" or wp.id == "Station" then										--if wp is target or station
				tot = FormatTime(camp.time + wp.eta, "hh:mm:ss")								--make this the time on target			
			end
		end
		table.insert(entries[3].values, tot)													--package time on target
	end
	
	--determine maximum string length for each entry
	for e = 1, #entries do																		--iterate through entries
		entries[e].str_length = string.len(entries[e].header)									--store string length of header for this entry
		for n = 1, #entries[e].values do														--iterate through values of this entry
			local l = string.len(tostring(entries[e].values[n]))								--get string length of value of this entry
			if l > entries[e].str_length then													--if the string length is larger than the previous
				entries[e].str_length = l														--make it the new length (find the largest)
			end
		end
	end
	
	--build the list header
	for e = 1, #entries do																		--iterate through entries
		s = s .. entries[e].header																--add header
		if e < #entries then																	--if this is not the last header, add spaces to the next header	
			local space = entries[e].str_length + 3 - string.len(entries[e].header)				--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
			for m = 1, space * 1.5 do															
				s = s .. " "																	--add 1.5 spaces for every missing letter
			end
		end
	end
	s = s .. "\\n"

	--build the list		
	for n = 1, #entries[1].values do															--iterate through number of values (number of units)
		for e = 1, #entries do																	--iterate through entries
			s = s .. entries[e].values[n]														--add value to list
			if e < #entries then																--if this is not the last header, add spaces to the next header	
				local space = entries[e].str_length + 3 - string.len(tostring(entries[e].values[n]))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for m = 1, space * 1.5 do													
					s = s .. " "																--add 1.5 spaces for every missing letter
				end
			end
		end
		s = s .. "\\n"																			--make a new line after each unit
	end
	
	--Assign briefing text to mission file
	mission.descriptionText = mission.descriptionText .. s
end


----- Task Briefing -----
local briefing = ""


--Mission overview
if PlayerFlight then																							--if the mission has a player flight
	local s = "Mission:\\n"																						--add a description of the mission
	
	local target_name = camp.player.pack[camp.player.role][camp.player.flight].target_name						--get the target of the player flight
	local player_task = camp.player.pack[camp.player.role][camp.player.flight].task								--get the task of the player flight
	local target = camp.player.pack[camp.player.role][camp.player.flight].target								--get target table
	local time_start = FormatTime(camp.time + camp.player.group.route.points[1].ETA, "hh:mm:ss")				--player spawn time
	local time_launch
	if camp.player.group.route.points[2] then
		time_launch = FormatTime(camp.time + camp.player.group.route.points[2].ETA , "hh:mm:ss")				--player take off time
	end
	local time_target = FormatTime(camp.time + camp.player.group.route.points[camp.player.tgt_wp].ETA, "hh:mm:ss")		--player time on target
	
	--CAP
	if player_task == "CAP" then
		local time_station = FormatTime(camp.time + camp.player.group.route.points[camp.player.tgt_wp + 1].ETA, "hh:mm:ss")		--player time to leave stations (for CAP, AWACS and Refueling)
		s = s .. "You are tasked to perform a Combat Air Patrol " .. target.text .. " from " .. time_target .. " to " .. time_station .. ". Engage all hostile aircraft threatening friendly forces in your CAP area.\\n"
	
	--Intercept
	elseif player_task == "Intercept" then
		local airbase = camp.player.pack[camp.player.role][camp.player.flight].base
		local tgt_heading = GetHeading(camp.player.group.route.points[1], ATO[camp.player.tgt_side][camp.player.tgt_pack].main[1].route[1])
		local tgt_distance = GetDistance(camp.player.group.route.points[1], ATO[camp.player.tgt_side][camp.player.tgt_pack].main[1].route[1])
		local tgt_n = 0
		for role, flight in pairs (ATO[camp.player.tgt_side][camp.player.tgt_pack]) do
			for n = 1, #flight do
				tgt_n = tgt_n + flight[n].number
			end
		end
		s = s .. "You are assigned to ground alert intercept duty at " .. airbase .. ". Early warning radar has detected " .. tgt_n .. " targets inbound to your sector at " .. math.floor(tgt_heading) .. "°/" .. FormatDistance(tgt_distance) .. ". Launch imediately for interception.\\n"
	
	--Fighter Sweep
	elseif player_task == "Fighter Sweep" then
		s = s .. "You are tasked to perform a Fighter Sweep " .. target.text .. ". Your Time On Target is " .. time_target .. ".\\n"
	
	--Airbase Strike
	elseif player_task == "CAS" and target.class == "airbase" then
		s = s .. "You are tasked to strike " .. target.name .. " which hosts the " .. target.unit.name .. " equipped with " .. target.unit.type .. ". Attack any parked aircraft on the airbase. Your Time On Target is " .. time_target .. ".\\n"
	
	--Strike
	elseif player_task == "Ground Attack" or player_task == "Pinpoint Strike" or player_task == "CAS" then
		s = s .. "You are tasked to participate in a strike against the " .. target_name .. ". Your Time On Target is " .. time_target .. ".\\n"
		
	--Anti-ship Strike
	elseif player_task == "Anti-ship Strike" then
		s = s .. "You are tasked to participate in a strike against the " .. target_name .. ". Your Time On Target is " .. time_target .. ".\\n"
		
	--Escort
	elseif player_task == "Escort" then
		if target.class == "airbase" then
			s = s .. "Escort a strike mission against " .. target.name .. ". Engage all hostile aircraft posing a threat to the strike package. "
			s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck.\\n"
		elseif target.task == "Ground Attack" or target.task == "Pinpoint Strike" or target.task == "CAS" or target.task == "Anti-ship Strike" then 
			s = s .. "Escort a strike mission against the " .. target_name .. ". Engage all hostile aircraft posing a threat to the strike package. "
			s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck.\\n"
		elseif target.task == "Reconnaissance" then
			s = s .. "Escort a recon mission " .. target.text .. ". Engage all hostile aircraft posing a threat to the recon element. "
			s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck.\\n"
		end
	
	--SEAD
	elseif player_task == "SEAD" then
		if target.class == "airbase" then
			s = s .. "Provide SEAD escort for a strike mission against " .. target.name .. ". Engage all hostile air defense systems posing a threat to the strike package. "
			s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck.\\n"
		elseif target.task == "Ground Attack" or target.task == "Pinpoint Strike" or target.task == "CAS" or target.task == "Anti-ship Strike" then 
			s = s .. "Provide SEAD escort for a strike mission against the " .. target_name .. ". Engage all hostile air defense systems posing a threat to the strike package. "
			s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck.\\n"
		elseif target.task == "Reconnaissance" then
			s = s .. "Provide SEAD escort for a recon mission " .. target.text .. ". Engage all hostile air defense systems posing a threat to the recon element. "
			s = s .. "Man your aircraft at " .. time_start .. " and prepare to launch at " .. time_launch .. ". Your Time on Target is " .. time_target .. ". Good Luck.\\n"
		end
	
	--Reconnaissance
	elseif player_task == "Reconnaissance" then
		s = s .. "You are tasked to perform reconnaissance " .. target.text .. ". Your Time On Target is " .. time_target .. ".\\n"
	
	--AWACAS
	elseif player_task == "AWACS" then
		local time_station = FormatTime(camp.time + camp.player.group.route.points[camp.player.tgt_wp + 1].ETA, "hh:mm:ss")		--player time to leave stations (for CAP, AWACS and Refueling)
		s = s .. "You are tasked to perform a AWACS patrol " .. target.text .. " from " .. time_target .. " to " .. time_station .. ".\\n"
		
	--Refueling
	elseif player_task == "Refueling" then
		local time_station = FormatTime(camp.time + camp.player.group.route.points[camp.player.tgt_wp + 1].ETA, "hh:mm:ss")		--player time to leave stations (for CAP, AWACS and Refueling)
		s = s .. "You are tasked to perform tanker support " .. target.text .. " from " .. time_target .. " to " .. time_station .. ". Provide fuel to friendly aircraft in your patrol area.\\n"
	
	--Transport
	elseif player_task == "Transport" then
		s = s .. "Fly a transport mission from " .. target.base .. " to " .. target.destination .. ".\\n"
		
	--Nothing/Ferry
	elseif player_task == "Nothing" then
		s = s .. "Ferry flight from " .. target.base .. " to " .. target.destination .. ".\\n"
		
	end
	
	if targetlist[camp.player.side][target_name].elements then									--if the target is a scenery, vehicle or ship target
		s = s .. "\\nTarget:\\n" .. target_name .. " (" .. math.ceil(targetlist[camp.player.side][target_name].alive) .. "%)\\n"		--Target name and percentage of alive sub-elements 
		for e = 1, #targetlist[camp.player.side][target_name].elements do						--list all target elements
			s = s .. "- " .. targetlist[camp.player.side][target_name].elements[e].name
			if targetlist[camp.player.side][target_name].elements[e].dead == true then			--if the target element is destroyed
				s = s .. " (destroyed)\\n"														--mark as destroyed and make new line
			else
				s = s .. "\\n"																	--make new line
			end
		end
	end
	
	briefing = briefing .. s .. "\\n\\n"														--add mission overview string to briefing string
end


--Package overview
if PlayerFlight then																			--if the mission has a player flight
	local s = "Package:\\n"																		--make a list of the details of all flights in the player package
	
	local entries = {																			--list entries that are making up the package overview
		[1] = {
			lookup = "task",																	--lookup in the ATO flight table
			header = "Task",																	--name which should be displayer in the list header
			str_length = 4,																		--string length of largest entry of this type (default the string length of the header)
		},
		[2] = {
			lookup = "number",
			header = "Num",
			str_length = 3,
		},
		[3] = {
			lookup = "type",
			header = "Type",
			str_length = 4,
		},
		[4] = {
			lookup = "callsign",
			header = "Callsign",
			str_length = 8,
		},
		[5] = {
			lookup = "player",
			header = "",
			str_length = 0,
		},
	}

	--collect the maximum string length of each entry in the list
	for role_name,role in pairs(camp.player.pack) do											--iterate through roles in the player package
		for flight_n,flight in pairs(role) do													--iterate through the flights in all roles
			for e = 1, #entries do																--iterate through all entries
				local value
				if flight[entries[e].lookup] == "CAS" or flight[entries[e].lookup] == "Ground Attack" or flight[entries[e].lookup] == "Pinpoint Strike" then
					value = "Strike"
				else
					value = flight[entries[e].lookup]
				end
				local l = string.len(tostring(value))											--get the string length of the current entry for this flight
				if l > entries[e].str_length then												--if the string length is larger than the previous
					entries[e].str_length = l													--make it the new length (find the largest)
				end
			end
		end
	end
	
	--build the list header
	for e = 1, #entries do																		--iterate through all entries
		s = s .. entries[e].header																--add entry of this flight to list
		if e ~= #entries then																	--if this is not the last entry of the flight, add spaces to the next entry	
			local space = entries[e].str_length + 3 - string.len(tostring(entries[e].header))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
			for n = 1, space * 1.5 do															
				s = s .. " "																	--add 1.5 spaces for every missing letter
			end
		end
	end
	s = s .. "\\n"
	
	--build the overview list with the entries of all flights
	for role_name,role in pairs(camp.player.pack) do											--iterate through roles in the player package	
		for flight_n,flight in pairs(role) do													--iterate through flights in all roles
			for e = 1, #entries do																--iterate through all entries
				if type(flight[entries[e].lookup]) == "string" or type(flight[entries[e].lookup]) == "number" then	--entry is a string or number
					local value
					if flight[entries[e].lookup] == "CAS" or flight[entries[e].lookup] == "Ground Attack" or flight[entries[e].lookup] == "Pinpoint Strike" then
						value = "Strike"
					else
						value = flight[entries[e].lookup]
					end
					s = s .. value																--add entry of this flight to list
					if e ~= #entries then																			--if this is not the last entry of the flight, add spaces to the next entry	
						local space = entries[e].str_length + 3 - string.len(tostring(value))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
						for n = 1, space * 1.5 do													
							s = s .. " "														--add 1.5 spaces for every missing letter
						end
					end
				elseif flight[entries[e].lookup] then											--entry is true (player marking)
					s = s .. "(Player)"															--add player flight marking
				end
			end
			s = s .. "\\n"																		--make a new line after each flight
		end
	end
	briefing = briefing .. s .. "\\n\\n"														--add package overview string to briefing string
end


--Navigation overview
if PlayerFlight then																			--if the mission has a player flight
	local s = "Navigation:\\n"																	--make a list with details of the player waypoints
	
	local entries = {																			--list entries that are making up the navigaion overview
		[1] = {
			lookup = "number",																	--lookup in the camp.player.group.route.points table
			header = "WP",																		--name which should be displayer in the list header
			str_length = 2,																		--string length of largest entry of this type (default the string length of the header)
		},
		[2] = {
			lookup = "briefing_name",
			header = "Descr",
			str_length = 5,
		},
		[3] = {
			lookup = "alt",
			header = "Altitute",
			str_length = 8,
		},
		[4] = {
			lookup = "speed",
			header = "Speed",
			str_length = 5,
		},
		[5] = {
			lookup = "ETA",
			header = "ETA",
			str_length = 3,
		},
	}
	
	--collect the maximum string length of each entry in the list	
	for w = 1, #camp.player.group.route.points do												--iterate through the waypoints
		for e = 1, #entries do																	--iterate through all entries
			local entry																			--lookup of entry e of WP w
			if entries[e].lookup == "ETA" then
				entry = FormatTime(camp.time + camp.player.group.route.points[w][entries[e].lookup], "hh:mm:ss")	--format the time in the hh:mm:ss format
			elseif entries[e].lookup == "alt" then
				entry = FormatAlt(camp.player.group.route.points[w][entries[e].lookup])			--format altitude in meters or feet
			elseif entries[e].lookup == "speed" then
				entry = FormatSpeed(camp.player.group.route.points[w][entries[e].lookup])		--format speed in kph or kts
			else
				entry = camp.player.group.route.points[w][entries[e].lookup]					--no special formating
			end
			local l = string.len(tostring(entry))												--get the string length
			if l > entries[e].str_length then													--if the string length is larger than the previous
				entries[e].str_length = l														--make it the new length (find the largest)
			end
		end
	end
	
	--build the list header
	for e = 1, #entries do																		--iterate through all entries
		s = s .. entries[e].header																--add entry of this waypoint to list
		if e ~= #entries then																	--if this is not the last entry of the waypoints, add spaces to the next entry	
			local space = entries[e].str_length + 3 - string.len(tostring(entries[e].header))	--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
			for n = 1, space * 1.5 do															
				s = s .. " "																	--add 1.5 spaces for every missing letter
			end
		end
	end
	s = s .. "\\n"
	
	--build the overview list with the entries of all waypoints
	for w = 1, #camp.player.group.route.points do												--iterate through all waypoints
		for e = 1, #entries do																	--iterate through all entries
			local entry
			if entries[e].lookup == "ETA" then
				if camp.player.group.route.points[w].name == "Take Off" then
					entry = FormatTime(camp.time + camp.player.group.route.points[w][entries[e].lookup] + 720, "hh:mm:ss")	--format the time in the hh:mm:ss format, add additional 720 seconds start up for actual take off time
				else
					entry = FormatTime(camp.time + camp.player.group.route.points[w][entries[e].lookup], "hh:mm:ss")	--format the time in the hh:mm:ss format
				end
			elseif entries[e].lookup == "alt" then
				entry = FormatAlt(camp.player.group.route.points[w][entries[e].lookup])			--format altitude in meters or feet
			elseif entries[e].lookup == "speed" then
				entry = FormatSpeed(camp.player.group.route.points[w][entries[e].lookup])		--format speed in kph or kts
			else
				entry = camp.player.group.route.points[w][entries[e].lookup]					--no special formating
			end
			s = s .. entry
			if e ~= #entries then																--if this is not the last entry of the waypoint, add spaces to the next entry	
				local space = entries[e].str_length + 3 - string.len(tostring(entry))			--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
				for n = 1, space * 1.5 do														
					s = s .. " "																--add 1.5 spaces for every missing letter
				end
			end
		end
		s = s .. "\\n"																			--make a new line after each waypoint
	end
	briefing = briefing .. s .. "\\n\\n"														--add navigation overview string to briefing string
end


--Communication
if PlayerFlight then																			--if the mission has a player flight
	local s = "Communication:\\n"																--overview of relevant comms frequencies
	
	camp.player.group["units"][1]["Radio"] = {													--create the radio channels table for the player aircraft
		[1] = {
			["channels"] = {}
		},
	}
	
	local AWACS_freq = {}																		--table to store AWACS frequencies
	local tanker_freq = {}																		--table to store tanker frequencies
	local EWR_freq = {}																			--table to store EWR frequencies
	
	for pack_n,pack in pairs(ATO[camp.player.side]) do											--iterate through packages in player side
		for role_name,role in pairs(pack) do													--iterate through roles in package													--iterate through the flights in role
			if role[1] and role[1].task == "AWACS" then											--if first flight is AWACS
				AWACS_freq[role[1].callsign] = role[1].frequency								--store callsign and frequency
			elseif role[1] and role[1].task == "Refueling" then									--if first flight is tanker
				tanker_freq[role[1].callsign] = role[1].frequency								--store callsign and frequency
			end
		end
	end
	
	for ewr_n,ewr in pairs(ewr[camp.player.side].high) do										--iterate through EWR on player side
		if ewr.frequency and ewr.callsign then													--if EWR has a freqency and callsign
			if tonumber(ewr.frequency) ~= tonumber(camp.player.EWR_freq) then					--do not store EWR if it is the one that is controlling the player in intercept (it will be put on package channel 1)
				EWR_freq[ewr.callsign] = ewr.frequency											--store callsign and frequency
			end
		end
	end
	
	--build list
	if camp.player.EWR_freq and camp.player.EWR_call then										--if the player is on intercept
		s = s .. "GCI: " .. camp.player.group.frequency .. " MHz, Callsign " .. camp.player.EWR_call .. ",   "		--GCI frequency
	else
		s = s .. "Package: " .. camp.player.group.frequency .. " MHz,   "						--package frequency
	end
	table.insert(camp.player.group["units"][1]["Radio"][1]["channels"], tonumber(camp.player.group.frequency))	--insert frequency to radio channel table
	s = s .. "Channel " .. #camp.player.group["units"][1]["Radio"][1]["channels"] .. "\\n"		--add channel number to briefing
		
	s = s .. camp.player.pack[camp.player.role][camp.player.flight].base .. ": " .. db_airbases[camp.player.pack[camp.player.role][camp.player.flight].base].ATC_frequency .. " MHz,   "	--ATC frequency
	table.insert(camp.player.group["units"][1]["Radio"][1]["channels"], tonumber(db_airbases[camp.player.pack[camp.player.role][camp.player.flight].base].ATC_frequency))	--insert frequency to radio channel table
	s = s .. "Channel " .. #camp.player.group["units"][1]["Radio"][1]["channels"] .. "\\n"		--add channel number to briefing
		
	for call,freq in pairs(AWACS_freq) do
		s = s .. "AWACS: " .. freq .. " MHz, " .. call .. ",   "								--AWACS frequency
		table.insert(camp.player.group["units"][1]["Radio"][1]["channels"], tonumber(freq))		--insert frequency to radio channel table
		s = s .. "Channel " .. #camp.player.group["units"][1]["Radio"][1]["channels"] .. "\\n"	--add channel number to briefing
	end
	for call,freq in pairs(EWR_freq) do
		s = s .. "EWR: " .. freq .. " MHz, Callsign " .. call .. ",   "							--EWR frequency
		table.insert(camp.player.group["units"][1]["Radio"][1]["channels"], tonumber(freq))		--insert frequency to radio channel table
		s = s .. "Channel " .. #camp.player.group["units"][1]["Radio"][1]["channels"] .. "\\n"	--add channel number to briefing
	end
	for call,freq in pairs(tanker_freq) do
		s = s .. "Tanker: " .. freq .. " MHz, " .. call .. ",   "								--Tanker frequency
		table.insert(camp.player.group["units"][1]["Radio"][1]["channels"], tonumber(freq))		--insert frequency to radio channel table
		s = s .. "Channel " .. #camp.player.group["units"][1]["Radio"][1]["channels"] .. "\\n"	--add channel number to briefing
	end
	
	briefing = briefing .. s .. "\\n\\n"
end


--Meteo
if PlayerFlight then																			--if the mission has a player flight
	local s = "Meteo:\\n"																		--overview of Weather
	
	local remain = math.ceil((camp.weather.zoneEnd - ((camp.day - 1) * 86400 + camp.time)) / 3600)	--hours until end of weather zone
	local duration = math.ceil((camp.weather.zoneEnd - camp.weather.zoneStart) / 3600)			--duration of the weather zone in hours
	local passed = 100 / duration * remain														--percentage of zone passage
	
	if camp.weather.zone == "high" then
		if mission.weather["enable_fog"] == false then
			s = s .. "Good flying weather due to influence of a high pressure system in theater of operations"
			if remain < 6 then
				s = s .. ". Change of general weather situation imminent. "
			elseif remain < 25 then
				s = s .. ", expected to remain in effect for next " .. remain .. " hours. "
			elseif remain < 48 then
				s = s .. ", expected to remain dominant for another day. "
			else
				s = s .. ", expected to remain dominant for next " .. math.floor(remain / 24) .. " days. "
			end
		else
			s = s .. "Ground fog conditions. "
		end
		
	elseif camp.weather.zone == "low front cold" then
		s = s .. "Low pressure system dominating theater of operations. Currently poor flying weather due to passage of cold front. Weather improvement expected within next " .. remain .. " hours. "
		
	elseif camp.weather.zone == "low front warm" then
		s = s .. "Low pressure system dominating theater of operations. "
		if passed < 50 then
			s = s .. "Currently increasingly poor flying weather due to the passage of warm front. Expected to clear up after " .. remain .. " hours. "
		else
			s = s .. "Weather expected to deteriorate within next " .. remain .. " hours due to approach of warm front. "
		end
		
	elseif camp.weather.zone == "low sector cold" then
		s = s .. "Low pressure system dominating theater of operations. Currently fair flying weather in cold sector"
		if remain < 6 then
			s = s .. ". Change of general weather situation imminent. "
		elseif remain < 25 then
			s = s .. ", expected to remain in effect for next " .. remain .. " hours. "
		elseif remain < 48 then
			s = s .. ", expected to remain stable for another day. "
		else
			s = s .. ", expected to remain stable for next " .. math.floor(remain / 24) .. " days. "
		end
		
	elseif camp.weather.zone == "low sector warm" then
		s = s .. "Low pressure system dominating theater of operations. Currently fair flying weather in warm sector"
		if remain < 6 then
			s = s .. ". Change of general weather situation imminent. "
		elseif remain < 25 then
			s = s .. ", expected to remain in effect for next " .. remain .. " hours. "
		elseif remain < 48 then
			s = s .. ", expected to remain stable for another day. "
		else
			s = s .. ", expected to remain stable for next " .. math.floor(remain / 24) .. " days. "
		end
		
	end
	
	briefing = briefing .. s .. "\\n\\n" .. METAR
end


--Assign briefing text to mission file
mission.descriptionBlueTask = briefing
mission.descriptionRedTask = briefing