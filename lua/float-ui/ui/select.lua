local Utils = require("float-ui.utils")

local M = {}

M.select = function()
	local function new_select(items, opts, on_choice)
		opts = opts or {}
		local format_item = opts.format_item or tostring

		local choices = {}
		for i, item in ipairs(items) do
			table.insert(choices, string.format(" %d. %s ", i, format_item(item)))
		end

		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, choices)
		vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

		local width = 0
		for _, line in ipairs(choices) do
			width = math.max(width, #line)
		end
		width = math.min(width, 80)
		local height = math.min(#choices, 20)

		local raw_title = opts.prompt or "Select"
		local pad_title = " " .. raw_title:gsub("%s*:%s*$", "") .. " "

		local win_opts = {
			relative = "editor",
			width = width,
			height = height,
			row = (vim.o.lines - height) / 2,
			col = (vim.o.columns - width) / 2,
			style = "minimal",
			border = Utils.border,
			title = pad_title,
			title_pos = "center",
		}

		local win = vim.api.nvim_open_win(buf, true, win_opts)
		vim.api.nvim_set_option_value("cursorline", true, { win = win })
		vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })

		-- Confirm a change
		vim.keymap.set("n", "<CR>", function()
			local cursor = vim.api.nvim_win_get_cursor(win)
			local idx = cursor[1]
			print(cursor, idx, items[idx])

			vim.api.nvim_win_close(win, true)

			-- Use original callback
			on_choice(items[idx], idx)
		end, { buffer = buf, nowait = true })

		-- Cancel the change
		local close = function()
			vim.api.nvim_win_close(win, true)

			on_choice(nil, nil)
		end
		vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
		vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
	end

	vim.ui.select = new_select
	return new_select
end

return M
