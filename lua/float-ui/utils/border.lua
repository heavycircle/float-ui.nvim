local Config = require("float-ui.config")

local M = {}

M.get_border = function()
	if vim.fn.exists("&winborder") == 1 and vim.o.winborder ~= "" then
        return vim.o.winborder
	end
	return Config.options.popup.winborder
end

return M
