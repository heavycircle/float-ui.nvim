local M = {}

local health = require("float-ui.health")

M.setup = function()
    if not health.check({ checkhealth = false }) then
        return
    end

	require("float-ui.lsp")
    -- require("float-ui.pum").setup()
end

M.disable = function() end

M.enable = function() end

return M
