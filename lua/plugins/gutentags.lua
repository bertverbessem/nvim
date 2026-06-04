-- ================================================================================================
-- TITLE : vim-gutentags
-- ABOUT : Automatic ctags generation for shell scripts. Provides LSP-style code navigation
--         (jump-to-definition across sourced function libraries) via the native tag stack.
-- KEYS  : <C-]> jump · <C-t> jump back · g] list matches
--         <leader>gD : LSP definition, falls back to ctags when the LSP finds nothing (shell only)
--         <leader>td : ctags definition (always, escape hatch)
-- LINKS :
--   > github: https://github.com/ludovicchabant/vim-gutentags
-- ================================================================================================

-- Pure ctags jump on the word under the cursor (pushes the tag stack; return with <C-t>).
local function tag_jump()
    local word = vim.fn.expand("<cword>")
    if word == "" then
        return
    end
    if not pcall(vim.cmd, "tag " .. word) then
        vim.notify("No definition found for '" .. word .. "'", vim.log.levels.WARN)
    end
end

-- LSP goto-definition, falling back to the ctags jump when no LSP client answers.
local function lsp_or_tag()
    local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" })
    if #clients == 0 then
        return tag_jump()
    end
    local params = vim.lsp.util.make_position_params(0, clients[1].offset_encoding)
    vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, ctx)
        if not result or vim.tbl_isempty(result) then
            vim.schedule(tag_jump)
            return
        end
        local location = vim.islist(result) and result[1] or result
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        vim.lsp.util.show_document(location, client.offset_encoding, { focus = true, reuse_win = true })
    end)
end

return {
    "ludovicchabant/vim-gutentags",
    -- Load before buffers are read so gutentags' BufReadPost handler is registered in time.
    event = { "BufReadPre", "BufNewFile" },
    init = function()
        -- Disabled globally; switched on per-buffer for shell filetypes only (autocmd below).
        vim.g.gutentags_enabled = 0
        vim.g.gutentags_modules = { "ctags" }
        vim.g.gutentags_ctags_executable = "ctags"
        -- Keep generated tag files in the cache dir, never inside the project tree.
        vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/ctags"
        -- Only index shell symbols, regardless of what else lives in the project.
        vim.g.gutentags_ctags_extra_args = { "--languages=Sh,Zsh" }

        local group = vim.api.nvim_create_augroup("GutentagsShell", { clear = true })

        local function set_keymaps(bufnr)
            local opts = { buffer = bufnr, noremap = true, silent = true }
            vim.keymap.set("n", "<leader>gD", lsp_or_tag,
                vim.tbl_extend("force", opts, { desc = "Goto definition (LSP → ctags)" }))
            vim.keymap.set("n", "<leader>td", tag_jump,
                vim.tbl_extend("force", opts, { desc = "Goto definition (ctags)" }))
        end

        -- Enable gutentags + map keys for shell buffers. Covers the case where no LSP attaches.
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = { "sh", "bash", "zsh" },
            callback = function(args)
                vim.b.gutentags_enabled = 1
                set_keymaps(args.buf)
            end,
        })

        -- bashls maps <leader>gD synchronously on attach; vim.schedule re-applies the smart
        -- mapping afterwards so it wins regardless of autocmd ordering.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = group,
            callback = function(args)
                if vim.tbl_contains({ "sh", "bash", "zsh" }, vim.bo[args.buf].filetype) then
                    vim.schedule(function()
                        if vim.api.nvim_buf_is_valid(args.buf) then
                            set_keymaps(args.buf)
                        end
                    end)
                end
            end,
        })
    end,
}
