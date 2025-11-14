-- /home/james/.config/nvim/lua/plugins/dapui.lua
return {
  "rcarriga/nvim-dap-ui",
  -- This will merge with the default config from LazyVim
  opts = function(_, opts)
    -- By default, dap-ui opens all elements, including "console"
    -- We want to stop it from opening "console" so that
    -- output only appears in your Alacritty window.
    local elements = {
      "scopes",
      "breakpoints",
      "stacks",
      "watches",
      "repl", -- Keep the REPL (for typing debug commands)
      -- "console" is new, removed
    }

    -- Override the hooks that open the windows
    opts.hooks = {
      on_launch = function()
        require("dapui").open(elements)
      end,
      on_attach = function()
        require("dapui").open(elements)
      end,
    }
  end,
}
