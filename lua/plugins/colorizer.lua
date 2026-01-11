return {
  "NvChad/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      user_default_options = {
        names = true, -- "Bold", "Red", etc.
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, etc.
        tailwind = true, -- Support tailwind colors
        mode = "background", -- "foreground", "background", or "virtualtext"
      },
    })
  end,
}
