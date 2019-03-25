--Various debug file exports
--Initiated by MAIN_NextMission.lua (unless disabled there)
------------------------------------------------------------------------------------------------------- 

if camp.debug then
	--local sorties_str = "draft_sorties = " .. TableSerialization(draft_sorties, 0)		--this can take up to 30 seconds for parge missions, only activate if really needed
	--local sortiesFile = io.open("Debug/ATO_draft_sorties.lua", "w")
	--sortiesFile:write(sorties_str)
	--sortiesFile:close()


	local ato_str = "ATO = " .. TableSerialization(ATO, 0)
	local atoFile = io.open("Debug/ATO.lua", "w")
	atoFile:write(ato_str)
	atoFile:close()


	local ground_str = "groundthreats = " .. TableSerialization(groundthreats, 0)
	local air_str = "fighterthreats = " .. TableSerialization(fighterthreats, 0)
	local ewr_str = "ewr = " .. TableSerialization(ewr, 0)
	local threatFile = io.open("Debug/threat.lua", "w")
	threatFile:write(ground_str .. "\n\n" .. air_str .. "\n\n" .. ewr_str)
	threatFile:close()
	
	
	local available_str = "aircraft_availability = " .. TableSerialization(aircraft_availability, 0)
	local availableFile = io.open("Debug/AircraftAvailability.lua", "w")
	availableFile:write(available_str)
	availableFile:close()
end