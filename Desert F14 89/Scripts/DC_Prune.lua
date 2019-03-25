--
-- Pruning can improve the performance of the mission by removing units that are very unlikely to participate in it.
--
-- In particular this varies depending on.
--		- Whether the unit is an anti-air unit (of various types) or not.
--		- How close any flight passes to the unit when that flight is flying along the waypoints.
--		- Whether that unit is close to any 'Target' or 'Attack' waypoint 
--

-- How aggressive should the pruning be [0 to 2], larger numbers will remove more units, 0 = no pruning at all
local pruneAggressiveness = 1.5

-- Should all parked (static) aircraft be pruned
local pruneStatic = true

-- work out which side has 'players'
local function findPlayerSide()
	for side,units in pairs(oob_air) do
		for ui,unit in pairs(units) do
			if unit.player then return side end 
		end 
	end 
	return nil
end

local playerSide = findPlayerSide()

-- given a unit return the anti-air type of an unit: SHORT, MEDIUM, LONG, IR, AAA or NONE.
local function unitAntiAirType(unit)
	-- List reduced from https://forums.eagle.ru/showthread.php?t=174971
	local types = { 
		["2S6 Tunguska"]="MEDIUM",	-- 12km
		["Tor 9A331"]="MEDIUM",		-- 12km
		["Strela-10M3"]="IR",		-- 5km
		["Strela-1 9P31"]="IR",		-- 5km
		["SA-8 Osa LD 9T217"]="SHORT",	-- 7km
		["Gepard"]="AAA",				-- 5km
		["SA-18 Igla manpad"]="IR",		-- 5km
		["Igla manpad INS"]="IR",		-- 5km
		["SA-18 Igla-S manpad"]="IR",	-- 5km
		["Vulcan"]="AAA",				-- 2.5km
		["M48 Chaparral"]="IR",			-- 9km
		["M6 Linebacker"]="IR",  		-- 8km
		["M1097 Avenger"]="IR",			-- 7km
		["Stinger manpad GRG"]="IR",	-- 8km
		["Stinger manpad dsr"]="IR",	-- 8km
		["Stinger manpad"]="IR",		-- 8km
		["ZSU-23-4 Shilka"]="SHORT",			-- 2.5km
		["ZU-23 Emplacement Closed"]="AAA",		-- 2.0km
		["ZU-23 Emplacement"]="AAA",			-- 2.0km
		["ZU-23 Closed Insurgent"]="AAA",		-- 2.0km
		["Ural-375 ZU-23 Insurgent"]="AAA",		-- 2.0km
		["ZU-23 Insurgent"]="AAA",				-- 2.0km
		["Ural-375 ZU-23"]="AAA",				-- 2.0km
		["1L13 EWR"]="LONG",					-- EWR: 200km
		["Kub 1S91 str"]="MEDIUM",				-- 25.0 km
		["S-300PS 40B6M tr"]="LONG",			-- 100km
		["S-300PS 40B6MD sr"]="LONG",			-- 100km
		["55G6 EWR"]="LONG",					-- 200km
		["S-300PS 64H6E sr"]="LONG",			-- 100km
		["SA-11 Buk SR 9S18M1"]="LONG",			-- 100km
		["Dog Ear radar"]="SHORT",				-- 5km
		["Hawk tr"]="LONG",						-- 50km
		["Hawk sr"]="LONG",						-- 50km
		["Patriot str"]="LONG",					-- 150km
		["Hawk cwar"]="LONG",					-- 50km
		["p-19 s-125 sr"]="MEDIUM",				-- 35km
		["Roland Radar"]="SHORT",				-- 8km
		["snr s-125 tr"]="MEDIUM",				-- 35km
	}
	local got = types[unit.type]
	return (got or "NONE")
end

local function stringStarts(str, start)
   return string.sub(str,1,string.len(start))==start
end

-- iterate through all consecutive pairs of waypoints
function waypointPairs(wps, f)
	local wi = 1
	while (wps[wi]) do
		local wp = wps[wi]
		local nextWi = wi + 1 
		local found = false 
		while (wps[nextWi]) do
			local np = wps[nextWi]
			if (np.x ~= wp.x) or (np.y ~= wp.y) then
				found = true
				wi = nextWi
				f(wp, np)
				break
			end				
			nextWi = nextWi + 1
		end
		if not found then return end
	end 
end 

