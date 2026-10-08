-- ================================================================================================
-- TITLE : gopls (Golang Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/golang/tools/tree/master/gopls
-- ================================================================================================

vim.lsp.config("gopls", {
    filetypes = { "go" },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
            },
            staticcheck = true,
            gofumpt = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
    on_attach = function(_, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end,
})
vim.lsp.enable("gopls")
