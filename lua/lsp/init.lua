-- Setup LSP keymaps via autocmd
require("utils.lsp")

-- Language Server Protocol (LSP) configurations
require("servers.lua_ls")
require("servers.pyright")
require("servers.gopls")
require("servers.jsonls")
require("servers.bashls")
require("servers.dockerls")
require("servers.yamlls")
require("servers.ansiblels")
require("servers.terraformls")
