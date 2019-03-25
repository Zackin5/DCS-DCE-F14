--To manually generate the first campaign mission and reset the campaign to initial status. For manual use by campaign designer only, not required for normal campaign play.
--Initiated by FirstMission.bat
------------------------------------------------------------------------------------------------------- 

----- random seed -----
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
math.random(); math.random(); math.random()


print("Reset the campaign and generate a new first mission.\n")

local input																								--user input
repeat
	print("Select number of players:\n1 - Singleplayer\n2 - Multiplayer\n3 - Multiplayer\n4 - Multiplayer\nq(uit)")
	input = io.read()
	
	if input == "1" or input == "2" or input == "3" or input == "4" then
		
		FirstMission = true																					--variable used during mission generation to make sure that mission is generated as first campaign mission 
		MissionInstance = 0
		
		print("\n\n")
		
		repeat
			print("Generating First Mission.\n")
		
			MissionInstance = MissionInstance + 1															--count the number of times the mission is generated
			dofile("Scripts/UTIL_ResetCampaign.lua")														--reset campaign status files. Required for first mission to generate according to initial status
			camp.coop = tonumber(input)																		--set amount of players
			dofile("Scripts/MAIN_NextMission.lua")															--generate mission
			
			if PlayerFlight then																			--mission has a player flight
				print("\nCampaign reset and first campaign mission re-generated.\n")						--confirmation text
				break
			elseif MissionInstance == 20 then																--no player flight could be assigned in 20 tries, stop it
				print("Mission Generation Error. No eligible player flight in 20 attempts. Try again.\n\n")
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
		break
	elseif input == "q" or input == "quit" then
		break
	else
		print("\nInvalid entry.\n")
	end
until 1 == 2

os.execute 'pause'																					--pause command window for user to read text
os.exit()