--ARM Defence Script
--by Marc "MBot" Marbot
--Version 21.12.2014
--This script gives radars a chance to detect anti-radar missiles launched against them and to shut down for self-preservation

do
	local function ARMShutDown(wpn)																				--Function to destroy the ARM
		if wpn ~= nil then
			wpn:destroy()
			--trigger.action.outText("Weapon shut down", 3)	--DEBUG
		end
	end
	
	local function RadarOn(ctrl)																				--Function to turn radar back on after a riding out the attack
		if ctrl ~= nil then
			ctrl:setOption(AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.AUTO)				--Turn radar on
			--trigger.action.outText("Radar On", 3)	--DEBUG
		end
	end

	local function RadarOff(arg)																				--Function to shut down radar of attacked unit/group
		local grp = arg[1]:getGroup()																			--Get group of attached unit (radar can only be turned off for whole group)
		if grp ~= nil then
			local ctrl = grp:getController()																	--Get controller of group
			ctrl:setOption(AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.GREEN)				--Turn off radar
			--trigger.action.outText("Radar Off", 3)	--DEBUG
			timer.scheduleFunction(RadarOn, ctrl, timer.getTime() + math.random(120, 240))						--Schedule turning radar back on in 2 to 4 minutes
			timer.scheduleFunction(ARMShutDown, arg[2], timer.getTime() + 5)									--weapon is destroyed after 5 seconds of radar shutting down (weapon must be destroyed because ARM in DCS continue to engage shut off radars). If weapon hits target within the 5 seconds, then this is to simulate to ARM scoring a ballistic hit.
		end
	end

	ARM_Shot_EventHandler = {}																					--Event handler to look for launched ARM
	function ARM_Shot_EventHandler:onEvent(event)
		if event.id == world.event.S_EVENT_SHOT then
			local wep = event.weapon																			--Get the weapon of the launch event
			local tgt = wep:getTarget()																			--Get the target of the weapon
			local desc = wep:getDesc()
			if desc.missileCategory == 6 and desc.guidance == 5 then											--Check if the weapon is an ARM
				--trigger.action.outText("ARM Launch", 3)	--DEBUG
				if math.random(1,10) > 1 then																	--90% chance that ARM launch is detected by target
					timer.scheduleFunction(RadarOff, {tgt, wep}, timer.getTime() + math.random(5, 15))			--Target reacts within 5 to 15 seconds after ARM launch with shutting down its radar
				end
			end
		end
	end
	world.addEventHandler(ARM_Shot_EventHandler)
end