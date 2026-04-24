-- ================================================================================================
-- TITLE : dockerls (Docker Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/rcjsuen/dockerfile-language-server-nodejs
-- ================================================================================================

vim.lsp.config("dockerls", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    filetypes = { "dockerfile" },
})

vim.lsp.enable("dockerls")
