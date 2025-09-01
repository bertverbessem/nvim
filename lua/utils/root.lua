local M = {}

--- Find the root directory of a project by looking for .git
--- @param path string|nil Optional starting path (defaults to current buffer's directory)
--- @return string|nil root_path The root directory path, or nil if not found
function M.get_git_root(path)
    path = path or vim.fn.expand("%:p:h")

    -- Handle case where path might be empty or nil
    if not path or path == "" then
        path = vim.fn.getcwd()
    end

    -- Start from the given path and traverse upwards
    local current_path = vim.fn.fnamemodify(path, ":p")

    while current_path ~= "/" do
        local git_path = current_path .. "/.git"

        -- Check if .git exists (either as directory or file for git worktrees)
        if vim.fn.isdirectory(git_path) == 1 or vim.fn.filereadable(git_path) == 1 then
            return current_path
        end

        -- Move up one directory
        local parent = vim.fn.fnamemodify(current_path, ":h")
        if parent == current_path then
            -- Reached filesystem root
            break
        end
        current_path = parent
    end

    return nil
end
--- Get the directory path of the current file
--- @param path string|nil Optional file path (defaults to current buffer)
--- @return string|nil dir_path The directory path, or nil if not in a file
function M.get_current_dir(path)
    path = path or vim.fn.expand("%:p")

    -- Check if we have a valid file path
    if not path or path == "" then
        return nil
    end

    -- Get the directory part of the path
    local dir_path = vim.fn.fnamemodify(path, ":h")

    -- Special handling for ansible-devbox projects
    if string.match(dir_path, "ansible%-devbox") then
        local roles_pos = string.find(dir_path, "/roles/")
        if roles_pos then
            -- Find the next directory after /roles/
            local after_roles = string.sub(dir_path, roles_pos + 7) -- +7 to skip "/roles/"
            local next_slash = string.find(after_roles, "/")
            if next_slash then
                local role_dir = string.sub(after_roles, 1, next_slash - 1)
                return string.sub(dir_path, 1, roles_pos + 6) .. role_dir -- roles_pos + 6 to include "/roles/"
            else
                -- We're directly in a role directory
                return dir_path
            end
        end
    end

    return dir_path
end

--- Get project root, fallback to current working directory
--- @param path string|nil Optional starting path
--- @return string root_path The root directory path
function M.get_root(path)
    return M.get_git_root(path) or vim.fn.getcwd()
end

return M
