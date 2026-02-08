vim.g.mapleader = " "
vim.opt.rtp:prepend(".")

require("ui").setup()

-- Dummy mapping to test rename
vim.keymap.set("n", "<leader>rn", function()
	local cur_word = vim.fn.expand("<cword>")
	vim.ui.input({ prompt = "New Name: ", default = cur_word }, function(input)
		if input then
			print("Renamed to: " .. input)
		else
			print("Rename cancelled")
		end
	end)
end, { desc = "test rename" })

-- Dummy omnifunc
_G.test_omni = function(findstart, base)
  if findstart == 1 then
    return vim.fn.col('.') - 1
  end
  -- Return a fake list of completion items
  return {
    { word = "foobar", menu = "[Mock]", info = "A fake item" },
    { word = "foobaz", menu = "[Mock]", info = "Another fake item" },
    { word = "fortran", menu = "[Mock]", info = "Old language" },
    { word = "formula", menu = "[Mock]", info = "Math stuff" },
  }
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Set the buffer's omnifunc to our fake one
    vim.bo.omnifunc = "v:lua.test_omni"

    -- Insert some text so Ctrl-n (Keyword Completion) has targets
    local lines = {
      "Here is some text to test completion.",
      "hello help helm hero",
      "apple apricot apply",
      "",
      "-- Type 'he' and press Ctrl-n",
      "-- Type 'fo' and press Ctrl-x Ctrl-o",
      ""
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    
    -- Move cursor to the bottom
    vim.api.nvim_win_set_cursor(0, { #lines, 0 })
  end
})
