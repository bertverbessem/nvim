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

        -- ansible-doc hover: open floating terminal with full ansible-doc output
        local function ansible_doc_hover()
            local line = vim.api.nvim_get_current_line()
            local module = line:match("([%w_]+%.[%w_]+%.[%w_]+)%s*:")
                or line:match("([%w_]+%.[%w_]+%.[%w_]+)")
            if not module then
                module = vim.fn.expand("<cWORD>"):gsub(":$", "")
            end
            if not module or module == "" then
                vim.notify("No module found under cursor", vim.log.levels.WARN)
                return
            end
            local width = math.floor(vim.o.columns * 0.85)
            local height = math.floor(vim.o.lines * 0.80)
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = width,
                height = height,
                row = math.floor((vim.o.lines - height) / 2),
                col = math.floor((vim.o.columns - width) / 2),
                style = "minimal",
                border = "rounded",
                title = " ansible-doc: " .. module .. " ",
                title_pos = "center",
            })
            vim.fn.termopen("ansible-doc " .. module, {
                on_exit = function()
                    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })
                end,
            })
            vim.api.nvim_buf_set_keymap(buf, "t", "q", "<C-\\><C-n><cmd>close<cr>", { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(buf, "t", "<Esc>", "<C-\\><C-n><cmd>close<cr>", { noremap = true, silent = true })
            vim.cmd("startinsert")
        end

        vim.keymap.set("n", "<leader>ah", ansible_doc_hover, { buffer = args.buf, desc = "ansible-doc hover" })
    end,
})

-- Stop yamlls after it attaches to an ansible file
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        if not args.data or not args.data.client_id then
            return
        end
        local client = vim.lsp.get_clients({ id = args.data.client_id })[1]
        if not client then
            return
        end

        if client.name == "yamlls" and vim.bo[args.buf].filetype == "yaml.ansible" then
            client:stop()
        end
    end,
})

-- space between tmux and nvim
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.o.cmdheight = 1
    end,
})

-- Autovalidate Jenkinsfile
--- Create a flag
local flag = false

--- Create a namespace
local namespace_id = vim.api.nvim_create_namespace("jenkinsfile_linter")

--- Autovalidate Jenkinsfile
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("AutoValidateJenkinsfile", { clear = true }),
    pattern = { "Jenkinsfile-*", "Jenkinsfile", "jenkinsfile", "jenkinsfile-*", "deploy.groovy" },
    callback = function()
        -- Check the first line of the buffer
        local first_line = vim.fn.getline(1)
        if first_line:find("@Library") then
            return
        end
        -- Check the flag
        if flag then
            -- Reset the flag
            flag = false
        else
            -- Set the flag
            flag = true
            -- log the buffer name and event
            -- print("Buffer name: " .. vim.fn.expand("%"))
            -- print("Event: BufWritePost")
            -- create curl command
            local user = os.getenv("JENKINS_USER_ID")
            local token = os.getenv("JENKINS_API_TOKEN")
            local jenkins_url = os.getenv("JENKINS_URL")
            local curl_command = "curl --silent --user "
                .. user
                .. ":"
                .. token
                .. " -X POST -F 'jenkinsfile=<"
                .. vim.fn.expand("%:p")
                .. "' "
                .. jenkins_url
                .. "/pipeline-model-converter/validate"
            -- execute command and handle output

            local output = vim.fn.system(curl_command)
            local msg, line_str, col_str = output:match("WorkflowScript.+%d+: (.+) @ line (%d+), column (%d+).")
            if line_str and col_str then
                local line = tonumber(line_str) - 1
                local col = tonumber(col_str) - 1

                local diag = {
                    bufnr = vim.api.nvim_get_current_buf(),
                    lnum = line,
                    end_lnum = line,
                    col = col,
                    end_col = col,
                    severity = vim.diagnostic.severity.ERROR,
                    message = msg,
                    source = "jenkinsfile linter",
                }

                -- print the parsed output and the diagnostic message
                -- print("Parsed output: " .. msg .. ", " .. line_str .. ", " .. col_str)
                -- print("Diagnostic message: " .. vim.inspect(diag))

                vim.diagnostic.set(namespace_id, vim.api.nvim_get_current_buf(), { diag })
                vim.diagnostic.show(namespace_id, vim.api.nvim_get_current_buf())

                -- Notify the user of the error
                vim.notify("Error: " .. msg, vim.log.levels.ERROR)
            else
                -- If the output does not match the error pattern, assume it's a success message
                vim.notify(output, vim.log.levels.INFO)
            end
        end
    end,
})

-- Auto-reload files changed externally (e.g. by Claude Code)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    pattern = "*",
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

