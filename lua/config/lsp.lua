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
}

for _, server in ipairs(lsp_servers) do
    require("lsp." .. server)
end
