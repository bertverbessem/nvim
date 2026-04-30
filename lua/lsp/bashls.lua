-- ================================================================================================
-- TITLE : bashls (Bash Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/bash-lsp/bash-language-server
-- ================================================================================================

vim.lsp.config("bashls", {
    capabilities = require("config.capabilities").get(),
    filetypes = { "sh", "bash", "zsh" },
    settings = {
        bashIde = {
            shellcheckPath = "",
            shfmtPath = "",
        },
    },
})
vim.lsp.enable("bashls")
