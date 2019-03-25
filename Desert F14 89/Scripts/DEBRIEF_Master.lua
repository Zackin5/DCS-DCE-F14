--To evaluate the DCS debrief.log, update the campaign status files/OOBs, generate a debriefing and initiate generation of next campaign mission
--Initiated by MissionEnd.lua running from within DCS
------------------------------------------------------------------------------------------------------- 

----- random seed -----
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
math.random(); math.random(); math.random()


--load functions
require("Scripts/UTIL_Functions")


--load mission export files
local logExport = loadfile("MissionEventsLog.lua")()											--mission events log
local scenExport = loadfile("scen_destroyed.lua")()												--destroyed scenery objects
local campExport = loadfile("camp_status.lua")()												--camp_status


--load status file to be updated
require("Init/db_airbases")																		--load db_airbases
require("Status/oob_air")																		--load air oob
require("Status/oob_ground")																	--load ground oob
require("Status/targetlist")																	--load targetlist
require("Status/clientstats")																	--load clientstats


--run log evaluation and status updates
require("Scripts/DEBRIEF_StatsEvaluation")
require("Scripts/DC_UpdateTargetlist")


--update campaign time
local elapsed_time = math.floor(events[#events].t - events[1].t)								--mission runtime in seconds
camp.time = camp.time + elapsed_time															--add mission time to campaign time


--create and view debriefing file for mission
require("Scripts/DEBRIEF_Text")																	--In this script the actual text is created. Script loaded after oob modifications above have been made.
local debriefFile = io.open("Debriefing/Debriefing " .. camp.mission .. ".txt", "w")			--create new debriefing file
debriefFile:write(debriefing)																	--write debriefing text into file (variable debriefing comes from DEBRIEF_Text.lua)
debriefFile:close()
os.execute('start "Debriefing" "notepad.exe" "Debriefing/Debriefing ' .. camp.mission .. '.txt"')	--open the debriefing file with notepad


--ask for input to save results and continue with campaign or disregard the last mission
print("\nAccept mission results and continue with campaign? y(es)/n(o):\n")						--ask for user confirmation
local input																						--user input

repeat
	input = io.read()
	if input == "y" or input == "yes" or input == "n" or input == "no" then
		break
	else
		print("\n\nInvalid entry. Respond with y(es) or n(o):\n")
	end
until input == "y" or input == "yes" or input == "n" or input == "no"

print("\n\n")

if input == "y" or input == "yes" then
	
	--save new data (remaining files are updated in MAIN_NextMission.lua)
	local client_str = "clientstats = " .. TableSerialization(clientstats, 0)					--make a string
	local clientFile = io.open("Status/clientstats.lua", "w")									--open clientstats file
	clientFile:write(client_str)																--save new data
	clientFile:close()

	local scen_str = "oob_scen = " .. TableSerialization(oob_scen, 0)							--make a string
	local scenFile = io.open("Status/oob_scen.lua", "w")										--open oob_scen file
	scenFile:write(scen_str)																	--save new data
	scenFile:close()
	
	--increase campaign mission number
	camp.mission = camp.mission + 1	
	
	--generate next campaign mission
	briefing_status = ""																		--text string to be added to next briefing (status reports are amended for each mission generation attempt until mission is succesfully generated)
	briefing_oob_text_red = ""																	--text string to be added to next briefing (red repair and reinforcements)
	briefing_oob_text_blue = ""																	--text string to be added to next briefing (blue repair and reinforcements)
	PlayerFlight = false																		--variable to control mission generation loop
	
	MissionInstance = 0
	repeat
		print("Generating Next Mission.\n")
	
		MissionInstance = MissionInstance + 1													--count the number of times the mission is generated
		dofile("Scripts/MAIN_NextMission.lua")													--generate next mission
		
		if PlayerFlight then																	--mission has a player flight
			print("Mission Generated.\n")
			break
		elseif MissionInstance == 50 then														--no player flight could be assigned in 50 tries, stop it
			print("Mission Generation Error. No eligible player flight in 50 attempts. Start a new campaign.\n\n")
			break
		else																					--no player flight could be assigned, advance time and try again
			if playability_criterium.active_unit == nil then
				print("Player unit is not active.\n\n")
			elseif playability_criterium.base == nil then
				print("Player airbase is not operational.\n\n")
			elseif playability_criterium.ready_aircraft == nil then
				print("Player unit has no ready aircraft.\n\n")
			elseif playability_criterium.tot == nil then
				print("Player aircraft type cannot operate at this time of day.\n\n")
			elseif playability_criterium.target == nil then
				print("No eligible mission available for player.\n\n")
			elseif playability_criterium.target_firepower == nil then
				print("Not enough ready aircraft for this mission.\n\n")
			elseif playability_criterium.weather == nil then
				print("Player aircraft type cannot operate in this weather.\n\n")
			elseif playability_criterium.target_range == nil then
				print("No eligible mission available for player.\n\n")
			elseif playability_criterium.coop == nil then
				print("Not enough ready aircraft for all clients.\n\n")
			elseif playability_criterium.intercept == nil then
				print("Ground alert intercept duty without launch.\n\n")
			end
		end
	until 1 == 2																				--repeat until the next mission is ready (has a player flight)
	
	os.execute 'pause'
end

--delete mission export files
os.remove("MissionEventsLog.lua")	--DISABLE FOR DEBUG
os.remove("scen_destroyed.lua")		--DISABLE FOR DEBUG
os.remove("camp_status.lua")		--DISABLE FOR DEBUG

os.exit()