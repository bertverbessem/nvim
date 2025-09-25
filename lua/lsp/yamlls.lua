vim.lsp.config("yamlls", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = {
        "yaml",
        -- Exclude ansible filetypes to prevent conflicts with ansiblels
        -- "yaml.ansible", -- commented out
        -- "ansible",     -- commented out
    },
    settings = {
        yaml = {
            -- your existing yaml settings
        },
    },
    -- Add root_dir pattern to avoid yamlls on ansible projects
    root_dir = function(fname)
        -- Don't start yamlls if we detect ansible files
        local ansible_patterns = { "ansible.cfg", ".ansible-lint", "playbook.yml", "playbooks/" }
        for _, pattern in ipairs(ansible_patterns) do
            if vim.fs.root(fname, pattern) then
                return nil
            end
        end
        -- Use default yaml root patterns
        return vim.fs.root(fname, { ".git", "pyproject.toml", "setup.py" })
    end,
})

vim.lsp.enable("yamlls")
