local pattern = require("lint.pattern")
local severity = require("lint.severity")

return {
    cmd = "secretlint",
    stdin = false,
    args = {
        "--format",
        "compact",
        function()
            return vim.api.nvim_buf_get_name(0)
        end,
    },
    stream = "stderr",
    ignore_exitcode = true,
    parser = pattern.from_errorformat([[%f: line %l\, col %c\, %t%*[^-] - %m]], {
        severity = {
            e = severity.ERROR,
            w = severity.WARN,
            i = severity.INFO,
        },
    }),
    rootMarkers = { ".secretlintrc.json", ".secretlintrc.js", "package.json" },
}
