return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "mfussenegger/nvim-dap",
    },
    ft = { "scala", "sbt", "java" }, -- Keep java here to allow Metals to handle Mixed projects
    opts = function()
      local metals_config = require("metals").bare_config()

      -- Integration with your forced nvim-cmp setup
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.settings = {
        javaHome = "/home/james/.sdkman/candidates/java/current/bin/java",
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
      }

      metals_config.on_attach = function(client, bufnr)
        -- Integration with your existing DAP setup (dapui.lua)
        require("metals").setup_dap()

        -- Keymaps specific to Metals
        local map = vim.keymap.set
        map("n", "<leader>me", [[<cmd>lua require("metals").type_of_range()<CR>]], { desc = "Metals: Type of Range" })
        map("n", "<leader>mi", [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]],
          { desc = "Toggle Implicits" })
        map("n", "<leader>mc", [[<cmd>lua require("metals").compile_cascade()<CR>]], { desc = "Compile Cascade" })
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = nvim_metals_group,
        pattern = self.ft,
        callback = function()
          -- Logic to prevent Metals from starting in pure Java projects
          -- if you want JDTLS to handle those instead.
          require("metals").initialize_or_attach(metals_config)
        end,
      })
    end,
  },
}
