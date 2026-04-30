-- ================================================================================================
-- TITLE : gopls (Golang Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/golang/tools/tree/master/gopls
-- ================================================================================================

vim.lsp.config("gopls", {
    capabilities = require("config.capabilities").get(),
    filetypes = { "go" },
})
vim.lsp.enable("gopls")
