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

-- space between tmux and nvim
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.o.cmdheight = 1
    end,
})
--
-- Docker compose
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("Docker-compose", { clear = true }),
    pattern = { "docker-compose*.yaml", "docker-compose*.yml" },
    command = "set filetype=yaml.docker-compose",
})

-- Jenkinsfile pattern highlight treesitter
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("Jenkinsfile", { clear = true }),
    pattern = { "Jenkinsfile-*", "Jenkinsfile", "jenkinsfile", "jenkinsfile-*" },
    command = "set filetype=groovy",
})

-- Dockerfile pattern highlight treesitter
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("Dockerfile", { clear = true }),
    pattern = { "Dockerfile-*", "Dockerfile", "dockerfile", "dockerfile-*", "Dockerfile*", "dockerfile*" },
    command = "set filetype=dockerfile",
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

-- relativenumber on off
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = augroup,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = augroup,
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
