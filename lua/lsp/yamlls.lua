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
    root_markers = { ".git", "pyproject.toml", "setup.py" },
})

vim.lsp.enable("yamlls")
