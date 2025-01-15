local module = {}

module.language = "en"
module.scale = 1
module.dblclick = 0.3

function module.save()
    local success, message = love.filesystem.write(
        "settings",
        "language " .. module.language .. "\nscale " .. module.scale .. "\ndblclick " .. module.dblclick .. "\n"
    )
    if not success then
        print(message)
    end
end

function module.load()
    if love.filesystem.getInfo("settings") then
        for line in love.filesystem.lines("settings") do
            for param, val in line:gmatch("(%w+)%s+(%S+)") do
                if param == "language" then
                    if val == "ru" or val == "en" then
                        module.language = val
                    end
                elseif param == "scale" then
                    local new_scale = tonumber(val)
                    if new_scale then
                        module.scale = new_scale
                    end
                elseif param == "dblclick" then
                    local new_time = tonumber(val)
                    if new_time then
                        module.dblclick = new_time
                    end
                end
            end
        end
    end
    print("lang ", module.language)
    print("scale ", module.scale)
    print("dbl ", module.dblclick)
end

return module
