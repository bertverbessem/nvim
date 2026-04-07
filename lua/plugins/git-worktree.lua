-- ================================================================================================
-- TITLE : git-worktree
-- ABOUT : Git worktree management using Snacks picker
-- ================================================================================================

local function get_bare_root()
    local git_common = vim.fn.systemlist("git rev-parse --git-common-dir")[1]
    if vim.v.shell_error ~= 0 or not git_common then
        return nil
    end
    -- Resolve to absolute path if relative
    if not git_common:match("^/") then
        git_common = vim.fn.getcwd() .. "/" .. git_common
    end
    -- For bare repos, the parent of .git is the project root
    return vim.fn.fnamemodify(git_common, ":h")
end

local function get_worktrees()
    local output = vim.fn.systemlist("git worktree list --porcelain")
    local worktrees = {}
    local current = {}

    for _, line in ipairs(output) do
        if line:match("^worktree ") then
            current = { path = line:match("^worktree (.+)") }
        elseif line:match("^HEAD ") then
            current.head = line:match("^HEAD (.+)")
        elseif line:match("^branch ") then
            current.branch = line:match("^branch refs/heads/(.+)")
        elseif line == "bare" then
            current.bare = true
        elseif line == "detached" then
            current.detached = true
        elseif line == "" and current.path then
            table.insert(worktrees, current)
            current = {}
        end
    end
    if current.path then
        table.insert(worktrees, current)
    end

    return worktrees
end

local function switch_to_worktree(path)
    local old_cwd = vim.fn.getcwd()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            if name ~= "" and name:find(old_cwd, 1, true) == 1 then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end

    vim.cmd.cd(path)

    -- Set ANSIBLE_ROLES_PATH for the new worktree
    local roles_path = path .. "/roles"
    if vim.fn.isdirectory(roles_path) == 1 then
        vim.env.ANSIBLE_ROLES_PATH = roles_path
    end

    Snacks.notify.info("Switched to worktree: " .. path)
    -- vim.schedule(function()
    --     Snacks.picker.files()
    -- end)
end

local function list_worktrees()
    local worktrees = get_worktrees()
    local cwd = vim.fn.getcwd()

    Snacks.picker({
        source = "worktrees",
        title = "Git Worktrees",
        finder = function()
            local items = {}
            for _, wt in ipairs(worktrees) do
                local label = wt.branch or (wt.detached and "detached" or "bare")
                local is_current = vim.fn.resolve(wt.path) == vim.fn.resolve(cwd)
                table.insert(items, {
                    text = (is_current and "* " or "  ") .. label .. " " .. wt.path,
                    item = wt,
                    label = label,
                    path = wt.path,
                    is_current = is_current,
                })
            end
            return items
        end,
        format = function(item)
            local ret = {} ---@type snacks.picker.Highlight[]
            if item.is_current then
                ret[#ret + 1] = { "* ", "SnacksPickerSpecial" }
            else
                ret[#ret + 1] = { "  ", "SnacksPickerComment" }
            end
            ret[#ret + 1] = { item.label, item.is_current and "SnacksPickerSpecial" or "SnacksPickerFile" }
            ret[#ret + 1] = { " ", "SnacksPickerComment" }
            ret[#ret + 1] = { item.path, "SnacksPickerComment" }
            return ret
        end,
        layout = "vertical",
        confirm = function(picker, item)
            picker:close()
            if item and not item.is_current then
                if item.item.bare then
                    Snacks.notify.warn("Cannot switch to bare repo root")
                    return
                end
                switch_to_worktree(item.path)
            end
        end,
        actions = {
            delete_worktree = function(picker, item)
                if not item then
                    return
                end
                if item.is_current then
                    Snacks.notify.warn("Cannot remove the current worktree")
                    return
                end
                if item.item.bare then
                    Snacks.notify.warn("Cannot remove bare repo root")
                    return
                end
                vim.ui.input({ prompt = "Remove worktree " .. item.label .. "? (y/N): " }, function(input)
                    if input and input:lower() == "y" then
                        local result = vim.fn.system("git worktree remove " .. vim.fn.shellescape(item.path))
                        if vim.v.shell_error == 0 then
                            -- Also delete the local and remote branch
                            if item.item.branch then
                                vim.fn.system("git branch -d " .. vim.fn.shellescape(item.item.branch))
                                vim.fn.system("git push -u origin --delete " .. vim.fn.shellescape(item.item.branch))
                            end
                            Snacks.notify.info("Removed worktree and branch: " .. item.label)
                            picker:close()
                            vim.schedule(list_worktrees)
                        else
                            Snacks.notify.error("Failed to remove worktree:\n" .. result)
                        end
                    end
                end)
            end,
        },
        win = {
            input = {
                keys = {
                    ["dd"] = { "delete_worktree", mode = { "n" }, desc = "Delete worktree" },
                },
            },
            list = {
                keys = {
                    ["dd"] = { "delete_worktree", mode = { "n" }, desc = "Delete worktree" },
                },
            },
        },
    })
end

local function create_worktree()
    local bare_root = get_bare_root()
    if not bare_root then
        Snacks.notify.error("Not in a git repository")
        return
    end

    vim.ui.input({ prompt = "Branch name for new worktree: " }, function(branch)
        if not branch or branch == "" then
            return
        end

        local worktree_path = bare_root .. "/" .. branch

        local branch_exists = vim.fn.system("git rev-parse --verify " .. vim.fn.shellescape(branch) .. " 2>/dev/null")
        local cmd
        if vim.v.shell_error == 0 and branch_exists ~= "" then
            cmd = "git worktree add " .. vim.fn.shellescape(worktree_path) .. " " .. vim.fn.shellescape(branch)
        else
            cmd = "git worktree add -b " .. vim.fn.shellescape(branch) .. " " .. vim.fn.shellescape(worktree_path)
        end

        local result = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then
            switch_to_worktree(worktree_path)
        else
            Snacks.notify.error("Failed to create worktree:\n" .. result)
        end
    end)
end

return {
    dir = ".",
    keys = {
        {
            "<leader>gw",
            list_worktrees,
            desc = "Git Worktrees",
        },
        {
            "<leader>gW",
            create_worktree,
            desc = "Create Git Worktree",
        },
    },
}
