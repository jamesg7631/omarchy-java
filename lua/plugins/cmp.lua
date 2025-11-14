-- ~/.config/nvim/lua/plugins/cmp.lua
return {
  -- === 1. FORCE nvim-cmp + disable blink.cmp ===
  { "hrsh7th/nvim-cmp", enabled = true },
  { "hrsh7th/cmp-nvim-lsp", enabled = true },
  { "hrsh7th/cmp-buffer", enabled = true },
  { "hrsh7th/cmp-path", enabled = true },
  { "saadparwaiz1/cmp_luasnip", enabled = true },

  { "Saghen/blink.cmp", enabled = false }, -- disables blink completely

  -- === 2. Tell LazyVim to use nvim-cmp + luasnip ===
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- === 3. Override LazyVim's luasnip extra to stop using blink ===
  {
    "lazyvim.plugins.extras.coding.luasnip",
    enabled = false, -- disables the broken extra
  },

  -- === 4. Re-enable LazyVim's nvim-cmp extra (safe now) ===
  { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
}
