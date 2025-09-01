-- ================================================================================================
-- TITLE : auto-commands
-- ABOUT : automatically run code on defined events (e.g. save, yank)
-- ================================================================================================

-- Restore last cursor position when reopening a file
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
vim.api.nvim_create_autocmd("BufReadPost", {
    group = last_cursor_group,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
    group = highlight_yank_group,
    pattern = "*",
    callback = function()
        vim.hl.on_yank({
            higroup = "IncSearch",
            timeout = 200,
        })
    end,
})

-- format on save using efm langserver and configured formatters
local lsp_fmt_group = vim.api.nvim_create_augroup("FormatOnSaveGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = lsp_fmt_group,
    callback = function()
        local efm = vim.lsp.get_clients({ name = "efm" })
        if vim.tbl_isempty(efm) then
            return
        end
        vim.lsp.buf.format({ name = "efm", async = true })
    end,
})

-- Ansible file pattern
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter", "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("Ansible", { clear = true }),
    pattern = {
        "*/roles/*/*/*.yaml",
        "*/roles/*/*/*.yml",
        "main.yml",
        "main.yaml",
        "Debian*.yaml",
        "Debian*.yml",
        "!docker-compose.yml",
        "!docker-compose.yaml",
        "*/ansible-devbox/*.yaml",
        "*/ansible-devbox/*.yml",
        "*/ansible/*.yml",
        "*/ansible/*.yaml",
        "group_vars/*.yml",
        "group_vars/*.yaml",
        "files/*.yaml",
        "files/*.yml",
        "environments/*.yaml",
        "environments/*.yml",
    },
    callback = function(args)
        local filename = vim.fn.expand("%:t")
        if filename:match("^docker%-compose.*%.ya?ml$") then
            return
        end

        -- Set ansible-specific filetype
        vim.bo[args.buf].filetype = "yaml.ansible"
    end,
})

-- Stop yamlls after it attaches to an ansible file
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        if not args.data or not args.data.client_id then
            return
        end
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        if client.name == "yamlls" and vim.bo[args.buf].filetype == "yaml.ansible" then
            client:stop()
        end
    end,
})
