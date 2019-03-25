--To advance the campaign time for next mission
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 

--campaign day counter
if camp.day == nil then																			--if counter does not exist yet
	camp.day = 1																				--start counting with first day in campaign
end

--advance campaign time
local idle_time = math.random(camp.idle_time_min, camp.idle_time_max)							--random idle time to next mission in seconds, depending on min-max defined for campaign
camp.time = camp.time + idle_time																--add idle time to campaign time

while camp.time >= 86400 do																		--repeat as long as time 24 hours or more
	camp.time = camp.time - 86400																--remove 24 hours from time
	camp.date.day = camp.date.day + 1															--add a day to date
	if camp.date.day == 32 and (camp.date.month == 1 or camp.date.month == 3 or camp.date.month == 5 or camp.date.month == 7 or camp.date.month == 8 or camp.date.month == 10 or camp.date.month == 12) then	--month change for large months
		camp.date.day = 1																		--first day of next month
		camp.date.month = camp.date.month + 1													--advance month
	elseif camp.date.day == 31 and (camp.date.month == 4 or camp.date.month == 6 or camp.date.month == 9 or camp.date.month == 11) then	--month change for small months
		camp.date.day = 1																		--first day of next month
		camp.date.month = camp.date.month + 1													--advance month
	elseif camp.date.month == 30 and camp.date.month == 2 then									--month change for February
		camp.date.day = 1																		--first day of next month
		camp.date.month = camp.date.month + 1													--advance month
	end
	if camp.date.month == 13 then																--year change
		camp.date.month = 1																		--first month of next year
		camp.date.year = camp.date.year + 1														--advance year
	end
	camp.day = camp.day + 1																		--counter for campaign days
end

mission["start_time"] = camp.time																--set mission start time
mission["date"]["Day"] = camp.date.day															--set mission day
mission["date"]["Year"] = camp.date.year														--set mission year
mission["date"]["Month"] = camp.date.month														--set mission month

print(FormatTime(idle_time, "hh:mm") .. "h passed. Next mission scheduled at: " .. FormatTime(camp.time, "hh:mm") .. ", " .. camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year .. ".\n")

--determine mission time of day
daytime	= ""																					--variable what daytime the is covered in the duration of the mission
if camp.time >= camp.dawn and camp.time <= camp.dusk then										--current time is between dawn and dusk
	if camp.time + camp.mission_duration <= camp.dusk then										--mission duration ends before dusk
		daytime = "day"
	else																						--mission duration ends after dusk
		daytime = "day-night"
	end
else																							--current time is between dusk and dawn
	if camp.time < camp.dawn then																--mission starts before dawn
		if camp.time + camp.mission_duration < camp.dawn then									--mission duration ends before dawn
			daytime = "night"
		else
			daytime = "night-day"
		end
	else																						--mission starts after dusk
		if camp.time + camp.mission_duration < camp.dawn + 86400 then							--mission duration ends before dawn of next day
			daytime = "night"
		else
			daytime = "night-day"
		end
	end
end