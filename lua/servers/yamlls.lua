return function(lspconfig, capabilities, on_attach)
    lspconfig.yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
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
            local util = lspconfig.util
            -- Don't start yamlls if we detect ansible files
            local ansible_patterns = { "ansible.cfg", ".ansible-lint", "playbook.yml", "playbooks/" }
            if util.root_pattern(unpack(ansible_patterns))(fname) then
                return nil
            end
            -- Use default yaml root patterns
            return util.root_pattern(".git", "pyproject.toml", "setup.py")(fname)
        end,
    })
end
