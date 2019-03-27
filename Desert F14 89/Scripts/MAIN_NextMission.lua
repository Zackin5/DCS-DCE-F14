--To generate a new mission file. Unzips template mission, defines content of next missions and packs a new mission file
--Initiated by Debrief_Master.lua, BAT_FirstMission.lua or BAT_RedoMission.lua
------------------------------------------------------------------------------------------------------- 

----- unpack template mission file ----
local minizip = require('minizip')

local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

zipFile:unzLocateFile('mission')
local misStr = zipFile:unzReadAllCurrentFile()
local misStrFunc = loadstring(misStr)()

zipFile:unzLocateFile('options')
local optStr = zipFile:unzReadAllCurrentFile()
local optStrFunc = loadstring(optStr)()

zipFile:unzLocateFile('warehouses')
local warStr = zipFile:unzReadAllCurrentFile()
local warStrFunc = loadstring(warStr)()

zipFile:unzLocateFile('l10n/DEFAULT/dictionary')
local dicStr = zipFile:unzReadAllCurrentFile()
local dicStrFunc = loadstring(dicStr)()

zipFile:unzLocateFile('l10n/DEFAULT/mapResource')
local resStr = zipFile:unzReadAllCurrentFile()
local resStrFunc = loadstring(resStr)()

zipFile:unzClose()


----- prepare triggers to run files in mission -----
local trig_n = 0
local function AddFileTrigger(filename)
	trig_n = trig_n + 1
	mapResource["ResKey_Action_" .. trig_n] = filename
	mission.trig.func[trig_n] = 'if mission.trig.conditions[' .. trig_n .. ']() then mission.trig.actions[' .. trig_n .. ']() end'
	mission.trig.flag[trig_n] = true
	mission.trig.conditions[trig_n] = 'return(c_time_after(1) )'
	mission.trig.actions[trig_n] = 'a_do_script_file(getValueResourceByKey("ResKey_Action_' .. trig_n .. '")); mission.trig.func[' .. trig_n .. ']=nil;'
	mission.trigrules[trig_n] = {
		['rules'] = {
			[1] = {
				['coalitionlist'] = 'red',
				['seconds'] = 1,
				['predicate'] = 'c_time_after',
				['zone'] = '',
			},
		},
		['eventlist'] = '',
		['comment'] = 'Trigger ' .. trig_n,
		['predicate'] = 'triggerOnce',
		['actions'] = {
			[1] = {
				['file'] = 'ResKey_Action_' .. trig_n,
				['predicate'] = 'a_do_script_file',
				['ai_task'] = {
					[1] = '',
					[2] = '',
				},
			},
		},
	}
end

AddFileTrigger("oob_scen.lua")
AddFileTrigger("DestroyScenery.lua")
AddFileTrigger("FirstMission.lua")
AddFileTrigger("EventsTracker.lua")
AddFileTrigger("camp_status.lua")
AddFileTrigger("GCIdata.lua")
AddFileTrigger("GCIscript.lua")
AddFileTrigger("ARM_Defence_Script.lua")
AddFileTrigger("CustomAttackScript.lua")


----- run scripts to create content of next mission -----
require("Scripts/UTIL_Functions")

require("Init/db_loadouts")
require("Init/db_airbases")

require("Status/oob_air")
require("Status/oob_ground")
require("Status/targetlist")

dofile("Scripts/DC_MissionScore.lua")
dofile("Scripts/DC_Time.lua")
dofile("Scripts/DC_Weather.lua")
dofile("Scripts/DC_UpdateOOBGround.lua")
dofile("Scripts/DC_UpdateTargetlist.lua")
dofile("Scripts/DC_CheckTriggers.lua")

dofile("Scripts/ATO_ThreatEvaluation.lua")
dofile("Scripts/ATO_RouteGenerator.lua")
dofile("Scripts/ATO_Generator.lua")
dofile("Scripts/ATO_PlayerAssign.lua")
dofile("Scripts/ATO_Timing.lua")
dofile("Scripts/ATO_Parking.lua")
dofile("Scripts/ATO_FlightPlan.lua")

dofile("Scripts/DC_StaticAircraft.lua")
dofile("Scripts/DC_Briefing.lua")
dofile("Scripts/DC_Prune.lua")
dofile("Scripts/DC_SmokeFx.lua")

dofile("Scripts/DC_EndCampaign.lua")

dofile("Scripts/UTIL_Debug.lua")


----- convert tables back to strings for insertion into content files -----
local misStr = "mission = " .. TableSerialization(mission, 0)
local optStr = "options = " .. TableSerialization(options, 0)
local warStr = "warehouses = " .. TableSerialization(warehouses, 0)
local dicStr = "dictionary = " .. TableSerialization(dictionary, 0)
local resStr = "mapResource = " .. TableSerialization(mapResource, 0)
local gciStr = "GCI = " .. TableSerialization(GCI, 0)
local cmpStr = "camp = " .. TableSerialization(camp, 0)


