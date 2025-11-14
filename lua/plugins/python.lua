-- ~/.config/nvim/lua/plugins/python.lua
return {
  -- 1. Treesitter (unchanged)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "python", "requirements" })
    end,
  },

  -- 2. Mason: LSP, formatter, linter, debugger
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pyright", -- LSP (unchanged)
        "ruff", -- CHANGED: was "ruff-lsp"
        "black", -- Formatter (fallback, unchanged)
        "debugpy", -- Debugger (DAP, unchanged)
        "mypy", -- Type checker (unchanged)
      })
    end,
  },

  -- 3. LSP Config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.tbl_deep_extend("force", opts.servers or {}, {
        pyright = {}, -- unchanged
        ruff = {}, -- CHANGED: was "ruff" (but lspconfig uses "ruff" for the new server; old was "ruff_lsp")
      })
    end,
  },

  -- 4. Formatter (conform.nvim) - UPDATED for ruff's integrated formatter
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        python = { "ruff_format", "black" }, -- UNCHANGED: ruff_format works with new ruff binary
      })
    end,
  },

  -- 5. Linting (nvim-lint) - mypy (unchanged)
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        python = { "mypy" },
      })
    end,
  },

  -- 6. Debugger (DAP) - unchanged
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup("python") -- uses debugpy from Mason
      -- Optional: test runner
      require("dap-python").test_runner = "pytest"
    end,
  },

  -- 7. Virtual env auto-detect (unchanged)
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    ft = "python",
    opts = {
      name = { "venv", ".venv" },
      auto_refresh = true,
    },
  },

  -- 8. Jupyter / REPL (unchanged, assuming you fixed the build)
  {
    "goerz/jupytext.vim",
    ft = { "python", "ipynb" },
    build = function()
      -- Your fixed build logic here (pipx, etc.)
    end,
    config = function()
      vim.g.jupytext_fmt = "py:percent" -- default format
      vim.g.jupytext_command = "jupytext" -- ensure it finds the binary
    end,
  },
}
