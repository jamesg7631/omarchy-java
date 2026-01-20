-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- Add to your init.lua
vim.opt.colorcolumn = "120"
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#F2F0E5" })
