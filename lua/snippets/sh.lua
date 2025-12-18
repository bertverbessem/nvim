local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
  s({
    trig = "rgb",
    name = "ANSI colors (RGB)",
    dscr = "Define ANSI color variables (RED, GREEN, YELLOW, NC)",
    wordTrig = true,
  }, {
    t({
      "RED='\\033[0;31m'",
      "GREEN='\\033[0;32m'",
      "YELLOW='\\033[0;33m'",
      "NC='\\033[0m'",
    }),
  }),
}
