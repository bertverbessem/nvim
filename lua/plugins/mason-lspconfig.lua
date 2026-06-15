return {
    {
        "mason-org/mason.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = { "revive", "gofumpt" },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        opts = {
            automatic_installation = true,
            ensure_installed = {
                "lua_ls",
                "bashls",
                "ansiblels",
                "basedpyright",
                "gopls",
                "jsonls",
                "dockerls",
                "terraformls",
                "yamlls",
                "groovyls",
                "nginx_language_server",
                "docker_compose_language_service",
                "ruff",
                "intelephense",
            },
        },
        -- dependencies = { "neovim/nvim-lspconfig" },
    },
}
