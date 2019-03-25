--To run the campaign triggers. Evaluate trigger conditions, run trigger actions and append briefing text
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 

----- campaign flags -----
if camp.flag == nil then
	camp.flag = {}
end
local old_flag = deepcopy(camp.flag)												--copy campaign flags, so that modifications of flags do not affect condition of subsequent campaign triggers in same mission


----- functions to return campaign information to build trigger conditions -----
Return = {}

	--return the time of day in seconds
	function Return.Time()
		return camp.time
	end
	
	--return day of month
	function Return.Day()
		return camp.date.day
	end
	
	--return month as number
	function Return.Month()
		return camp.date.month
	end
	
	--return year
	function Return.Year()
		return camp.date.year
	end
	
	--return mission number
	function Return.Mission()
		return camp.mission
	end
	
	--return campagn flag
	function Return.CampFlag(arg)
		return old_flag[arg]													--return old_flag (unmodified by other campaign trigger in same mission)
	end
	
	--return if air unit is active
	function Return.AirUnitActive(name)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					if unit.inactive == true then
						return false
					else
						return true
					end
				end
			end
		end
	end
	
	--return number of ready aircraft for an air unit
	function Return.AirUnitReady(name)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					return unit.roster.ready									--return number of ready aircraft
				end
			end
		end
	end
	
	--return number of ready + damaged aircraft for an air unit
	function Return.AirUnitAlive(name)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					return unit.roster.ready + unit.roster.damaged				--return number of ready and damaged aircraft
				end
			end
		end
	end
	
	--return air unit base
	function Return.AirUnitBase(name)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					return unit.base											--return base
				end
			end
		end
	end
	
	--return air unit player
	function Return.AirUnitPlayer(name)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == name then										--unit found
					return unit.player											--return player
				end
			end
		end
	end
	
	--return alive percentage of target
	function Return.TargetAlive(targetname)
		for side_name,side in pairs(targetlist) do								--iterate through sides in targetlist
			for target_name,target in pairs(side) do							--iterate through targets in side
				if target_name == targetname then								--target found
					return target.alive											--return alive percentage of target
				end
			end
		end
	end


----- functions to buld trigger actions -----
Action = {}
	
	--void action
	function Action.None()
	end
	
	--add briefing text
	function Action.Text(arg)
		briefing_text = briefing_text .. arg .. "\\n\\n"						--add trigger text to briefing text of this mission instance
	end
	
	--add briefing picture
	function Action.AddImage(filename)
		table.insert(BriefingImages, filename)									--add filename to briefing images table, will be added to mission file when this gets created
	end
	
	--set campagn flag to value
	function Action.SetCampFlag(n, value)
		camp.flag[n] = value
	end
	
	--add or subtract to campaign flag
	function Action.AddCampFlag(n, add)
		camp.flag[n] = camp.flag[n] + add
	end
	
	--end campaign
	function Action.CampaignEnd(arg)
		EndCampaign = arg
	end
	
	--set target active/inactive
	function Action.TargetActive(targetName, state)
		if targetlist.blue[targetName] then
			if state == true then												--state argument is true
				targetlist.blue[targetName].inactive = false					--make inactive false
			elseif state == false then											--state argument is false
				targetlist.blue[targetName].inactive = true						--make inactive true
			end
		elseif targetlist.red[targetName] then
			if state == true then												--state argument is true
				targetlist.red[targetName].inactive = false						--make inactive false
			elseif state == false then											--state argument is false
				targetlist.red[targetName].inactive = true						--make inactive true
			end
		end
	end
	
	--set unit active/inactive
	function Action.AirUnitActive(unitName, state)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == unitName then									--unit found
					if state == true then										--state argument is true
						unit.inactive = false									--make inactive false
					elseif state == false then									--state argument is false
						unit.inactive = true									--make inactive true
					end
				end
			end
		end
	end
	
	--set unit base
	function Action.AirUnitBase(unitName, baseName)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == unitName then									--unit found
					unit.base = baseName										--set new airbase for unit
				end
			end
		end
	end
	
	--set unit playable
	function Action.AirUnitPlayer(unitName, state)
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == unitName then									--unit found
					unit.player = state											--set new playable state for unit
				end
			end
		end
	end
	
	--send reinforcement aircraft from one unit to another
	function Action.AirUnitReinforce(sourceName, destName, destNumber)
		local sourceUnit
		local destUnit
		local destSide
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				if unit.name == sourceName then									--source unit found
					sourceUnit = unit											--point source oob unit table to variable
				elseif unit.name == destName then								--desitination unit found
					destUnit = unit												--point destination oob unit table to variable	
					destSide = side_name										--store side
				end
			end
		end
		if destUnit.roster.ready < destNumber then								--destination ready number is below nominal number
			if sourceUnit.roster.ready > 0 then									--source unit has ready aircraft
				if math.random(1,2) == 2 then									--50% chance of reinforcements
					local maxtrans = destNumber - destUnit.roster.ready			--maximal number of transferable aircraft
					if maxtrans > 4 then										--limit maxtrans to 4 aircraft
						maxtrans = 4
					end
					if maxtrans > sourceUnit.roster.ready then
						maxtrans = sourceUnit.roster.ready
					end
					local trans = math.random(1, maxtrans)						--set random number of actual transferable aircraft
					destUnit.roster.ready = destUnit.roster.ready + trans		--transfer aircraft
					sourceUnit.roster.ready = sourceUnit.roster.ready - trans	--transfer aircraft
					local text
					if trans == 1 then
						text = "" .. trans .. " replacement " .. destUnit.type .. " has been transferred from " .. sourceName .. " to " .. destName .. ".\\n\\n"	--text to be added to briefing/oob
					else
						text = "" .. trans .. " replacement " .. destUnit.type .. " have been transferred from " .. sourceName .. " to " .. destName .. ".\\n\\n"	--text to be added to briefing/oob
					end
					if destSide == "blue" then									--side is blue
						briefing_oob_text_blue = briefing_oob_text_blue .. text	--add to blue briefing oob text
					elseif destSide == "red" then								--side is red
						briefing_oob_text_red = briefing_oob_text_red .. text	--add to red briefing oob text
					end
				end
			end
		end
	end
	
	--repair damaged aircraft in all air units
	function Action.AirUnitRepair()
		for side_name,side in pairs(oob_air) do									--iterate through sides in oob_air
			for unit_n,unit in pairs(side) do									--iterate through units in side
				local repair = 0												--number of repaired aircraft un this round
				for n = 1, unit.roster.damaged do								--iterate through all damaged aircraft
					if math.random(1,10) == 1 then								--10% chance of repair
						repair = repair + 1
					end
				end
				if repair > 0 then												--if aircraft are repaird in this round
					unit.roster.damaged = unit.roster.damaged - repair
					unit.roster.ready = unit.roster.ready + repair
					local text
					if repair == 1 then
						text = "" .. repair .. " damaged " .. unit.type .. " from ".. unit.name .. " has been repaired and returned back to service.\\n\\n"	--text to be added to briefing/oob
					else
						text = "" .. repair .. " damaged " .. unit.type .. " from ".. unit.name .. " have been repaired and returned back to service.\\n\\n"	--text to be added to briefing/oob
					end
					if side_name == "blue" then									--side is blue
						briefing_oob_text_blue = briefing_oob_text_blue .. text	--add to blue briefing oob text
					elseif side_name == "red" then								--side is red
						briefing_oob_text_red = briefing_oob_text_red .. text	--add to red briefing oob text
					end
				end
			end
		end
	end
	
	--add ground target intel updates to briefing
	function Action.AddGroundTargetIntel(side)
		if MissionInstance == 1 then											--ground target intel updates are only added in first mission instance (to avoid duplication)
			for target_name,target in pairs(targetlist[side]) do				--iterate through targets in side
				if target.alive and target.dead_last > 0 then					--ground target was hit in last mission
					if target.alive == 0 then									--target is dead
						briefing_text = briefing_text .. "Intel Update: " .. target_name .. " has been destroyed.\\n\\n"
					else														--target is still alive
						briefing_text = briefing_text .. "Intel Update: " .. target_name .. " has been reduced to " .. target.alive .. "%.\\n\\n"
					end
				end
			end
		end
	end
	

