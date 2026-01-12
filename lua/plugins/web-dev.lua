return {
  -- 1. Add web-dev parsers to nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "javascript", "typescript", "tsx", "css", "html", "json",
      })
    end,
  },

  -- 2. Add web-dev tools to Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- CHANGE 1: Replaced "typescript-language-server" with "vtsls"
        "vtsls",
        "css-lsp",
        "html-lsp",
        "eslint-lsp",
        "prettierd",
      })
    end,
  },

  -- 3. Add web-dev language servers to nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.tbl_deep_extend("force", opts.servers or {}, {
        -- CHANGE 2: Removed tsserver/ts_ls and added vtsls configuration
        vtsls = {
          -- This ensures the server knows it's a JS project
          single_file_support = true,
          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              -- === NEW CODE LENS SETTINGS START ===
              referencesCodeLens = { enabled = true, showOnAllFunctions = true },
              implementationsCodeLens = { enabled = true },
              -- === NEW CODE LENS SETTINGS END ===
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
              },
            },
          },
        },
        cssls = {},
        html = {},
        eslint = {},
      })
    end,
  },

  -- 4. Add prettierd as the formatter
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
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
