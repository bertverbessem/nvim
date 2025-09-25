-- ================================================================================================
-- TITLE : ansiblels (Ansible Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/ansible/ansible-language-server
-- ================================================================================================

vim.lsp.config("ansiblels", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
        ansible = {
            ansible = {
                path = "ansible",
            },
            executionEnvironment = {
                enabled = false,
            },
            python = {
                interpreterPath = "python3",
            },
            validation = {
                enabled = true,
                lint = {
                    enabled = true,
                    path = "ansible-lint",
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
