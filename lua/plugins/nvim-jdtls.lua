-- /home/james/.config/nvim/lua/plugins/nvim-jdtls.lua
return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "hrsh7th/cmp-nvim-lsp",
  },
  -- The entire 'config' function has been removed.
  -- We will move all that logic to the new ftplugin file.
}
