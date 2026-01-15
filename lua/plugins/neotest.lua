return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "lua-nvim/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcasia/neotest-java", -- The Java adapter
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-java")({
            -- strict_testing = true, -- helpful if tests hang
          }),
        },
      })
    end,
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end,                     desc = "Run Nearest Test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run File" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show Output" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,              desc = "Toggle Summary" },
    },
  },
}
