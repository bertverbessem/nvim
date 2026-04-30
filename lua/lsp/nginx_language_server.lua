-- ================================================================================================
-- TITLE : nginx-language-server LSP Setup
-- LINKS :
--   > github: https://github.com/pappasam/nginx-language-server
-- ================================================================================================

vim.lsp.config("nginx_language_server", {
    capabilities = require("config.capabilities").get(),
    filetypes = { "nginx" },
    root_markers = { "nginx.conf", ".git" },
})

vim.lsp.enable("nginx_language_server")
