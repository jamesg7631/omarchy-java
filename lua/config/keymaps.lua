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

-- Spring
-- Search Spring Beans, Endpoints, etc. using snacks.nvim
vim.keymap.set("n", "<leader>zb", function()
  require("snacks").picker({
    source = "lsp_workspace_symbols",
    prompt = "Spring Beans & Endpoints",
    query = "@Bean", -- optional: pre-fill with @Bean
  })
end, { desc = "Search Spring @Bean" })

-- General LSP symbols (includes Spring stuff)
vim.keymap.set("n", "<leader>zs", function()
  require("snacks").picker({
    source = "lsp_workspace_symbols",
    prompt = "LSP Symbols",
  })
end, { desc = "LSP Workspace Symbols" })

-- 3. Seamless Window Navigation
-- Jump from Terminal to Code using Ctrl + h/j/k/l
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right" })

-- Check Maven Updates (Java)
vim.keymap.set("n", "<leader>mu", function()
  local cmd = "mvn versions:display-dependency-updates"
  -- Notify user it started
  vim.notify("Checking for Maven updates... (this may take a moment)", vim.log.levels.INFO, { title = "Maven" })
  -- Run command in a floating terminal or split
  -- Using snacks.terminal (since you have snacks.nvim) is the cleanest way:
  require("snacks").terminal(cmd, {
    win = {
      style = "float",
      position = "float",
    },
    interactive = false, -- Close when done (optional, set to true to keep open)
  })
end, { desc = "Check Maven Updates" })
