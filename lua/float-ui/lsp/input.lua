local Utils = require("float-ui.utils")

local M = {}

M.input = function()
	local new_input = function(opts, on_confirm)
		local buf = vim.api.nvim_create_buf(false, true)

		local default_text = opts.default or ""
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default_text })

		local width = math.max(20, #default_text + 10)
		local height = 1

		-- Trim the prompt to get desired spacing
		local raw_title = opts.prompt or "Input"
		local pad_title = " " .. raw_title:gsub("%s*:%s*$", "") .. " "

		local win_opts = {
			relative = "cursor",
			row = 1,
			col = 0,
			width = width,
			height = height,
			style = "minimal",
			border = Utils.border,
			title = pad_title,
			title_pos = "center",
		}

		local win = vim.api.nvim_open_win(buf, true, win_opts)

		-- Confirm a change
		vim.keymap.set("i", "<CR>", function()
			local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
			local new_text = lines[1]

			vim.cmd("stopinsert")
			vim.api.nvim_win_close(win, true)

			on_confirm(new_text) -- Call original callback
		end, { buffer = buf })

		-- Cancel the change
		vim.keymap.set("n", "<Esc>", function()
			vim.api.nvim_win_close(win, true)
			on_confirm(nil)
		end, { buffer = buf })

		vim.cmd("startinsert!") -- Start in insert mode
	end

	vim.ui.input = new_input
	return new_input
end

return M
