--Various functions
------------------------------------------------------------------------------------------------------- 

--function to turn a table into a string
function TableSerialization(t, i)
	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do																	--controls the indent for the current text line
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
		elseif type(v) == "function" then
			text = text .. v .. ",\n"
		elseif v == nil then
			text = text .. "nil,\n"
		end
	end
	tab = ""
	for n = 1, i do																		--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"														--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"													--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end


--function to make a deep copy of a table
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


--function to return heading between two vector2 points
function GetHeading(p1, p2)
	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y
	if (deltax > 0) and (deltay == 0) then
		return 0
	elseif (deltax > 0) and (deltay > 0) then
		return math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay > 0) then
		return 90
	elseif (deltax < 0) and (deltay > 0) then
		return 90 - math.deg(math.atan(deltax / deltay))
	elseif (deltax < 0) and (deltay == 0) then
		return 180
	elseif (deltax < 0) and (deltay < 0) then
		return 180 + math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay < 0) then
		return 270
	elseif (deltax > 0) and (deltay < 0) then
		return 270 - math.deg(math.atan(deltax / deltay))
	else
		return 0
	end
end


--function to return the angle between two headings
function GetDeltaHeading(h1, h2)
	local delta = h2 - h1
	if delta > 180 then
		delta = delta - 360
	elseif delta <= -180 then
		delta = delta + 360
	end
	return delta
end


--function to return distance between two vector2 points
function GetDistance(p1, p2)
	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y
	return math.sqrt(math.pow(deltax, 2) + math.pow(deltay, 2))
end


--function to return a new point offset from an initial point
function GetOffsetPoint(point, heading, distance)
	return {
		x = point.x + math.cos(math.rad(heading)) * distance,
		y = point.y + math.sin(math.rad(heading)) * distance
	}
end


--function to return closest distance of point p3 to the line p1 to p2
function GetTangentDistance(p1, p2, p3)
	local p1_p2_heading = GetHeading(p1, p2)
	local p1_p3_heading = GetHeading(p1, p3)
	local alpha = math.abs(p1_p2_heading - p1_p3_heading)
	if alpha > 180 then
		alpha = math.abs(alpha - 360)
	end
	local p1_p3_distance = GetDistance(p1, p3)
	
	local p2_p1_heading = GetHeading(p2, p1)
	local p2_p3_heading = GetHeading(p2, p3)
	
	local beta = math.abs(p2_p1_heading - p2_p3_heading)
	if beta > 180 then
		beta = math.abs(beta - 360)
	end
	local p2_p3_distance = GetDistance(p2, p3)
	
	if alpha > 90 or alpha < -90 then
		return p1_p3_distance
	elseif beta > 90 or beta < -90 then
		return p2_p3_distance
	elseif GetDistance(p1, p2) == 0 then
		return p1_p3_distance
	else
		return math.abs(math.sin(math.rad(alpha)) * p1_p3_distance)
	end
end


--function to return subsequent IDs
id_counter = 100000
function GenerateID()
	local id = id_counter
	id_counter = id_counter + 1
	return id
end


--function to return various date and time formats of a number in seconds
function FormatTime(t, form)
	local hour
	local minute
	local second
		
	hour = math.floor(t / 3600)
	t = t - hour * 3600
	if hour < 10 then
		hour = "0" .. hour
	end
	
	minute = math.floor(t / 60)
	t = t - minute * 60
	if minute < 10 then
		minute = "0" .. minute
	end
	
	second = math.floor(t)
	if second < 10 then
		second = "0" .. second
	end
	
	if form == "hh:mm" then
		return hour .. ":" .. minute
	elseif form == "hh:mm:ss" then
		return hour .. ":" .. minute .. ":" .. second
	end
end


--function to format date
function FormatDate(day, month, year)
	if month == 1 then
		month = "January"
	elseif month == 2 then
		month = "February"
	elseif month == 3 then
		month = "March"
	elseif month == 4 then
		month = "April"
	elseif month == 5 then
		month = "May"
	elseif month == 6 then
		month = "June"
	elseif month == 7 then
		month = "July"
	elseif month == 8 then
		month = "August"
	elseif month == 9 then
		month = "September"
	elseif month == 10 then
		month = "October"
	elseif month == 11 then
		month = "November"
	elseif month == 12 then
		month = "December"
	end
	
	return month .. " " .. day .. ", " .. year
end


--function to format altitude in metric or imperial measurement
function FormatDistance(a)
	a = a / 1000																			--round to km
	if camp.units == "metric" then															--metric units
		a = math.floor(a) .. " km"															--kilometers
	elseif camp.units == "imperial" then													--imperial units
		a = a * 0.539957																	--covert to nm
		a = math.floor(a) .. " nm"															--nautical miles
	end
	return a
end


--function to format altitude in metric or imperial measurement
function FormatAlt(a)
	if camp.units == "metric" then															--metric units
		a = math.ceil(a / 10) * 10															--round to tens
		if a <= 1000 then																	--for altitudes until 1000m
			a = a .. " m AGL"																--meters AGL
		else
			a = a .. " m MSL"																--meters MSL
		end
	elseif camp.units == "imperial" then													--imperial units
		a = a * 3.28																		--covert to feet
		a = math.ceil(a / 100) * 100														--round to hunderts
		if a <= 3300 then																	--for altitudes until 3300ft
			a = a .. " ft AGL"																--feet AGL
		else
			a = a .. " ft MSL"																--feet MSL
		end
	end
	return a
end


--function to format speed in metric or imperial measurement
function FormatSpeed(a)
	if camp.units == "metric" then															--metric units
		a = a * 3.6
		a = math.floor(a / 10) * 10															--round to tens
		a = a .. " kph"																		--km per hour
	elseif camp.units == "imperial" then													--imperial units
		a = a * 1.94																		--covert to knots
		a = math.floor(a / 5) * 5															--round to fives
		a = a .. " kts"																		--knots
	end
	return a
end