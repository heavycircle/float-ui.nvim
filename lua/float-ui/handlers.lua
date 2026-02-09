local Utils = require("float-ui.utils")

local M = {}

M.setup = function()
	local hover_config = {
		border = Utils.border,
		max_width = 80,
		max_height = 20,
	}

	local diagnostic_config = {
		signs = true,
		update_in_insert = false,
		underline = true,
		severity_sort = true,

		float = {
			focusable = false,
			style = "minimal",
			border = Utils.border,
			source = true,
			header = "Diagnostics",
			prefix = "● ",
		},
	}

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("FloatUI", { clear = true }),
		callback = function(args)
			vim.diagnostic.config(diagnostic_config)

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
				vim.lsp.handlers.hover,
				vim.tbl_extend("force", hover_config, { title = "Docs", focusable = true })
			)

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
				vim.lsp.handlers.signature_help,
				vim.tbl_extend("force", hover_config, { focusable = false })
			)
		end,
	})
end

return M
