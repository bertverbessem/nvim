-- Formatting
return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters = {
                yamlfmt = {
                    prepend_args = {
                        "-formatter",
                        "retain_line_breaks=true,scan_folded_as_literal=true",
                    },
                },
            },
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                go = { "gofumpt" },
                json = { "fixjson" },
                jsonc = { "fixjson" },
                sh = { "shfmt" },
                yaml = { "yamlfmt" },
                ["yaml.ansible"] = function(bufnr)
                    -- Check if first line contains vault content
                    local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
                    if first_line and first_line:match("$ANSIBLE_VAULT") then
                        return {} -- Don't format vault files
                    end
                    return { "yamlfmt" }
                end,
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
