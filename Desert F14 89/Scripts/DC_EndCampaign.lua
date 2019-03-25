--To delete mission content and prevent campaign progression if the campaign has ended
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 

if EndCampaign then												--if the campaign has ended
	PlayerFlight = true											--set true to stop mission generation loop in DEBRIEF_Master.lua
	
	if EndCampaign == "win" then
		mission.sortie = "CAMPAIGN VICTORY"
		mission.goals[1].score = 51
		mission.result.offline.actions[1] = 'a_set_mission_result(51)'
	elseif EndCampaign == "draw" then
		mission.sortie = "CAMPAIGN DRAW"
		mission.goals[1].score = 51
		mission.result.offline.actions[1] = 'a_set_mission_result(51)'
	elseif EndCampaign == "loss" then
		mission.sortie = "CAMPAIGN DEFEAT"
		mission.goals[1].score = 49
		mission.result.offline.actions[1] = 'a_set_mission_result(49)'
	end
	
	--remove mission triggers
	for x,v in pairs(mission.trig) do
		v = {}
	end
	mission.trigrules = {}
	
	--remove units
	for side_name,side in pairs(mission.coalition) do			--iterate through sides										
		for country_n,country in pairs(side.country) do			--iterate through contries
			country.ship = {}									--remove all ships
			country.vehicle = {}								--remove all vehicles
			country.plane = {}									--remove all planes
			country.static = {}									--remove all static
		end
	end
	
	mission.descriptionBlueTask = ""							--disable briefing
	mission.descriptionRedTask = ""								--disable briefing
end