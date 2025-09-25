-- ================================================================================================
-- TITLE : jsonls (JSON Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/microsoft/vscode-json-languageservice
-- ================================================================================================

vim.lsp.config("jsonls", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "json", "jsonc" },
})
vim.lsp.enable("jsonls")
