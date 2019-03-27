--
-- This script attempts to create smoke effects for target elements with burn flags 
--

for side_name, side in pairs(targetlist) do														--Iterate through all sides
    for target_name, target in pairs(side) do													--Iterate through all targets
        if target.elements ~= nil then
            for i, element in pairs(target.elements) do
                --Check if the target is dead and has a burnTime
                if element.dead == true and element.burnTime ~= nil and element.burnTime > 0 then

                    -- Decrement the target's burntime
                    element.burnTime = element.burnTime - camp.time_since_last_mission

                    --Only create smoke for targets with coordinates and a remaining burn time
                    if element.x ~= nil and element.burnTime > 0 then      
                        -- initalize static group for side if needed
                        if mission.coalition[side_name].country[1].static == nil then
                            mission.coalition[side_name].country[1].static = {
                            }
                        end
                        
                        if mission.coalition[side_name].country[1].static.group == nil then
                            mission.coalition[side_name].country[1].static.group = {
                            }
                        end
                        
                        
                        -- create static smoke effects in mission
                        table.insert(mission.coalition[side_name].country[1].static.group, {
                            ["heading"] = 0,
                            ["route"] = 
                            {
                                ["points"] = 
                                {
                                    [1] = 
                                    {
                                        ["alt"] = 0,
                                        ["type"] = "",
                                        ["name"] = "",
                                        ["speed"] = 0,
                                        ["y"] = element.y,
                                        ["x"] = element.x,
                                        ["formation_template"] = "",
                                        ["action"] = "",
                                    },
                                },
                            },
                            ["groupId"] = GenerateID(),
                            ["units"] = 
                            {
                                [1] = 
                                {
                                    ["effectPreset"] = element.burnEffectPreset or 1,
                                    ["category"] = "Effects",
                                    ["type"] = "big_smoke",
                                    ["y"] = element.y,
                                    ["x"] = element.x,
                                    ["unitId"] = GenerateID(),
                                    ["name"] = "Smoke_" .. element.name:gsub("%s+", "_"),
                                    ["effectTransparency"] = 1,
                                    ["heading"] = 0,
                                }
                            },
                            ["y"] = element.y,
                            ["x"] = element.x,
                            ["name"] = "Smoke_" .. element.name:gsub("%s+", "_"),
                            ["linkOffset"] = false,
                            ["dead"] = false,
                            ["hidden"] = true,
                        })
                    end
                end
            end
        end
    end
end