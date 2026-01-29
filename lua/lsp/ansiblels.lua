-- ================================================================================================
-- TITLE : ansiblels (Ansible Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/ansible/ansible-language-server
-- ================================================================================================

-- Function to find the appropriate binary (checks venv first, then system)
local function find_binary(name)
    -- Check for virtual environment
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        local venv_bin = venv .. "/bin/" .. name
        if vim.fn.executable(venv_bin) == 1 then
            return venv_bin
        end
    end

    -- Check for .venv in project root
    local root = vim.fn.getcwd()
    local local_venv_bin = root .. "/.venv/bin/" .. name
    if vim.fn.executable(local_venv_bin) == 1 then
        return local_venv_bin
    end

    -- Fall back to system binary
    return name
end

-- Find binaries before config
local ansible_path = find_binary("ansible")
local python_path = find_binary("python3")
local ansible_lint_path = find_binary("ansible-lint")

vim.lsp.config("ansiblels", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    cmd = { "ansible-language-server", "--stdio" },
    settings = {
        ansible = {
            ansible = {
                path = ansible_path,
            },
            executionEnvironment = {
                enabled = false,
            },
            python = {
                interpreterPath = python_path,
            },
            validation = {
                enabled = true,
                lint = {
                    enabled = true,
                    path = ansible_lint_path,
                },
            },
        },
    },

    filetypes = {
        "yaml.ansible",
    },
    root_markers = { "ansible.cfg", ".ansible-lint", "playbook.yml", "playbooks/", "pyproject.toml", ".git" },
})

-- Enable ansiblels for its filetypes
vim.lsp.enable("ansiblels")
