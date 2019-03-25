--To provide custom AI Attack Tasks 
--Script attached to mission and executed via trigger
--Functions accessed via LUA Run Script on waypoint
------------------------------------------------------------------------------------------------------- 

--custom functions to allow all aircraft in a flight to attack multiple ground targets simultenously

----- attack multiple static objects -----
function CustomStaticAttack(FlightName, TargetList, expend, weaponType)
	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights
	for n = 1, #wingman do											--iterate through all aircraft in flight
		
		local cntrl 
		if n == 1 then												--for leader
			cntrl = flight:getController()							--get controller of group
		else														--for wingmen
			cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
			cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
		end
		
		local ComboTask = {											--define combo task to hold multiple attack tasks
			id = 'ComboTask',
			params = {
				tasks = {},
			},
		}
		
		for t = 1, #TargetList do									--iterate thourgh targets
		
			--each wingman gets one attack task for each target
			--wingman 1 attacks target 1,2,3 
			--wingman 2 attacks 2,3,1
			--wingman 3 attacks 3,1,2 etc.
			
			local num = t + n - 1								
			while num > #TargetList do
				num = num - #TargetList
			end
		
			if StaticObject.getByName(TargetList[num]) then							--make sure that static object still exists
				local TargetID = StaticObject.getByName(TargetList[num]):getID()	--get static object ID

				local task_entry = {												--define attack task
					["enabled"] = true,
					["auto"] = false,
					["id"] = "AttackUnit",
					["number"] = #ComboTask.params.tasks + 1,
					["params"] = 
					{
						["unitId"] = TargetID,
						["expend"] = expend,
						["weaponType"] = weaponType,
						["groupAttack"] = true,
					},
				}
				table.insert(ComboTask.params.tasks, task_entry)
			end
		end
		cntrl:pushTask(ComboTask)									--push task to front of task list
	end
end


----- attack multiple map objects -----
function CustomMapObjectAttack(FlightName, TargetList, expend, weaponType)
	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights
	for n = 1, #wingman do											--iterate through all aircraft in flight
		
		local cntrl 
		if n == 1 then												--for leader
			cntrl = flight:getController()							--get controller of group
		else														--for wingmen
			cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
			cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
		end
		
		local ComboTask = {											--define combo task to hold multiple attack tasks
			id = 'ComboTask',
			params = {
				tasks = {},
			},
		}
		
		for t = 1, #TargetList do									--iterate thourgh targets
		
			--each wingman gets one attack task for each target
			--wingman 1 attacks target 1,2,3 
			--wingman 2 attacks 2,3,1
			--wingman 3 attacks 3,1,2 etc.
			
			local num = t + n - 1								
			while num > #TargetList do
				num = num - #TargetList
			end

			local task_entry = {												--define attack task
				["enabled"] = true,
				["auto"] = false,
				["id"] = "AttackMapObject",
				["number"] = #ComboTask.params.tasks + 1,
				["params"] = 
				{
					["x"] = TargetList[num].x,
					["y"] = TargetList[num].y,
					["expend"] = expend,
					["weaponType"] = weaponType,
					["groupAttack"] = true,
				},
			}
			table.insert(ComboTask.params.tasks, task_entry)
		end
		cntrl:pushTask(ComboTask)									--push task to front of task list
	end
end