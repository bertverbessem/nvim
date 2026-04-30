-- ================================================================================================
-- TITLE : intelephense (PHP Language Server) LSP Setup
-- ABOUT : PHP LSP for reading/navigating large codebases (Magento2, Symfony, Laravel, OroCommerce).
--         Free tier covers go-to-definition, hover, references, workspace symbols.
-- LINKS :
--   > github  : https://github.com/bmewburn/vscode-intelephense
--   > license : https://intelephense.com (free tier sufficient for code reading)
-- ================================================================================================

vim.lsp.config("intelephense", {
    capabilities = require("config.capabilities").get(),
    filetypes = { "php" },
    root_markers = { "composer.json", ".git" },
    settings = {
        intelephense = {
            files = {
                -- Increase limit for large codebases like Magento2
                maxSize = 5000000,
            },
            stubs = {
                -- Common stubs for e-commerce stacks
                "apache", "bcmath", "calendar", "Core", "ctype", "curl",
                "date", "dom", "exif", "fileinfo", "filter", "gd", "gettext",
                "hash", "iconv", "imagick", "json", "mbstring", "mcrypt",
                "memcache", "memcached", "mongodb", "mysqli", "mysqlnd",
                "openssl", "pcntl", "pcre", "PDO", "pdo_mysql", "pdo_sqlite",
                "Phar", "posix", "redis", "Reflection", "session", "SimpleXML",
                "soap", "SPL", "sqlite3", "standard", "superglobals", "tokenizer",
                "xml", "xmlreader", "xmlwriter", "xsl", "zip", "zlib",
            },
            diagnostics = {
                enable = true,
            },
            completion = {
                fullyQualifyGlobalConstantsAndFunctions = false,
            },
        },
    },
})

vim.lsp.enable("intelephense")
