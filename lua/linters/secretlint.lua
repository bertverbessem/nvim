local severities = {
    e = vim.diagnostic.severity.ERROR,
    w = vim.diagnostic.severity.WARN,
    i = vim.diagnostic.severity.INFO,
}

return {
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
            local row, col, sev, msg = line:match(": line (%d+), col (%d+), (%a)%a* %- (.+)")
            if row then
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(row) - 1,
                    col = tonumber(col) - 1,
                    end_lnum = tonumber(row) - 1,
                    end_col = tonumber(col),
                    severity = severities[sev:lower()] or vim.diagnostic.severity.INFO,
                    message = msg,
                    source = "secretlint",
                })
            end
        end
        return diagnostics
    end,
}
