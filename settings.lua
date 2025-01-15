local module = {}

module.language = "en"
module.scale = 1
module.dblclick = 0.3

function module.save()
    love.filesystem.write(
        "settings",
        "language " .. module.language .. "\nscale " .. module.scale .. "\ndblclick " .. module.dblclick .. "\n"
    )
end

return module
