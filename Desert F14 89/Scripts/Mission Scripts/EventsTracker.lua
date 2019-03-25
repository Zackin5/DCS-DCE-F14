--To run during mission to track destroyed static objects and trigger debriefing actions on mission end 
--Script attached to base_mission.miz and executed via trigger
--Requires DCS os and io functions sanitizer to be deactivated
------------------------------------------------------------------------------------------------------- 

local function TableSerialization(t, i)											--function to turn a table into a string
	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do															--controls the indent for the current text line
		tab = tab .. "\t"
	end
	for k,v in pairs(t) do
		if type(k) == "string" then
			text = text .. tab .. "['" .. k .. "'] = "
		else
			text = text .. tab .. "[" .. k .. "] = "
		end
		if type(v) == "string" then
			text = text .. "'" .. v .. "',\n"
		elseif type(v) == "number" then
			text = text .. v .. ",\n"
		elseif type(v) == "table" then
			text = text .. TableSerialization(v, i + 1)
		elseif type(v) == "boolean" then
			if v == true then
				text = text .. "true,\n"
			else
				text = text .. "false,\n"
			end
		end
	end
	tab = ""
	for n = 1, i do																--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"												--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"											--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end

local customLog = {}

EventHandler = {}
function EventHandler:onEvent(event)

	--custom events log
	local log_entry = {
		t = timer.getTime()
	}
	if event.id == world.event.S_EVENT_SHOT then
		log_entry.type = "shot"
	elseif event.id == world.event.S_EVENT_HIT then
		log_entry.type = "hit"
	elseif event.id == world.event.S_EVENT_TAKEOFF then
		log_entry.type = "takeoff"
	elseif event.id == world.event.S_EVENT_LAND then
		log_entry.type = "land"
	elseif event.id == world.event.S_EVENT_CRASH then
		log_entry.type = "crash"
	elseif event.id == world.event.S_EVENT_EJECTION then
		log_entry.type = "eject"
	elseif event.id == world.event.S_EVENT_REFUELING then
		log_entry.type = "refueling"
	elseif event.id == world.event.S_EVENT_DEAD then
		log_entry.type = "dead"
	elseif event.id == world.event.S_EVENT_PILOT_DEAD then
		log_entry.type = "pilot dead"
	elseif event.id == world.event.S_EVENT_BASE_CAPTURED then
		log_entry.type = "base captured"
	elseif event.id == world.event.S_EVENT_MISSION_START then
		log_entry.type = "mission start"
	elseif event.id == world.event.S_EVENT_MISSION_END then
		log_entry.type = "mission end"
	elseif event.id == world.event.S_EVENT_TOOK_CONTROL then
		log_entry.type = "took control"
	elseif event.id == world.event.S_EVENT_REFUELING_STOP then
		log_entry.type = "refueling stop"
	elseif event.id == world.event.S_EVENT_BIRTH then
		log_entry.type = "birth"
	elseif event.id == world.event.S_EVENT_HUMAN_FAILURE then
		log_entry.type = "human failure"
	elseif event.id == world.event.S_EVENT_ENGINE_STARTUP then
		log_entry.type = "engine startup"
	elseif event.id == world.event.S_EVENT_ENGINE_SHUTDOWN then
		log_entry.type = "engine shutdown"
	elseif event.id == world.event.S_EVENT_PLAYER_ENTER_UNIT then
		log_entry.type = "player enter unit"
	elseif event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT then
		log_entry.type = "player leave unit"
	end
	
	if (log_entry.type == "hit" and event.initiator) or log_entry.type ~= "hit" then
		if event.initiator then
			log_entry.initiator = event.initiator:getName()
			if event.initiator:getCategory() == Object.Category.UNIT then
				log_entry.initiatorPilotName = event.initiator:getPlayerName()
			end
			if event.initiator:getCategory() ~= Object.Category.SCENERY then
				log_entry.initiatorMissionID = event.initiator:getID()
			end
		end
		if event.target then
			log_entry.target = event.target:getName()
			if event.target:getCategory() == Object.Category.UNIT then
				log_entry.targetPilotName = event.target:getPlayerName()
			end
			if event.target:getCategory() ~= Object.Category.SCENERY then
				log_entry.targetMissionID = event.target:getID()
			end
		end
		table.insert(customLog, log_entry)
	end
	
	
	--mission end
	if event.id == world.event.S_EVENT_MISSION_END then
		
		--export custom mission log
		local logStr = "events = " .. TableSerialization(customLog, 0)
		local logFile = io.open(camp.path .. "MissionEventsLog.lua", "w")
		logFile:write(logStr)
		logFile:close()
		
		--export data for destroyed static objects (this is not tracked in DCS's debrief.log)
		local scenDescr = "--Destroyed scenery objects\n\n"
		local scenStr = "oob_scen = " .. TableSerialization(oob_scen, 0)
		local scenFile = io.open(camp.path .. "scen_destroyed.lua", "w")
		scenFile:write(scenDescr .. scenStr)
		scenFile:close()
		
		--export camp stats file
		local campStr = "camp = " .. TableSerialization(camp, 0)
		local campFile = io.open(camp.path .. "camp_status.lua", "w")
		campFile:write(campStr)
		campFile:close()
		
		--prepare campaign path for use by windows command line
		local path,count = string.gsub(camp.path, "/", "\\")					--replace slashes in campaign path with double-backslashes and count the number of slashes in campaign path
		local r_path = ""														--reverse path
		for n = 1, count do
			r_path = r_path .. "..\\"
		end
	
		--If this was the first campaign mission, launch external LUA environment and reset the campaign status files
		if FirstMission then
			os.execute('start "Reset Stats" cmd "cd /c ' .. path .. ' & ' .. r_path .. 'bin\\luae.exe Scripts\\UTIL_ResetCampaign.lua & exit"')
			--os.execute('start "Reset Stats" cmd /k "cd ' .. path .. ' & ' .. r_path .. 'bin\\luae.exe Scripts\\UTIL_ResetCampaign.lua"')	--keep window open for debug
		end
		
		--Launch external LUA environment to evaluate debrief.log, update campaign status files and generate the next campaign mission
		os.execute('start "Debriefing" cmd /k "cd ' .. path .. ' & ' .. r_path .. 'bin\\luae.exe Scripts\\DEBRIEF_Master.lua & exit"')
	
	--collect destroyed scenery objects
	elseif event.id == world.event.S_EVENT_HIT then
		if event.target and event.initiator then
			if event.target:getCategory() == 5 then								--if target is a scenery object
				local descr = event.target:getDesc()
				if descr.life and descr.life > 20 then							--only store destroyed scenery that had an initial health bigger than 20
					oob_scen[event.target:getName()] = {						--add scenery object to table
						health0 = descr.life,									--store initial health of scenery object
						lasthit = event.initiator:getName(),					--store who hit the scenery object
					}
				end
			end
		end	
	elseif event.id == world.event.S_EVENT_DEAD then
		if event.initiator then
			if event.initiator:getCategory() == 5 then							--if initiator is a scenery object
				if oob_scen[event.initiator:getName()] then
					local initPoint = event.initiator:getPoint()				--get point of dead scenery object
					oob_scen[event.initiator:getName()].x = initPoint.x
					oob_scen[event.initiator:getName()].y = initPoint.y
					oob_scen[event.initiator:getName()].z = initPoint.z
				end
			end
		end
	end
end
world.addEventHandler(EventHandler)