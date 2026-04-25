-- ================================================================================================
-- TITLE : doc-float
-- ABOUT : Shared floating window for CLI documentation tools
-- ================================================================================================

local M = {}

function M.show(lines, title, ft, opts)
    if #lines == 0 then
        vim.notify("No output found", vim.log.levels.WARN)
        return
    end
    opts = opts or {}
    local width = math.floor(vim.o.columns * 0.85)
    local height = math.floor(vim.o.lines * 0.80)
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    if ft == "yaml.ansible" then
        vim.api.nvim_buf_set_name(buf, vim.fn.getcwd() .. string.format("/.ansible-doc-%d.yml", buf))
    end
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = title,
        title_pos = "center",
    })
    vim.b[buf].doc_float = true
    vim.bo[buf].filetype = ft or "help"
    if opts.matchadd then
        for _, m in ipairs(opts.matchadd) do
            vim.fn.matchadd(m[1], m[2], 10, -1, { window = win })
        end
    end
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.bo[buf].modified = false
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })
end

function M.run_cmd(cmd, title, ft, opts)
    local lines = {}
    vim.fn.jobstart(cmd, {
        on_stdout = function(_, data)
            for _, line in ipairs(data) do
                table.insert(lines, (line:gsub("\27%[[%d;]*m", "")))
            end
        end,
        on_exit = function()
            vim.schedule(function()
                if opts and opts.filter then
                    lines = opts.filter(lines)
                end
                M.show(lines, title, ft, opts)
            end)
        end,
    })
end

M.ansible_help_hl = {
    { "Title", "^>.*$" },
    { "Title", "^[A-Z][A-Z %]*:.*$" },
    { "Identifier", "^   \\zs\\S\\+" },
    { "Type", "\\<type:\\s*\\zs\\S\\+" },
    { "Number", "\\<default:\\s*\\zs\\S\\+" },
    { "Special", "`[^`]\\+'" },
    { "WarningMsg", "\\<required\\>" },
    { "Comment", "\\<aliases:\\s*\\zs.*$" },
    { "String", "\\<returned:\\s*\\zs.*$" },
    { "Comment", "^  \\* note:.*$" },
}

M.man_hl = {
    { "Title", "^[A-Z][A-Z ]*$" },
    { "Title", "^   [A-Z][A-Za-z ]*$" },
    { "Identifier", "^       \\zs-[^ ,]\\+" },
    { "Special", "\\[\\zs[^]]*\\ze\\]" },
}

M.terraform_hl = {
    { "Title", "^## .*$" },
    { "Title", "^### .*$" },
    { "Identifier", "^\\* \\zs`[^`]\\+`" },
    { "Type", "(\\zs[A-Z]\\w\\+\\ze)" },
    { "Special", "`[^`]\\+`" },
    { "WarningMsg", "\\<[Rr]equired\\>" },
    { "Comment", "\\<[Oo]ptional\\>" },
}

M.kubectl_hl = {
    { "Title", "^KIND:.*$" },
    { "Title", "^VERSION:.*$" },
    { "Title", "^DESCRIPTION:$" },
    { "Title", "^FIELDS:$" },
    { "Title", "^RESOURCE:.*$" },
    { "Identifier", "^   \\zs\\S\\+\\ze\\s" },
    { "Type", "<\\zs[^>]\\+\\ze>" },
    { "WarningMsg", "\\<-required-\\>" },
}

return M
