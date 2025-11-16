return {
  -- === 1. FORCE nvim-cmp + disable blink.cmp ===
  {
    "hrsh7th/nvim-cmp",
    enabled = true,
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- Use luasnip for snippets
          end,
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp", priority = 1000 }, -- LSP completions
          { name = "luasnip", priority = 750 }, -- Snippets
          { name = "buffer", priority = 500 }, -- Buffer text
          { name = "path", priority = 250 }, -- Filesystem paths
        },
      })

      -- Ensure nvim_lsp for Java files
      cmp.setup.filetype("java", {
        sources = {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        },
      })
    end,
  },
  { "hrsh7th/cmp-nvim-lsp", enabled = true },
  { "hrsh7th/cmp-buffer", enabled = true },
  { "hrsh7th/cmp-path", enabled = true },
  { "saadparwaiz1/cmp_luasnip", enabled = true },
  { "Saghen/blink.cmp", enabled = false }, -- Disables blink completely
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
    enabled = false, -- Disables the broken extra
  },
  -- === 4. Re-enable LazyVim's nvim-cmp extra (safe now) ===
  { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
}
