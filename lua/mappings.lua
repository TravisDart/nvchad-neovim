require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("i", "<up>", require("cmp").mapping.scroll_docs(-1), { desc="Go up in the completion list" })
map("i", "<down>", require("cmp").mapping.scroll_docs(1), { desc="Go down in the completion list" })

map("i", "<C-i>", function()
  vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')
end, { desc="Copilot Accept" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
