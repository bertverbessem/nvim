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

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Splitting & Resizing
map("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", "<Cmd>split<CR>", { desc = "Split window horizontally" })
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
map("n", "<leader>F", "<Cmd>NvimTreeFocus<CR>", { desc = "Focus on File Explorer" })
map("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- Find files inside ~/.config
-- map(
--     "n",
--     "<leader>fc",
--     "<cmd>FzfLua files search_paths={'~/.config/nvim','~/.config/radleynvim'} cwd=~/.config<CR>",
--     { desc = "Find files in nvim and radleynvim" }
-- )

-- escape
map("i", "jk", "<Esc>", { desc = "Normal mode" })

--Decrypt an Ansible Vault-encrypted file
map("n", "<leader>vd", "<cmd>silent !ansible-vault decrypt % <CR><CR>", { desc = "[V]ault [D]ecrypt" })

--Revert changes to a Git-tracked file
map("n", "<leader>vr", function()
    require("gitsigns").reset_buffer()
    vim.cmd("silent! e")
    vim.cmd("silent! w") -- Save the file
end, { desc = "[Vault] [R]e-encrypt" })

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

--Join lines in normal mode and move cursor to the end of the joined line
map("n", "J", "mzJ`z")

--Increment the number under the cursor in normal mode
map("n", "+", "<C-a>")

--Decrement the number under the cursor in normal mode
map("n", "-", "<C-x>")

--Delete word without affecting the system clipboard
map("n", "dw", 'vb"_d', { desc = "Delete [W]ord" })

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

-- grugfar
map({ "n", "x" }, "<leader>rl", function()
    local search = vim.fn.getreg("/")
    -- surround with \b if "word" search (such as when pressing `*`)
    if search and vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
        search = "\\b" .. search:sub(3, -3) .. "\\b"
    end
    require("grug-far").open({
        prefills = {
            search = search,
            path = vim.fn.expand("%:p:h"),
        },
    })
end, { desc = "grug-far: Search using @/ register value or visual selection" })

map({ "n", "x" }, "<leader>ri", function()
    require("grug-far").open(
        { visualSelectionUsage = "operate-within-range" },
        { prefills = { paths = vim.fn.expand("%:p:h") } }
    )
end, { desc = "grug-far: Search within range" })

map({ "n", "x", "v" }, "<leader>rw", function()
    require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>"), paths = vim.fn.expand("%:p:h") } })
end, { desc = "grug-far: current word" })

map("n", "<leader>ro", function()
    require("grug-far").open({ prefills = { paths = vim.fn.expand("%:p:h") } })
end, { desc = "grug-far: open" })

-- Helper: get indentation of current line
local function get_indent(line)
    return line:match("^(%s*)") or ""
end

-- Encrypt variable value under cursor
vim.keymap.set("n", "<leader>vse", function()
    local line_nr = vim.fn.line(".")
    local line = vim.fn.getline(line_nr)

    -- Match variable_name: "value"
    local var_name, value = line:match("^%s*([%w_]+)%s*:%s*['\"](.-)['\"]%s*$")
    if not var_name or not value then
        print('❌ Line must be in format variable_name: "value"')
        return
    end

    local indent = get_indent(line)

    -- Encrypt with proper shell escaping
    local cmd = string.format(
        "ansible-vault encrypt_string %s --name %s",
        vim.fn.shellescape(value),
        vim.fn.shellescape(var_name)
    )
    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 or result == "" then
        print("❌ Encryption failed")
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
    print("🔐 Encrypted " .. var_name)
end, { desc = "Encrypt variable value under cursor" })

-- decrypt ansible vault string
vim.keymap.set({ "v", "n" }, "<leader>vsd", function()
    local vault_lines = {}
    local start_line_nr = nil
    local end_line_nr = nil

    if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
        -- Visual mode: use selection
        local region = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"), { type = vim.fn.visualmode() })
        vault_lines = region
        start_line_nr = vim.fn.line("'<")
        end_line_nr = vim.fn.line("'>")
    else
        -- Normal mode: auto-detect vault block
        local current_line = vim.fn.line(".")
        local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        -- Find vault start (look backwards from cursor)
        for i = current_line, 1, -1 do
            if buf_lines[i]:match("$ANSIBLE_VAULT") then
                start_line_nr = i
                break
            end
        end

        if not start_line_nr then
            print("❌ No vault block found")
            return
        end

        -- Collect vault lines from start until end of vault content
        for i = start_line_nr, #buf_lines do
            local line = buf_lines[i]
            if line:match("^%s*[a-f0-9]+%s*$") or line:match("$ANSIBLE_VAULT") then
                table.insert(vault_lines, line:match("^%s*(.-)%s*$")) -- trim whitespace
                end_line_nr = i
            elseif #vault_lines > 0 then
                -- Stop when we hit a non-vault line after collecting vault content
                break
            end
        end
    end

    if #vault_lines == 0 then
        print("❌ No vault content found")
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
        print("❌ Failed to create temporary file")
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
        print("❌ Decryption failed: " .. result)
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

    print("🔓 Vault content decrypted and replaced")
end, { desc = "Decrypt vault content under cursor or selection" })

-- Snacks
-- floating terminal
map("n", "<leader>ft", function()
    require("snacks").terminal(nil, { cwd = require("utils.root").get_root() })
end, { desc = "Terminal (Root Dir)" })
map("n", "<c-/>", function()
    require("snacks").terminal(nil, { cwd = require("utils.root").get_current_dir() })
end, { desc = "Terminal (Current Dir)" })
map("n", "<c-_>", function()
    require("snacks").terminal(nil, { cwd = require("utils.root").get_current_dir() })
end, { desc = "which_key_ignore" })

-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
