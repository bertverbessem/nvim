-- ================================================================================================
-- TITLE : lua_ls (Lua Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/LuaLS/lua-language-server
-- ================================================================================================

vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    capabilities = require("config.capabilities").get(),
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "Snacks" } },
            workspace = {
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.enable("lua_ls")
