-- ================================================================================================
-- TITLE : blink.cmp
-- ABOUT : Performant, batteries-included completion plugin for Neovim.
-- LINKS :
--   > github                  : https://github.com/saghen/blink.cmp
--   > luasnip (dep)           : https://github.com/L3MON4D3/LuaSnip
--   > friendly-snippets (dep) : https://github.com/rafamadriz/friendly-snippets
-- ================================================================================================

return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
    },
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_lua").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
        })

        require("blink.cmp").setup({
            snippets = { preset = "luasnip" },
            keymap = {
                preset = "none",
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-e>"] = { "cancel", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
            },
            completion = {
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false,
                    },
                },
                menu = {
                    border = "rounded",
                    draw = {
                        columns = {
                            { "kind_icon" },
                            { "label", "label_description", gap = 1 },
                            { "kind" },
                        },
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    return " " .. require("lspkind").symbolic(ctx.kind, { mode = "symbol" }) .. " "
                                end,
                                highlight = function(ctx)
                                    return ctx.kind_hl
                                end,
                            },
                            kind = {
                                text = function(ctx)
                                    return "[" .. ctx.kind .. "]"
                                end,
                                highlight = function(ctx)
                                    return ctx.kind_hl
                                end,
                            },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    window = {
                        border = "rounded",
                    },
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
        })
    end,
}