----- create temporary content files of new mission file -----
local misFile = io.open("misFile.lua", "w")											--mission
misFile:write(misStr)
misFile:close()

local optFile = io.open("optFile.lua", "w")											--options
optFile:write(optStr)
optFile:close()

local warFile = io.open("warFile.lua", "w")											--warehouses
warFile:write(warStr)
warFile:close()

local dicFile = io.open("dicFile.lua", "w")											--dictionary
dicFile:write(dicStr)
dicFile:close()

local resFile = io.open("resFile.lua", "w")											--mapResource
resFile:write(resStr)
resFile:close()

local gciFile = io.open("GCIdata.lua", "w")											--GCI data file (EWR radars, AWACS, interceptors)
gciFile:write(gciStr)
gciFile:close()

local firstFile = io.open("firstFile.lua", "w")										--file to store the FirstMission variable and upload it into the mission 
firstFile:write("FirstMission = " .. tostring(FirstMission))						--variable FirstMission is true if this is the first campaign mission, otherwise nil
firstFile:close()

local cmpFile = io.open("Status/camp_status.lua", "w")								--campaign status file
cmpFile:write(cmpStr)
cmpFile:close()


----- create new mission file and add content files -----
if FirstMission then																--is true if script is launched from GenerateFirstMission.lua
	miz = minizip.zipCreate("../" .. camp.title .. "_first.miz")					--create the first campaign mission
else																				--is false if script is launched from Debrief_Master.lua
	miz = minizip.zipCreate("../" .. camp.title .. "_ongoing.miz")					--create the ongoing campaign mission
end
miz:zipAddFile("mission", "misFile.lua")
miz:zipAddFile("options", "optFile.lua")
miz:zipAddFile("warehouses", "warFile.lua")
miz:zipAddFile("l10n/DEFAULT/dictionary", "dicFile.lua")
miz:zipAddFile("l10n/DEFAULT/mapResource", "resFile.lua")
miz:zipAddFile("l10n/DEFAULT/oob_scen.lua", "Status/oob_scen.lua")
miz:zipAddFile("l10n/DEFAULT/DestroyScenery.lua", "Scripts/Mission Scripts/DestroyScenery.lua")
miz:zipAddFile("l10n/DEFAULT/EventsTracker.lua", "Scripts/Mission Scripts/EventsTracker.lua")
miz:zipAddFile("l10n/DEFAULT/GCIdata.lua", "GCIdata.lua")
miz:zipAddFile("l10n/DEFAULT/GCIscript.lua", "Scripts/Mission Scripts/GCIscript.lua")
miz:zipAddFile("l10n/DEFAULT/ARM_Defence_Script.lua", "Scripts/Mission Scripts/ARM_Defence_Script.lua")
miz:zipAddFile("l10n/DEFAULT/CustomAttackScript.lua", "Scripts/Mission Scripts/CustomAttackScript.lua")
miz:zipAddFile("l10n/DEFAULT/FirstMission.lua", "firstFile.lua")
miz:zipAddFile("l10n/DEFAULT/camp_status.lua", "Status/camp_status.lua")
for i,filename in ipairs(BriefingImages) do											--briefing images to be added to mission file
	miz:zipAddFile("l10n/DEFAULT/" .. filename, "Images/" .. filename)
end
miz:zipClose()


----- remove temporary content files -----
os.remove("misFile.lua")
os.remove("optFile.lua")
os.remove("warFile.lua")
os.remove("dicFile.lua")
os.remove("resFile.lua")
os.remove("firstFile.lua")
os.remove("GCIdata.lua")


----- save updated status files  -----
local air_str = "oob_air = " .. TableSerialization(oob_air, 0)								--make a string
local airFile = io.open("Status/oob_air.lua", "w")											--open oob air file
airFile:write(air_str)																		--save new data
airFile:close()

local ground_str = "oob_ground = " .. TableSerialization(oob_ground, 0)						--make a string
local groundFile = io.open("Status/oob_ground.lua", "w")									--open oob ground file
groundFile:write(ground_str)																--save new data
groundFile:close()

local tgt_str = "targetlist = " .. TableSerialization(targetlist, 0)						--make a string
local tgtFile = io.open("Status/targetlist.lua", "w")										--open targetlist file
tgtFile:write(tgt_str)																		--save new data
tgtFile:close()

local trigStr = "camp_triggers = " .. TableSerialization(camp_triggers, 0)
local trigFile = io.open("Status/camp_triggers.lua", "w")
trigFile:write(trigStr)
trigFile:close()