-- ================================================================================================
-- TITLE : jsonls (JSON Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/microsoft/vscode-json-languageservice
-- ================================================================================================

vim.lsp.config("jsonls", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    filetypes = { "json", "jsonc" },
})
vim.lsp.enable("jsonls")
