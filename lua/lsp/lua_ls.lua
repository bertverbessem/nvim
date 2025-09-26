-- ================================================================================================
-- TITLE : lua_ls (Lua Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/LuaLS/lua-language-server
-- ================================================================================================

-- luacheck: globals vim Snacks

vim.lsp.config("lua_ls", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            local luarc = vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")
            if path ~= vim.fn.stdpath("config") and luarc then
                return
            end
        end
    end,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = { "lua/?.lua", "lua/?/init.lua" },
            },
            diagnostics = { globals = { "vim", "Snacks" } },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath("config") .. "/lua",
                    "${3rd}/luv/library",
                },
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.enable("lua_ls")
