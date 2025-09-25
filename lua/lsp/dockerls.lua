-- ================================================================================================
-- TITLE : dockerls (Docker Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/rcjsuen/dockerfile-language-server-nodejs
-- ================================================================================================

vim.lsp.config("dockerls", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "dockerfile" },
})

vim.lsp.enable("dockerls")
