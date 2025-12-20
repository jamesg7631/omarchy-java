local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("lorem", {
    t({
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ",
      "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim ",
      "veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea ",
      "commodo consequat.",
    }),
    i(0),
  }),
}
