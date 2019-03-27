# DCS-DCE-F14
A fork of Mbot's Dynamic Campaign Engine for DCS World. 

## Features

Currently features a port of the Desert 76' campaign for the F-14 Tomcat, with a few additional features:

- Aircraft properties initialization in oob_air_init.lua - allows for the mission designer to enable properties for spawned aircraft, eg INS alignment stored for the F-14
- Unique aircraft parking assigning (WIP) - prevents aircraft overlap by ensuring spawned aircraft get unique parking slots (note: may not actually be working)
- Smoke effects for destroyed targets - specific mission targets can spawn static smoke effects after their destruction on subsequent missions, adding to the mission atmosphere

## Modder instructions (WIP):

Aircraft properties can be defined using the properties tag on units listed in the oob_air_init.lua file, eg:

`properties = {
				["INSAlignmentStored"] = true,
			},`

In order for this to to work in other missions the ATO_Generator.lua script must be updated to assign it to the ATO object used by ATO_FlightPlan.lua, which in turn must be updated to assign the properties value to a unit's AddPropAircraft field:

`["AddPropAircraft"] = flight[f].properties,`

Parking Id selection is handled by the getParkingId function implemented in ATO_Parking.lua, which is called in the ATO_FlightPlan.lua script:

`["parking_id"] = getParkingId(flight[f].base),`

Review the [smoke fx](https://github.com/Zackin5/DCS-DCE-F14/pull/1/files) pull request for Smoke effects implementation. (TODO: embellish on this)