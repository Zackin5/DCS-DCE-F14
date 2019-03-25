--To manually re-generate and replace the current campaign mission. For contingency only, not required for normal campaign play.
--Initiated by RedoMission.bat
------------------------------------------------------------------------------------------------------- 

----- random seed -----
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
math.random(); math.random(); math.random()


print("Skip current mission and generate next campaign mission. Continue? y(es)/n(o):\n")				--ask for user confirmation

local input																								--user input
repeat
	input = io.read()
	if input == "y" or input == "yes" or input == "n" or input == "no" then
		break
	else
		print("\n\nInvalid entry. Respond with y(es) or n(o):\n")
	end
until input == "y" or input == "yes" or input == "n" or input == "no"									--user input

if input == "y" or input == "y" then																	--user confirmed

	FirstMission = false																				--variable used during mission generation to make sure that mission is generated as first campaign mission 
	MissionInstance = 0
	
	print("\n\n")
	
	repeat
		print("Generating Next Mission.\n")
		
		MissionInstance = MissionInstance + 1															--count the number of times the mission is generated
		dofile("Status/camp_status.lua")
		dofile("Scripts/MAIN_NextMission.lua")															--generate mission (will replace current mission)
		
		if PlayerFlight then																			--mission has a player flight
			print("\n\nNext mission generated.\n")														--confirmation text
			break
		elseif MissionInstance == 50 then																--no player flight could be assigned in 50 tries, stop it
			print("Mission Generation Error. No eligible player flight in 50 attempts. Try again.\n\n")
			break
		else																							--no player flight could be assigned, advance time and try again
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
	until 1 == 2
end

os.execute 'pause'																					--pause command window for user to read text
os.exit()