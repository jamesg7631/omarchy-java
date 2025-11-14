return {
  -- We are modifying the existing conform.nvim plugin, which
  -- LazyVim already includes.
  {
    "stevearc/conform.nvim",
    opts = {
      -- This tells conform to use 'prettier' for these file types.
      formatters_by_ft = {
        python = { "black" },
        html = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
        -- You can add other file types here as you need them
      },
    },
    -- This 'keys' table is where we define our new, non-conflicting keymap
    keys = {
      {
        "<leader>F", -- Notice I'm using capital 'F' to avoid the conflict
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "", -- This means it works in both Normal and Visual mode
        desc = "Format buffer or selection", -- This description will appear in your which-key menu!
      },
    },
  },
}
