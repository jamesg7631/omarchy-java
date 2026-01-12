return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Refresh Code Lens when moving cursor or leaving insert mode
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = 0 })
        end,
      })

      -- Press 'gl' to click the code lens (Run test, etc)
      vim.keymap.set("n", "gl", vim.lsp.codelens.run, { desc = "Run Code Lens" })
    end,
  },
}
