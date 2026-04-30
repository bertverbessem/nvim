-- ================================================================================================
-- TITLE: NeoVim keymaps
-- ABOUT: sets some quality-of-life keymaps
-- ================================================================================================

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Center screen when jumping
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Buffer navigation
map("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Splitting & Resizing
map("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sx", "<Cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Better J behavior
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Quick config editing
map("n", "<leader>rc", "<Cmd>e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

-- File Explorer
map("n", "<leader>F", "<Cmd>Neotree focus<CR>", { desc = "Focus on File Explorer" })
map("n", "<leader>e", "<Cmd>Neotree toggle<CR>", { desc = "Toggle File Explorer" })

-- escape
map("i", "jk", "<Esc>", { desc = "Normal mode" })

--Decrypt an Ansible Vault-encrypted file
map("n", "<leader>vd", "<cmd>silent !ansible-vault decrypt % <CR><CR>", { desc = "[V]ault [D]ecrypt" })

--Revert changes to a Git-tracked file
map("n", "<leader>vr", function()
    require("gitsigns").reset_buffer()
    vim.cmd("silent! e")
    vim.cmd("silent! w") -- Save the file
end, { desc = "[V]ault [R]eset to git version" })

--Encrypt a file using Ansible Vault
map(
    "n",
    "<leader>ve",
    "<cmd>silent !ansible-vault encrypt --encrypt-vault-id default --vault-pass-file ~/.vault_pass.txt % <CR>",
    { desc = "[V]ault [E]ncrypt" }
)
--Save the current file with sudo privileges
map("n", "<leader>w!", "<cmd>w !sudo tee % >/dev/null<CR>", { desc = "[W]rite [S]udo" })

--Use leader q to quit
map("n", "<leader>q", "<cmd>q!<CR>", { desc = "Quit" })

--Use leader w to save
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })

--Use leader W to save and quit
map("n", "<leader>W", "<cmd>wq<CR>", { desc = "Save and [Q]uit" })

--Disable the 'Q' key in normal mode
map("n", "Q", "<nop>")
--Move selected lines down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")

--Move selected lines up in visual mode
map("v", "K", ":m '<-2<CR>gv=gv")

--Increment the number under the cursor in normal mode
map("n", "+", "<C-a>")

--Decrement the number under the cursor in normal mode
map("n", "-", "<C-x>")

--Delete word without affecting the system clipboard
map("n", "dw", '"_dw', { desc = "Delete [W]ord" })

map({ "n", "v", "x" }, "<leader>y", [["*y]], { desc = "Yank to clipboard" }) -- Yank to clipboard
map("n", "<leader>yy", [["+yg_]], { desc = "Yank line around" }) -- Normal mode: Yank entire line to system clipboard (including trailing whitespace)
map("n", "<leader>Y", [["+yy]], { desc = "Yank line inside" }) -- Normal mode: Yank entire line to system clipboard (excluding trailing whitespace)
-- Pkeymap.set
map({ "n", "v", "x" }, "<leader>p", [["+p]], { desc = "Paste from clipboard" }) -- Visual mode: Paste from system clipboard
map({ "n", "v", "x" }, "<leader>P", [["+P]], { desc = "Paste before cursor from clipbpoard" }) -- Normal mode: Paste before cursor from system clipboard
map("n", "<leader>cb", "<cmd>silent !shellcheck -s bash -f diff % | patch %<cr><cr>", { desc = "Shellcheck" })

-- copy current filepath to clipboard
map("n", "<leader>yc", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
    vim.notify("Current file path copied to clipboard")
end, { desc = "Copy current filepath to clipboard" })

-- Helper: get indentation of current line
local function get_indent(line)
    return line:match("^(%s*)") or ""
end

-- Encrypt variable value under cursor
vim.keymap.set("n", "<leader>vse", function()
    local line_nr = vim.fn.line(".")
    local line = vim.fn.getline(line_nr)

    -- Match variable_name: "value" or variable_name: value (unquoted)
    local var_name, value = line:match([[^%s*([%w_]+)%s*:%s*['"](.-)['"]%s*$]])
    if not var_name then
        var_name, value = line:match("^%s*([%w_]+)%s*:%s*(.-)%s*$")
    end
    if not var_name or not value or value == "" then
        vim.notify('❌ Line must be in format variable_name: "value"', vim.log.levels.ERROR)
        return
    end

    local indent = get_indent(line)

    -- Encrypt with proper shell escaping
    local cmd = string.format(
        "ansible-vault encrypt_string --vault-pass-file ~/.vault_pass.txt --encrypt-vault-id default %s --name %s",
        vim.fn.shellescape(value),
        vim.fn.shellescape(var_name)
    )
    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 or result == "" then
        vim.notify("❌ Encryption failed: " .. result, vim.log.levels.ERROR)
        return
    end

    -- Add original indentation to each line
    local encrypted_lines = {}
    for _, l in ipairs(vim.split(result, "\n")) do
        if l ~= "" then -- Skip empty lines
            table.insert(encrypted_lines, indent .. l)
        end
    end

    -- Replace current line with multi-line vault block
    vim.api.nvim_buf_set_lines(0, line_nr - 1, line_nr, false, encrypted_lines)
    vim.notify("🔐 Encrypted " .. var_name, vim.log.levels.INFO)
    vim.cmd("silent! w") -- Save the file
end, { desc = "Encrypt variable value under cursor" })

-- ShellCheck disable helpers
local function shellcheck_disable_line(lnum_0)
    local diags = vim.diagnostic.get(0, { lnum = lnum_0 })
    local codes = {}
    local msgs = {}
    local seen = {}
    for _, d in ipairs(diags) do
        if d.source == "shellcheck" and d.code and not seen[d.code] then
            table.insert(codes, d.code)
            table.insert(msgs, d.code .. ": " .. (d.message or ""))
            seen[d.code] = true
        end
    end
    if #codes == 0 then
        return false
    end
    local line_text = vim.api.nvim_buf_get_lines(0, lnum_0, lnum_0 + 1, false)[1] or ""
    local indent = line_text:match("^(%s*)") or ""
    local desc = indent .. "# " .. table.concat(msgs, ", ")
    local directive = indent .. "# shellcheck disable=" .. table.concat(codes, ",")
    vim.api.nvim_buf_set_lines(0, lnum_0, lnum_0, false, { desc, directive })
    return true
end

map("n", "<leader>xd", function()
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    if not shellcheck_disable_line(row) then
        vim.notify("No shellcheck diagnostics on this line", vim.log.levels.WARN)
    end
end, { desc = "ShellCheck: disable diagnostic on current line" })

map("v", "<leader>xd", function()
    local start_row = vim.fn.line("v") - 1
    local end_row = vim.fn.line(".") - 1
    if start_row > end_row then
        start_row, end_row = end_row, start_row
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
    local inserted = 0
    -- reverse iteration: inserting above a higher row doesn't affect lower row indices
    for row = end_row, start_row, -1 do
        if shellcheck_disable_line(row) then
            inserted = inserted + 1
        end
    end
    if inserted == 0 then
        vim.notify("No shellcheck diagnostics in selection", vim.log.levels.WARN)
    end
end, { desc = "ShellCheck: disable diagnostics on selected lines" })

-- decrypt ansible vault string
vim.keymap.set({ "v", "n" }, "<leader>vsd", function()
    local vault_lines = {}
    local start_line_nr = nil
    local end_line_nr = nil

    if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
        -- Visual mode: capture line numbers before leaving visual mode
        start_line_nr = vim.fn.line("v")
        end_line_nr = vim.fn.line(".")
        if start_line_nr > end_line_nr then
            start_line_nr, end_line_nr = end_line_nr, start_line_nr
        end
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
        vault_lines = vim.api.nvim_buf_get_lines(0, start_line_nr - 1, end_line_nr, false)
    else
        -- Normal mode: auto-detect vault block
        local current_line = vim.fn.line(".")
        local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        -- If cursor is on the !vault declaration line, search forward for vault block
        local search_from = current_line
        if buf_lines[current_line]:match("!vault") then
            for i = current_line + 1, #buf_lines do
                if buf_lines[i]:match("%$ANSIBLE_VAULT") then
                    search_from = i
                    break
                end
            end
        end

        -- Find vault start (look backwards from cursor)
        for i = search_from, 1, -1 do
            if buf_lines[i]:match("%$ANSIBLE_VAULT") then
                start_line_nr = i
                break
            end
        end

        if not start_line_nr then
            vim.notify("❌ No vault block found", vim.log.levels.ERROR)
            return
        end

        -- Collect vault lines from start until end of vault content
        for i = start_line_nr, #buf_lines do
            local line = buf_lines[i]
            if line:match("^%s*[a-f0-9]+%s*$") or line:match("%$ANSIBLE_VAULT") then
                table.insert(vault_lines, line:match("^%s*(.-)%s*$")) -- trim whitespace
                end_line_nr = i
            elseif #vault_lines > 0 then
                -- Stop when we hit a non-vault line after collecting vault content
                break
            end
        end
    end

    if #vault_lines == 0 then
        vim.notify("❌ No vault content found", vim.log.levels.ERROR)
        return
    end

    -- Get the variable name from the line before the vault block
    local var_name = nil
    if start_line_nr > 1 then
        local prev_line = vim.api.nvim_buf_get_lines(0, start_line_nr - 2, start_line_nr - 1, false)[1]
        var_name = prev_line:match("^%s*([%w_]+)%s*:%s*!vault%s*|?%s*$")
    end

    -- Write vault content to temp file with proper format
    local tmpname = vim.fn.tempname()
    local f = io.open(tmpname, "w")
    if not f then
        vim.notify("❌ Failed to create temporary file", vim.log.levels.ERROR)
        return
    end

    -- Write each vault line as-is (they should already be properly formatted)
    for _, line in ipairs(vault_lines) do
        f:write(line .. "\n")
    end
    f:close()

    -- Decrypt using ansible-vault
    local cmd = string.format("ansible-vault decrypt --vault-pass-file ~/.vault_pass.txt %s --output=-", tmpname)
    local result = vim.fn.system(cmd)

    -- Clean up temp file
    os.remove(tmpname)

    if vim.v.shell_error ~= 0 then
        vim.notify("❌ Decryption failed: " .. result, vim.log.levels.ERROR)
        return
    end
    -- Get the original indentation from the variable declaration line (not the vault content)
    local indent = ""
    if var_name then
        -- Get indentation from the line with the variable name
        local var_line = vim.api.nvim_buf_get_lines(0, start_line_nr - 2, start_line_nr - 1, false)[1]
        indent = get_indent(var_line)
    else
        -- Fallback: get indentation from first vault line
        local original_first_line = vim.api.nvim_buf_get_lines(0, start_line_nr - 1, start_line_nr, false)[1]
        indent = get_indent(original_first_line)
    end

    -- Remove trailing newline from decrypted content
    local decrypted_value = result:gsub("\n$", "")

    -- Format as simple variable assignment if we found a variable name
    local new_lines = {}
    local cursor_line = start_line_nr
    if var_name then
        -- Replace with simple variable: "value" format
        table.insert(new_lines, indent .. var_name .. ': "' .. decrypted_value .. '"')
        -- Also replace the previous line that had the variable name
        vim.api.nvim_buf_set_lines(0, start_line_nr - 2, end_line_nr, false, new_lines)
        cursor_line = start_line_nr - 1 -- Position on the variable line
    else
        -- Fallback: just replace with decrypted content
        for _, line in ipairs(vim.split(decrypted_value, "\n")) do
            table.insert(new_lines, indent .. line)
        end
        vim.api.nvim_buf_set_lines(0, start_line_nr - 1, end_line_nr, false, new_lines)
        cursor_line = start_line_nr -- Position on first line of decrypted content
    end

    -- Position cursor on the decrypted content
    vim.api.nvim_win_set_cursor(0, { cursor_line, 0 })

    vim.notify("🔓 Vault content decrypted and replaced", vim.log.levels.INFO)
    vim.cmd("silent! w") -- Save the file
end, { desc = "Decrypt vault content under cursor or selection" })
