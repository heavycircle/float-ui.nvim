local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

local M = {}

M.check = function()
	start("deps")

	if vim.fn.has("nvim-0.10.0") ~= 1 then
		error("Neovim >= 0.10.0 required!")
	else
		ok("*Neovim* >= 0.10.0")
	end

	start("hooks")

	local checks = {
		{
			opt = "vim.ui.input",
			handler = vim.ui.input,
			want = function()
				return require("float-ui.lsp").input
			end,
		},
	}

	for _, check in ipairs(checks) do
		if check.handler then
			if check.want() ~= check.handler then
				error(("`%s` failed to hook!"):format(check.opt))
			else
				ok(("`%s` hooked!"):format(check.opt))
			end
		end
	end

	return true
end

return M
