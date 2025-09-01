-- ================================================================================================
-- TITLE : terraform-ls (Docker Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#terraformls
-- ================================================================================================

--- @param lspconfig table The lspconfig module from nvim-lspconfig plugin
--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @param on_attach function Callback function executed when LSP attaches to a buffer
--- @return nil
return function(lspconfig, capabilities, on_attach)
    lspconfig.terraformls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "terraform", "terraform-vars", "hcl" },
        root_markers = { ".terraform", ".git" },
    })
end