-- decides whether the given ground unit (which is on side 'unitSide') should be kept or not
local function keepGroundUnit(unit, unitSide, allWaypoints) 
	if pruneStatic and unit.category == 'Planes' and unitSide == playerSide and stringStarts(unit.name, 'Static') then
		return false -- don't keep static planes
	end 
	local aaType = unitAntiAirType(unit)

	-- decides which aircraft waypoints we want to check against, we really don't care if enemy planes fly over enemy defenses.
	local otherSide = (unitSide == "blue") and "red" or "blue"
	local checkSides = unitSide == playerSide and { unitSide, otherSide } or { otherSide }	-- if unit is same side as player check both, else just check enemy
		
	-- for other types of unit it depends on distance to waypoints 
	local closestWP     = 100000000
	local closestTarget = 100000000	
	for csi,side in pairs(checkSides) do 
		for wpi,wps in pairs(allWaypoints[side]) do 
			waypointPairs(wps, function (wp1, wp2) 
				-- calculate the distance between the unit and the closest point along the two waypoints		
				local dist = GetTangentDistance(wp1, wp2, unit)
				closestWP = math.min(closestWP, dist)		
				 
				-- if this is a 'target' waypoint then record that distance as well
				if wp1.name == 'Target' or wp1.name == 'Attack' then
					local dist = GetDistance(wp1, unit)
					closestTarget = math.min(closestTarget, dist)				
				end 
				if wp2.name == 'Target' or wp2.name == 'Attack' then 
					local dist = GetDistance(wp2, unit)
					closestTarget = math.min(closestTarget, dist)				
				end 
			end)
		end
	end
	
	-- depending on the closest distance (and unit type) decide if we want to keep this unit
	local range = { 
		["LONG"] = 400000.0, ["MEDIUM"] = 80000, ["SHORT"] = 30000, 
		["AAA"] = 15000.0, ["IR"] = 20000.0, ["NONE"] = 10000.0 
	}
	local rfactor = math.min(math.max(pruneAggressiveness, 0), 3)
	local keep = closestWP*rfactor <= range[aaType] or closestTarget*rfactor <= 25000
	--[[
	print("Unit " .. unit.type .. " AA=" .. aaType .. " closestWP " .. closestWP .. " closestTarget " .. 
			closestTarget .. " Keep = " .. (keep and "KEEP" or "PRUNE"))
	--]]
	return keep
end 

-- decides whether the given air unit should be kept or not
local function keepAirUnit(unit, side)
	return not pruneStatic or not stringStarts(unit.name, 'Static')
end

-- Get all the waypoints for all (flying) units for all countries
local function getAllWaypoints()
	local allWaypoints = {}
	for si, side in pairs(mission.coalition) do 
		local sideWaypoints = {}
		for ci, country in pairs(side.country) do
			if country.plane then 
				for gi, grp in pairs(country.plane.group) do
					table.insert(sideWaypoints, grp.route.points)				
				end
			end 
			if country.helicopter then
				for gi, grp in pairs(country.plane.helicopter) do
					table.insert(sideWaypoints, grp.route.points)				
				end
			end 
		end
		allWaypoints[si] = sideWaypoints
	end
	return allWaypoints
end

-- Get all the ground units in the mission that could be pruned
local function pruneUnits(groundFun, airFun)
	local totalPruned = 0
	local totalKept = 0

	-- prune all the units in a given group (e.g. 'vehicle' or 'static')
	local pruneInGroup = function (container, side, fun)		
		if container and container.group and container then
			local newGroup = {}
			for gi, grp in pairs(container.group) do 					
				if grp.units then 	
					-- either the whole group survives (if any unit in it survives), or the whole group is removed.
					local saved = false
					for ui, unit in pairs(grp.units) do
						saved = saved or fun(unit, side)
					end
					if not saved then
						totalPruned = totalPruned + #grp.units
					else 
						totalKept = totalKept + #grp.units
						table.insert(newGroup, grp)
					end
				end
			end
			container.group = newGroup
		end 
	end 

	for si, side in pairs(mission.coalition) do 
		for ci, country in pairs(side.country) do
			pruneInGroup(country.vehicle, si, groundFun)
			pruneInGroup(country.static, si, groundFun)
			pruneInGroup(country.plane, si, airFun)
			pruneInGroup(country.helicopter, si, airFun)
		end
	end	
	print("Pruned " .. totalPruned .. ", kept " .. totalKept)
end

local function prune()
	-- get the waypoints for all air units in the mission.
	local allWaypoints = getAllWaypoints()

	-- prune the required ground and air units 
	pruneUnits(
		function (unit, side) return keepGroundUnit(unit, side, allWaypoints) end,
		function (unit, side) return keepAirUnit(unit, side) end 
	)
end

prune()
