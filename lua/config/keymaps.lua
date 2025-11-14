-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Dedent line" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Dedent line" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Dedent selection" })

-- Remove LazyVim's terminal binding
vim.keymap.del("n", "<C-/>")
vim.keymap.del("t", "<C-/>")

-- Comment with Ctrl+/ (works in terminal + GUI)
vim.keymap.set("n", "<C-/>", function()
  return vim.v.count == 0 and "gcc" or "gc"
end, { expr = true, desc = "Toggle comment", remap = true })

vim.keymap.set("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })

-- Fallback for terminals that send Ctrl+_
vim.keymap.set("n", "<C-_>", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<C-_>", "gc", { desc = "Toggle comment", remap = true })

-- Open terminal on Ctrl+\ (or any key you like)
-- Use built-in terminal (no plugin)
vim.keymap.set({ "n", "t" }, "<C-\\>", function()
  vim.cmd("botright 12split | terminal")
end, { desc = "Terminal" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Escape terminal mode" })