-- relativenumber on off
local relative_number_group = vim.api.nvim_create_augroup("RelativeNumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
    pattern = "*",
    group = relative_number_group,
    callback = function()
        if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
            vim.opt.relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
    pattern = "*",
    group = relative_number_group,
    callback = function()
        if vim.o.nu then
            vim.opt.relativenumber = false
            -- Conditional taken from https://github.com/rockyzhang24/dotfiles/commit/03dd14b5d43f812661b88c4660c03d714132abcf
            -- Workaround for https://github.com/neovim/neovim/issues/32068
            if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then
                vim.cmd("redraw")
            end
        end
    end,
})

--
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.schedule(function()
            -- remove treesitter <CR> mappings in this buffer
            pcall(vim.keymap.del, "n", "<CR>", { buffer = true })
            pcall(vim.keymap.del, "x", "<CR>", { buffer = true })

            -- normal mode <CR>: toggle checkbox
            vim.keymap.set("n", "<CR>", function()
                local line = vim.api.nvim_get_current_line()
                local new_line

                if line:match("%- %[ %]") then
                    new_line = line:gsub("%- %[ %]", "- [x]", 1)
                elseif line:match("%- %[x%]") then
                    new_line = line:gsub("%- %[x%]", "- [ ]", 1)
                end

                if new_line then
                    vim.api.nvim_set_current_line(new_line)
                else
                    -- fallback: feed <CR> to existing mappings
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
                end
            end, { buffer = true, noremap = true, silent = true })

            -- visual mode <CR>: toggle checkboxes in selection
            vim.keymap.set("x", "<CR>", function()
                local start_row = vim.fn.line("'<")
                local end_row = vim.fn.line("'>")
                for lnum = start_row, end_row do
                    local line = vim.fn.getline(lnum)
                    local new_line
                    if line:match("%- %[ %]") then
                        new_line = line:gsub("%- %[ %]", "- [x]", 1)
                    elseif line:match("%- %[x%]") then
                        new_line = line:gsub("%- %[x%]", "- [ ]", 1)
                    end
                    if new_line then
                        vim.fn.setline(lnum, new_line)
                    end
                end
            end, { buffer = true, noremap = true, silent = true })
        end)
    end,
})

-- disable automatic comment on newline
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Continue - [ ] on enter
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
    -- pattern = "markdown",
    pattern = vim.fn.expand("~/.local/share/notes/todo.md"),
    callback = function()
        vim.keymap.set("i", "<CR>", function()
            local line = vim.api.nvim_get_current_line()
            if line:match("^%s*%- %[.?%]") then
                local indent = line:match("^%s*") or ""
                return "\n" .. indent .. "- [ ] "
            else
                return "\n"
            end
        end, { buffer = true, expr = true })
    end,
})

-- Disable highlight on tmux
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tmux",
    callback = function()
        vim.treesitter.stop(0)
    end,
})
-- Setup LSP keymaps using LspAttach autocmd (replaces deprecated on_attach)
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local client = vim.lsp.get_clients({ id = ev.data.client_id })[1]
        local bufnr = ev.buf

        local keymap = vim.keymap.set
        local opts = {
            noremap = true, -- prevent recursive mapping
            silent = true, -- don't print the command to the cli
            buffer = bufnr, -- restrict the keymap to the local buffer number
        }

        -- native neovim keymaps
        keymap("n", "<leader>gD", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- goto definition
        keymap("n", "<leader>gS", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts) -- goto definition in split
        keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- Code actions
        keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts) -- Rename symbol
        keymap("n", "<leader>D", "<cmd>lua vim.diagnostic.open_float({ scope = 'line' })<CR>", opts) -- Line diagnostics (float)
        keymap("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- Cursor diagnostics
        keymap("n", "<leader>pd", "<cmd>lua vim.diagnostic.jump({ count = -1 })<CR>", opts)
        keymap("n", "<leader>nd", "<cmd>lua vim.diagnostic.jump({ count = 1 })<CR>", opts)
        keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- hover documentation
        keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts) -- show all references
        keymap("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation

        -- Order Imports (if supported by the client LSP)
        if client and client.server_capabilities and client.server_capabilities.codeActionProvider then
            keymap("n", "<leader>oi", function()
                vim.lsp.buf.code_action({
                    context = {
                        only = { "source.organizeImports" },
                        diagnostics = {},
                    },
                    apply = true,
                })
                -- format after changing import order
                vim.defer_fn(function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end, 50) -- slight delay to allow for the import order to go first
            end, opts)
        end
    end,
})

-- fix .env
local lsp_hacks = vim.api.nvim_create_augroup("LspHacks", { clear = true })

-- Stop diagnostics in .env files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    group = lsp_hacks,
    pattern = { ".env*", ".docker.env*" },
    callback = function(e)
        vim.diagnostic.enable(false, { bufnr = e.buf })
    end,
})
