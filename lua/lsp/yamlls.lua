vim.lsp.config("yamlls", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    filetypes = {
        "yaml",
        -- Exclude ansible filetypes to prevent conflicts with ansiblels
        -- "yaml.ansible", -- commented out
        -- "ansible",     -- commented out
    },
    settings = {
        yaml = {
            schemas = {
                -- Bitbucket Pipelines
                ["https://bitbucket.org/atlassian/bitbucket-pipelines-schema/raw/master/bitbucket-pipelines-schema.json"] = "bitbucket-pipelines.yml",
                -- Docker Compose
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                    "docker-compose*.yml",
                    "docker-compose*.yaml",
                },
            },
        },
    },
    -- Add root_dir pattern to avoid yamlls on ansible projects
    root_markers = { ".git", "pyproject.toml", "setup.py" },
})

vim.lsp.enable("yamlls")
