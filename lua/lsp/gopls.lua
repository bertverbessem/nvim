-- ================================================================================================
-- TITLE : gopls (Golang Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/golang/tools/tree/master/gopls
-- ================================================================================================

vim.lsp.config("gopls", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "go" },
})
vim.lsp.enable("gopls")
