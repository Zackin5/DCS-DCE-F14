--
-- This function attempts to create smoke effects for target elements with burn flags 
--

for side_name, side in pairs(targetlist) do														--Iterate through all sides
    
    -- initalize smoke group for side
    if mission.coalition[side_name].country[1].static == nil then
        mission.coalition[side_name].country[1].static = {
            group = {}
        }
    end

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
                    ["y"] = 0,
                    ["x"] = 0,
                    ["formation_template"] = "",
                    ["action"] = "",
                },
            },
        },
        ["units"] = 
        {
        },
        ["y"] = 0,
        ["x"] = 0,
        ["name"] = "Smoke_" .. side_name,
        ["linkOffset"] = false,
        ["dead"] = false,
    })

    -- add smoke effects for dead targets
    for target_name, target in pairs(side) do													--Iterate through all targets
        if target.elements ~= nil then

            -- add smoke effects
            for i, element in pairs(target.elements) do
                table.insert(mission.coalition[side_name].country[1].static.group[1].units, {
                        ["effectPreset"] = 4,
                        ["category"] = "Effects",
                        ["type"] = "big_smoke",
                        ["y"] = element.y,
                        ["x"] = element.x,
                        ["unitId"] = GenerateID(),
                        ["name"] = "smoke_" .. element.name:gsub("%s+", "_"),
                        ["effectTransparency"] = 1,
                        ["heading"] = 0,
                    })
            end
        end
    end
end