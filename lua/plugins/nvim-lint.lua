return {
    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            -- Function to find the appropriate binary (checks venv first, then system)
            local function find_binary(name)
                -- Check for virtual environment
                local venv = os.getenv("VIRTUAL_ENV")
                if venv then
                    local venv_bin = venv .. "/bin/" .. name
                    if vim.fn.executable(venv_bin) == 1 then
                        return venv_bin
                    end
                end

                -- Check for .venv in project root
                local root = vim.fn.getcwd()
                local local_venv_bin = root .. "/.venv/bin/" .. name
                if vim.fn.executable(local_venv_bin) == 1 then
                    return local_venv_bin
                end

                -- Fall back to system binary
                return name
            end
            -- Define ansible-lint linter
            lint.linters.ansible_lint = {
                cmd = find_binary("ansible-lint"),
                stdin = false,
                args = {
                    "-f",
                    "codeclimate",
                    "--nocolor",
                    function()
                        return vim.api.nvim_buf_get_name(0)
                    end,
                },
                stream = "stdout",
                ignore_exitcode = true,
                parser = function(output, _)
                    local diagnostics = {}
                    local ok, decoded = pcall(vim.json.decode, output)
                    if not ok or not decoded then
                        return diagnostics
                    end

                    for _, item in ipairs(decoded) do
                        if item.location and item.location.path then
                            local severity = vim.diagnostic.severity.WARN
                            if item.severity == "major" or item.severity == "critical" then
                                severity = vim.diagnostic.severity.ERROR
                            elseif item.severity == "minor" or item.severity == "info" then
                                severity = vim.diagnostic.severity.INFO
                            end

                            -- Handle both 'lines' and 'positions' formats
                            local lnum, col, end_lnum, end_col
                            if item.location.lines then
                                lnum = (item.location.lines.begin or 1) - 1
                                end_lnum = (item.location.lines["end"] or item.location.lines.begin or 1) - 1
                                col = 0
                                end_col = 0
                            elseif item.location.positions and item.location.positions.begin then
                                lnum = (item.location.positions.begin.line or 1) - 1
                                col = (item.location.positions.begin.column or 1) - 1
                                if item.location.positions["end"] then
                                    end_lnum = (item.location.positions["end"].line or lnum + 1) - 1
                                    end_col = (item.location.positions["end"].column or col + 1) - 1
                                else
                                    end_lnum = lnum
                                    end_col = col
                                end
                            else
                                lnum = 0
                                col = 0
                                end_lnum = 0
                                end_col = 0
                            end

                            table.insert(diagnostics, {
                                lnum = lnum,
                                col = col,
                                end_lnum = end_lnum,
                                end_col = end_col,
                                severity = severity,
                                message = item.description or item.check_name,
                                code = item.check_name,
                                source = "ansible-lint",
                            })
                        end
                    end
                    return diagnostics
                end,
            }

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
                parser = function(output, _)
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
                ["yaml.ansible"] = { "ansible_lint", "secretlint" },
                dockerfile = { "hadolint" },
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