----- run campaign triggers -----
if FirstMission then															--for the first mission
	require("Init/camp_triggers_init")											--load initial campaign triggers
else																			--for all subsequent missions
	require("Status/camp_triggers")												--load current campaign triggers
end

--devine variables to persist across multiple mission generation attempts
if briefing_status == nil then													--if briefing status string does not exist yet it must be created
	briefing_status = ""														--text string to be added to briefing
	briefing_oob_text_red = ""													--text string to be added to next briefing (red repair and reinforcements)
	briefing_oob_text_blue = ""													--text string to be added to next briefing (blue repair and reinforcements)
end
if BriefingImages == nil then
	BriefingImages = {}															--global table to hold information about briefing images to be added to miz mission file
end

briefing_text = ""																--briefing text to be added this mission instance

--go through campaign triggers
for trigger_name,trigger in pairs(camp_triggers) do								--iterate through triggers
	if trigger.active then														--trigger is active
		local condition = loadstring("if " .. trigger.condition .." then return true end")	--make a function from the string condition
		if condition() then														--if the trigger condition is true
			if type(trigger.action) == "table" then								--multiple actions
				for i,action in ipairs(trigger.action) do
					local f = loadstring(action)()								--run the trigger action
				end
			else																--single action
				local f = loadstring(trigger.action)()							--run the trigger action
			end
			if trigger.once then												--trigger should only fire once
				trigger.active = false											--set trigger inactive
			end
		end
	end
end

--add date and time header for this mission instance briefing text
if briefing_text ~= "" then														--brefing text from this mission instance exists and should be added to briefing_status text
	briefing_status = briefing_status .. FormatDate(camp.date.day, camp.date.month, camp.date.year) .. ", " .. FormatTime(camp.time, "hh:mm") .. ":\\n\\n" .. briefing_text .. "\\n"		--add date and time, then add briefing text of this mission instance
end

--add pictures cumulated in all mission generations attempts
for n = 1, #BriefingImages do
	mapResource["ResKey_BriefingImage_" .. BriefingImages[n]] = BriefingImages[n]			--define key in mapResource file
	table.insert(mission.pictureFileNameB, "ResKey_BriefingImage_" .. BriefingImages[n])	--add picture to blue briefing
	table.insert(mission.pictureFileNameR, "ResKey_BriefingImage_" .. BriefingImages[n])	--add picture to red briefing
end