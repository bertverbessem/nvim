-- ================================================================================================
-- TITLE : groovyls (Groovy Language Server) LSP Setup
-- ABOUT : Provides LSP support for Groovy, including Jenkinsfile and shared pipeline libraries.
-- LINKS :
--   > github: https://github.com/prominic/groovy-language-server
-- NOTE  : Requires Java 11+ on PATH
-- ================================================================================================

vim.lsp.config("groovyls", {
    capabilities = require("config.capabilities").get(),
    filetypes = { "groovy" },
    root_markers = { "Jenkinsfile", ".git", "build.gradle", "pom.xml", "settings.gradle" },
})

vim.lsp.enable("groovyls")
