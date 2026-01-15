return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        -- Assign names to your custom groups
        { "<leader>t", group = "test" },    -- Names the 't' key "test"
        { "<leader>z", group = "symbols" }, -- Workspace symbols (Generic)
      },
    },
  },
}
