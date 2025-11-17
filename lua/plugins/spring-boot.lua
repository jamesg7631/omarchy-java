return {
  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    dependencies = {
      "mfussenegger/nvim-jdtls", -- or your preferred Java LSP setup
    },
    opts = {},
    config = function()
      -- This is REQUIRED to enable Spring LSP features
      require("spring_boot").init_lsp_commands()
    end,
  },
}
