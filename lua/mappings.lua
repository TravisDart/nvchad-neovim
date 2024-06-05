require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("i", "<tab>", function()
  vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')
end, { desc="Copilot Accept" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
