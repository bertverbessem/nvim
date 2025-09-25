-- ================================================================================================
-- TITLE : lua_ls (Lua Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/LuaLS/lua-language-server
-- ================================================================================================

vim.lsp.config("lua_ls", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim", "Snacks" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
                },
            },
        },
    },
})
vim.lsp.enable("lua_ls")
