return {
  {
    "syntaxpresso/syntaxpresso.nvim",
    -- Optimization: Only load this plugin when editing Java files
    ft = "java",

    -- Configuration (passed to require("syntaxpresso").setup)
    opts = {
      -- Custom keybinding for the main menu (default is <leader>cj)
      keymap = "<leader>cj",

      -- Auto-update settings
      auto_update = {
        enabled = true,
        frequency = "always",
        prompt = false,
      },
    },

    -- Keybindings (Lazy-load the plugin when these keys are pressed)
    keys = {
      -- Main Menu
      { "<leader>cj", desc = "Syntaxpresso Menu" },

      -- Direct Commands
      { "<leader>je", "<cmd>SyntaxpressoCreateJpaEntity<CR>",          desc = "Create JPA Entity" },
      { "<leader>jf", "<cmd>SyntaxpressoCreateEntityField<CR>",        desc = "Create JPA Field" },
      { "<leader>jr", "<cmd>SyntaxpressoCreateEntityRelationship<CR>", desc = "Create Relationship" },
      { "<leader>jR", "<cmd>SyntaxpressoCreateJpaRepository<CR>",      desc = "Create Repository" },
    },
  },
}
