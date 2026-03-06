return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "stevanmilic/neotest-scala", -- The dedicated Scala adapter
  },
  opts = function()
    return {
      adapters = {
        require("neotest-scala")({
          runner = "sbt",          -- Uses sbt to run tests; can be "bloop" for speed
          framework = "scalatest", -- Supports scalatest, munit, and utest
        }),
      },
    }
  end,
  keys = {
    { "<leader>tr", function() require("neotest").run.run() end,                     desc = "Run Nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run File" },
    { "<leader>ts", function() require("neotest").summary.toggle() end,              desc = "Toggle Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show Output" },
  },
}
