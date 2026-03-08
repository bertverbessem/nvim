-- Load all LSP configurations
local lsp_servers = {
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
}

for _, server in ipairs(lsp_servers) do
    require("lsp." .. server)
end
