-- Formatting
return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                go = { "gofumpt" },
                json = { "fixjson" },
                jsonc = { "fixjson" },
                sh = { "shfmt" },
                yaml = { "prettier" },
                ["yaml.ansible"] = { "prettier" },
                markdown = { "prettier" },
                docker = { "prettier" },
                terraform = { "terraform_fmt" },
                hcl = { "terraform_fmt" },
            },
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 5000,
            },
        })

        -- Manual format keymap
        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
