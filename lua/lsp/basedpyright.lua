-- ================================================================================================
-- TITLE : pyright (Python Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/microsoft/pyright
-- ================================================================================================

vim.lsp.config("basedpyright", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    settings = {
        basedpyright = {
            disableOrganizeImports = false,
            analysis = {
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
            },
            python = {
                pythonPath = vim.fn.exepath("python3"), -- or specify full path
            },
        },
    },
})
vim.lsp.enable("basedpyright")
