-- ================================================================================================
-- TITLE : terraform-ls (Docker Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#terraformls
-- ================================================================================================

vim.lsp.config("terraformls", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    filetypes = { "terraform", "terraform-vars", "hcl" },
    root_markers = { ".terraform", ".git" },
})
vim.lsp.enable("terraformls")
