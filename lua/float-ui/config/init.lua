local M = {}

M.defaults = function()
	---@class FloatUiConfig
	local defaults = {
		popup = {
			winborder = "single",
		},
	}

	return defaults
end

---@type FloatUiConfig
M.options = {}

M.setup = function(options)
	M.options = vim.tbl_deep_extend("force", {}, M.defaults())

	options = options or {}
	M.options = vim.tbl_deep_extend("force", M.options, options)
end
