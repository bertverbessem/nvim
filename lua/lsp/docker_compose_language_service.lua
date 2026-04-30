-- ================================================================================================
-- TITLE : docker-compose-language-service LSP Setup
-- ABOUT : Service-aware completions and validation for docker-compose files.
-- LINKS :
--   > github: https://github.com/microsoft/compose-language-service
-- ================================================================================================

vim.lsp.config("docker_compose_language_service", {
    capabilities = require("config.capabilities").get(),
    filetypes = { "yaml.docker-compose" },
    root_markers = { "docker-compose.yml", "docker-compose.yaml", ".git" },
})

vim.lsp.enable("docker_compose_language_service")
