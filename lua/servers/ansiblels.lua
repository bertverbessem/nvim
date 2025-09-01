-- ================================================================================================
-- TITLE : ansiblels (Ansible Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/ansible/ansible-language-server
-- ================================================================================================

--- @param lspconfig table The lspconfig module from nvim-lspconfig plugin
--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @param on_attach function Callback function executed when LSP attaches to a buffer
--- @return nil
return function(lspconfig, capabilities, on_attach)
    lspconfig.ansiblels.setup({
        on_attach = on_attach,
        capabilities = capabilities,
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
        root_dir = lspconfig.util.root_pattern("ansible.cfg", ".ansible-lint", "playbook.yml", "playbooks/", ".git"),
        single_file_support = true,
    })
end
