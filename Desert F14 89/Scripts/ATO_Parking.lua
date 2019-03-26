--
-- This script attempts to choose a unique parking id for aircraft at airbases in order to prevent spawn overlap. 
-- db_airbases must contain parkingIds values for each airport inorder for this script to work
--

function getParkingId(base)
	-- return nil if the airbase doesn't have a defined list of parkingIds
	if db_airbases[base].parkingIds == nil then
		return nil
	end
	
	-- initalize counters if needed
	if db_airbases[base].parkingIds.iPrefix == nil then
		db_airbases[base].parkingIds.iPrefix = 1
	end
	
	if db_airbases[base].parkingIds.parkingN == nil then
		db_airbases[base].parkingIds.parkingN = db_airbases[base].parkingIds[db_airbases[base].parkingIds.iPrefix].lower
	end

	if db_airbases[base].parkingIds[db_airbases[base].parkingIds.iPrefix] == nil then
		return nil
	end
		
	-- generate the id
	fullId = db_airbases[base].parkingIds[db_airbases[base].parkingIds.iPrefix].prefix .. db_airbases[base].parkingIds.parkingN
	
	-- increment the parking number
	db_airbases[base].parkingIds.parkingN = db_airbases[base].parkingIds.parkingN + 1
	
	-- roll over to the next parking prefix if needed
	if db_airbases[base].parkingIds.parkingN > db_airbases[base].parkingIds[db_airbases[base].parkingIds.iPrefix].upper then
		db_airbases[base].parkingIds.iPrefix = db_airbases[base].parkingIds.iPrefix + 1

		if db_airbases[base].parkingIds[db_airbases[base].parkingIds.iPrefix] ~= nil then
			db_airbases[base].parkingIds.parkingN = db_airbases[base].parkingIds[db_airbases[base].parkingIds.iPrefix].lower
		end
	end
	
	return fullId
end
