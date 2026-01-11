return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- Ensure routes table exists
      opts.routes = opts.routes or {}

      -- 1. SILENCE STARTUP NOTIFICATIONS (Top Right)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          any = {
            { find = "Found root_dir" },
            { find = "spring%-boot" },
            { find = "ftplugin: Executing" },
          },
        },
        opts = { skip = true },
      })

      -- 2. SILENCE TYPING/PROGRESS NOTIFICATIONS (Bottom Right)
      table.insert(opts.routes, {
        filter = {
          event = "lsp",
          kind = "progress",
          any = {
            { find = "Validate" },  -- Catches "Validate documents" AND "Validating diagnostics"
            { find = "Publish" },   -- Catches "Publish Diagnostics"
            { find = "Compiling" }, -- Catches "Compiling"
          },
        },
        opts = { skip = true },
      })
    end,
  },
}
