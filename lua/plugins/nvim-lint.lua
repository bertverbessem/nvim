return {
    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            -- Define secretlint linter inline
            lint.linters.secretlint = {
                cmd = "secretlint",
                stdin = false,
                args = {
                    "--format",
                    "compact",
                    function()
                        return vim.api.nvim_buf_get_name(0)
                    end,
                },
                stream = "stdout",
                ignore_exitcode = true,
                parser = function(output, bufnr)
                    local diagnostics = {}
                    for line in output:gmatch("[^\r\n]+") do
                        -- Parse format: "filename: line N, col N, severity - message"
                        local file, row, col, severity, message =
                            line:match("([^:]+): line (%d+), col (%d+), (%w)%w* %- (.+)")
                        if file and row and col and severity and message then
                            local diagnostic_severity = vim.diagnostic.severity.INFO
                            if severity:lower() == "e" then
                                diagnostic_severity = vim.diagnostic.severity.ERROR
                            elseif severity:lower() == "w" then
                                diagnostic_severity = vim.diagnostic.severity.WARN
                            end

                            table.insert(diagnostics, {
                                bufnr = bufnr,
                                lnum = tonumber(row) - 1, -- 0-indexed
                                col = tonumber(col) - 1, -- 0-indexed
                                end_lnum = tonumber(row) - 1,
                                end_col = tonumber(col),
                                severity = diagnostic_severity,
                                message = message,
                                source = "secretlint",
                            })
                        end
                    end
                    return diagnostics
                end,
            }

            lint.linters_by_ft = {
                lua = { "luacheck" },
                python = { "flake8" },
                go = { "revive" },
                json = { "eslint_d" },
                jsonc = { "eslint_d" },
                sh = { "shellcheck" },
                yaml = { "secretlint" },
                ["yaml.ansible"] = { "secretlint" },
                dockerfile = { "hadolint" },
            }

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
