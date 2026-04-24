-- ================================================================================================
-- TITLE : gopls (Golang Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/golang/tools/tree/master/gopls
-- ================================================================================================

vim.lsp.config("gopls", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    filetypes = { "go" },
})
vim.lsp.enable("gopls")
