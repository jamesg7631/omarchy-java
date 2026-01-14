return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Refresh Code Lens only when entering a buffer, leaving insert mode, or saving.
      -- Removed "CursorHold" to eliminate flickering.
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = 0 })
        end,
      })

      -- Press 'gl' to click the code lens (Run test, etc)
      vim.keymap.set("n", "gl", vim.lsp.codelens.run, { desc = "Run Code Lens" })
    end,
  },
}
