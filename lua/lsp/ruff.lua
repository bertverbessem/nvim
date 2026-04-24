-- ================================================================================================
-- TITLE : ruff LSP Setup
-- ABOUT : Fast Python linter and formatter. Handles diagnostics and code actions.
--         Runs alongside basedpyright (type checking) — ruff handles style/lint.
-- LINKS :
--   > github: https://github.com/astral-sh/ruff
-- ================================================================================================

vim.lsp.config("ruff", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    filetypes = { "python" },
    init_options = {
        settings = {
            -- Use project ruff.toml / pyproject.toml if present, otherwise defaults
            lineLength = 120,
        },
    },
})

vim.lsp.enable("ruff")
