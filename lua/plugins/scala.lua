return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "scala" })
    end,
  },

  -- {
  --   "stevearc/conform.nvim",
  --   opts = function(_, opts)
  --     opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
  --       scala = { "lsp" },
  --     })
  --   end,
  -- },

  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.configurations.scala = {
        {
          type = "scala",
          request = "launch",
          name = "RunOrTest",
          metals = {
            runType = "runOrTestFile",
          },
        },
        {
          type = "scala",
          request = "launch",
          name = "Test Target",
          metals = {
            runType = "testTarget",
          },
        },
      }
    end,
  },

  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "mfussenegger/nvim-dap",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()

      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.settings = {
        javaHome = "/home/james/.sdkman/candidates/java/current/bin/java",
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
        testUserInterface = "Test Explorer",
        verboseCompilation = true,
      }

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()

        local map = vim.keymap.set

        map("n", "<leader>mc", [[<cmd>lua require("metals").compile_cascade()<CR>]],
          { desc = "Compile Cascade", buffer = bufnr, silent = true })
        map("n", "<leader>mi", [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]],
          { desc = "Toggle Implicits", buffer = bufnr, silent = true })
        map("n", "<leader>mh", [[<cmd>lua require("metals").hover_worksheet()<CR>]],
          { desc = "Hover Worksheet", buffer = bufnr, silent = true })
        map("n", "<leader>mt", [[<cmd>lua require("metals").type_of_range()<CR>]],
          { desc = "Type of Range", buffer = bufnr, silent = true })
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = nvim_metals_group,
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
      })
    end,
  },
}
