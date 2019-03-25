--To run at mission start to explode scenery objects destroyed in previous missions
--Script attached to base_mission.miz and executed via trigger
------------------------------------------------------------------------------------------------------- 

for k,v in pairs(oob_scen) do
	if v.x then														--if oob_scen entry has a x-coordinate stored, go ahead with explosion. If no position is stored, scen object was previously just hit but not destroyed.
		trigger.action.explosion(v, v.health0 / 2)					--explosion 1/2 as strong as health of scenery object
	end
end