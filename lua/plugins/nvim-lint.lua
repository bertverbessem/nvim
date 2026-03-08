return {
    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters.secretlint = require("linters.secretlint")

            lint.linters_by_ft = {
                lua = { "luacheck" },
                python = {},
                go = { "revive" },
                json = { "eslint_d" },
                jsonc = { "eslint_d" },
                sh = { "shellcheck" },
                yaml = { "secretlint" },
                ["yaml.ansible"] = { "secretlint" },
                dockerfile = { "hadolint" },
                terraform = { "tflint" },
                hcl = { "tflint" },
            }

            -- Auto-lint on save and text change
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
                callback = function()
                    lint.try_lint()
                end,
            })

            -- Debug function to check what's happening
            vim.api.nvim_create_user_command("LintDebug", function()
                local ft = vim.bo.filetype
                local linters = lint.linters_by_ft[ft] or {}
                print("Filetype: " .. ft)
                print("Available linters: " .. vim.inspect(linters))
                lint.try_lint()
            end, {})
        end,
    },
}
