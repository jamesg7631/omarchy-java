return {
  -- 1. Add web-dev parsers to nvim-treesitter
  -- This modifies your existing treesitter config
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "typescript",
        "tsx",
        "css",
        "html",
        "json",
      })
    end,
  },
  -- 2. Add web-dev tools to Mason
  -- This modifies your existing mason.lua file's list
  {
    "mason-org/mason.nvim", -- Updated repo name
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- LSPs
        "typescript-language-server", -- Correct for TS/JS
        "css-lsp", -- Fixed: was "cssls"
        "html-lsp", -- Fixed: was "html"
        "eslint-lsp",
        -- Formatter
        "prettierd",
      })
    end,
  },
  -- 3. Add web-dev language servers to nvim-lspconfig
  -- This modifies your existing lspconfig setup
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- The 'servers' table will be merged with your existing one
      -- (This will not touch your 'jdtls = false' setting)
      vim.tbl_deep_extend("force", opts.servers or {}, {
        tsserver = {}, -- Still valid alias in lspconfig (maps to ts_ls)
        cssls = {}, -- Still valid in lspconfig
        html = {}, -- Still valid in lspconfig
        eslint = {},
      })
    end,
  },
  -- 4. Add prettierd as the formatter for web files
  -- This modifies your existing conform.nvim setup
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- This will be merged with your existing python/black setup
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
      })
    end,
  },
}
