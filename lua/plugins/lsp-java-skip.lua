return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Tell LazyVim's default LSP setup to skip 'jdtls'
        -- This lets our 'nvim-jdtls.lua' file take over
        jdtls = false,
      },
    },
  },
}
