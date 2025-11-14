return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  },
  -- Add an init function to set global options
  init = function()
    -- This is where you can override the defaults
    -- See the "Default configuration" section of the README for options
    vim.g.rest_nvim = {
      request = {
        -- Example: skip SSL verification if needed
        -- skip_ssl_verification = true,
      },
      response = {
        hooks = {
          -- Example: disable formatting the response body
          -- format = false,
        },
      },
      -- ... other settings
    }
  end,
  keys = {
    {
      "<leader>r",
      desc = "+rest",
    },
    {
      "<leader>ro",
      ":Rest open<CR>",
      mode = "n",
      desc = "Rest: Open Result pane",
    },
    {
      "<leader>rr", -- Key combination
      ":Rest run<CR>", -- Command to run
      mode = "n", -- Normal mode
      desc = "Rest: Run request under cursor", -- Description for which-key
    },
    {
      "<leader>rl",
      ":Rest last<CR>",
      mode = "n",
      desc = "Rest: Run last request",
    },
    {
      "<leader>rm",
      ":Rest logs<CR>",
      mode = "n",
      desc = "Rest: Edit logs file",
    },
    {
      "<leader>rc",
      ":Rest cookies<CR>",
      mode = "n",
      desc = "Rest: Edit cookies file",
    },
    {
      "<leader>rs",
      ":Rest env show<CR>",
      mode = "n",
      desc = "Show dotenv file registered to current .http file",
    },
    {
      "<leader>re",
      ":Rest env select",
      mode = "n",
      desc = "Select and register .env file with vim.ui.select()",
    },
    -- Add more keybindings as needed
    -- {
    --   "<leader>ro",
    --   ":Rest open<CR>",
    --   mode = "n",
    --   desc = "Rest: Open result pane",
    -- },
  },
}
