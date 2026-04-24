-- ================================================================================================
-- TITLE : nvim-lspconfig
-- ABOUT : Quickstart configurations for the built-in Neovim LSP client.
-- LINKS :
--   > github                  : https://github.com/neovim/nvim-lspconfig
--   > mason.nvim (dep)        : https://github.com/mason-org/mason.nvim
--   > blink.cmp (dep)         : https://github.com/saghen/blink.cmp
-- ================================================================================================

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} }, -- LSP/DAP/Linter installer & manager
        "saghen/blink.cmp", -- completion plugin providing LSP capabilities
    },
}
