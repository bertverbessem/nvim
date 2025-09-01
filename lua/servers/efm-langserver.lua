-- ================================================================================================
-- TITLE : efm-langserver
-- ABOUT : a general purpose language server protocol implemented here for linters/formatters
-- LINKS :
--   > github : https://github.com/mattn/efm-langserver
--   > configs: https://github.com/creativenull/efmls-configs-nvim/tree/main
-- ================================================================================================

--- @param lspconfig table The lspconfig module from nvim-lspconfig plugin
--- @param capabilities table LSP client capabilities (from nvim-cmp)
--- @param on_attach function Callback function executed when LSP attaches to a buffer
--- @return nil
return function(lspconfig, capabilities, on_attach)
    local luacheck = require("efmls-configs.linters.luacheck") -- lua linter
    local stylua = require("efmls-configs.formatters.stylua") -- lua formatter
    local flake8 = require("efmls-configs.linters.flake8") -- python linter
    local black = require("efmls-configs.formatters.black") -- python formatter
    local go_revive = require("efmls-configs.linters.go_revive") -- go linter
    local gofumpt = require("efmls-configs.formatters.gofumpt") -- go formatter
    local prettier_d = require("efmls-configs.formatters.prettier_d") -- ts/js/solidity/json/docker/html/css/react/svelte/vue formatter
    local eslint_d = require("efmls-configs.linters.eslint_d") -- ts/js/solidity/json/react/svelte/vue linter
    local fixjson = require("efmls-configs.formatters.fixjson") -- json formatter
    local shellcheck = require("efmls-configs.linters.shellcheck") -- bash linter
    local shfmt = require("efmls-configs.formatters.shfmt") -- bash formatter
    local hadolint = require("efmls-configs.linters.hadolint") -- docker linter
    -- local cpplint = require("efmls-configs.linters.cpplint") -- c/cpp linter
    -- local clangformat = require("efmls-configs.formatters.clang_format") -- c/cpp formatter
    -- local solhint = require("efmls-configs.linters.solhint") -- solidity linter
    -- local rustfmt = require("efmls-configs.formatters.rustfmt") -- rust formatter
    local terraform_fmt = require("efmls-configs.formatters.terraform_fmt") -- terraform formatter
    local secretlint = {
        lintCommand = "secretlint --format compact ${INPUT} 2>/dev/null | sed 's/found matching \\([^:]*\\): \\1:/found matching \\1:/'",
        lintStdin = false,
        lintFormats = { "%f: line %l, col %c, %t%*[^-] - %m" },
        lintIgnoreExitCode = true,
        rootMarkers = { ".secretlintrc.json", ".secretlintrc.js", "package.json" },
    }
    -- local codespell = require("efmls-configs.linters.codespell") -- common misspellings linter

    lspconfig.efm.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = {
            "docker",
            "go",
            "json",
            "jsonc",
            "lua",
            "markdown",
            "python",
            "sh",
            "yaml",
            "yaml.ansible",
            "terraform",
            "hcl",
        },
        init_options = {
            documentFormatting = true,
            documentRangeFormatting = true,
            hover = true,
            documentSymbol = true,
            codeAction = true,
            completion = true,
        },
        settings = {
            languages = {
                docker = { hadolint, prettier_d },
                go = { gofumpt, go_revive },
                json = { eslint_d, fixjson },
                jsonc = { eslint_d, fixjson },
                lua = { luacheck, stylua },
                markdown = { prettier_d },
                python = { flake8, black },
                sh = { shellcheck, shfmt },
                yaml = { prettier_d, secretlint },
                ["yaml.ansible"] = { secretlint },
                terraform = { terraform_fmt },
                hcl = { terraform_fmt },
            },
        },
    })
end
