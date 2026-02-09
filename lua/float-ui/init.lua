local M = {}

local health = require("float-ui.health")

M.setup = function()
    if not health.check({ checkhealth = false }) then
        return
    end

    -- Changes
    require("float-ui.handlers").setup()

    -- Hooks
	require("float-ui.ui")
end

M.disable = function() end

M.enable = function() end

return M
