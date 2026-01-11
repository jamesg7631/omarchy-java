return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = opts.routes or {}

      -- 1. Filter the "Spammy" Notifications (from the previous step)
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

      -- 2. Filter the "Validating" Progress (The bottom-right popup)
      table.insert(opts.routes, {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "Validating", -- Matches "Validating diagnostics"
        },
        opts = { skip = true },
      })

      -- Optional: If "Publishing" also shows up separately, filter that too
      table.insert(opts.routes, {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "Publish",
        },
        opts = { skip = true },
      })
    end,
  },
}
