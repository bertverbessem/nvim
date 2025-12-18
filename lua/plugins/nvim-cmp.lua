-- ================================================================================================
-- TITLE : nvim-cmp
-- ABOUT : A completion plugin written in lua.
-- LINKS :
--   > github                             : https://github.com/hrsh7th/nvim-cmp
--   > lspkind (dep)                      : https://github.com/onsails/lspkind.nvim
--   > cmp_luasnip (dep)                  : https://github.com/saadparwaiz1/cmp_luasnip
--   > luasnip (dep)                      : https://github.com/L3MON4D3/LuaSnip
--   > friendly-snippets (dep)            : https://github.com/rafamadriz/friendly-snippets
--   > cmp-nvim-lsp (dep)                 : https://github.com/hrsh7th/cmp-nvim-lsp
--   > cmp-buffer (dep)                   : https://github.com/hrsh7th/cmp-buffer
--   > cmp-path (dep)                     : https://github.com/hrsh7th/cmp-path
--   > cmp-nvim-lsp-signature-help (dep)  : https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
-- ================================================================================================

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "onsails/lspkind.nvim", -- Adds VS Code-like pictograms/icons to the completion menu
        "saadparwaiz1/cmp_luasnip", -- Enables LuaSnip as a source for nvim-cmp autocompletion
        "L3MON4D3/LuaSnip", -- Snippet engine for Neovim (write and expand code snippets)
        "rafamadriz/friendly-snippets", -- Large collection of pre-made snippets for various languages
        "hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for LSP-based autocompletion
        "hrsh7th/cmp-buffer", -- nvim-cmp source for words from the current buffer
        "hrsh7th/cmp-path", -- nvim-cmp source for filesystem paths
        "hrsh7th/cmp-nvim-lsp-signature-help", -- function signatures
        "lukas-reineke/cmp-under-comparator",
    },
    config = function()
        local lspkind = require("lspkind")
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_lua").lazy_load({
            paths = {
                vim.fn.stdpath("config") .. "/lua/snippets",
            },
        })

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            formatting = {
                format = lspkind.cmp_format({
                    -- before = require("tailwind-tools.cmp").lspkind_format,
                    mode = "symbol_text",
                    menu = {
                        -- codeium = "",
                        luasnip = "",
                        buffer = "",
                        path = "",
                        nvim_lsp = "🅻",
                    },
                }),
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-y>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),

            sources = {
                -- { name = "codeium" },
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
                { name = "nvim_lsp_signature_help" },
            },
            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    require("cmp-under-comparator").under,
                    cmp.config.compare.kind,
                },
            },
            matching = {
                disallow_fuzzy_matching = true,
                disallow_fullfuzzy_matching = true,
                disallow_partial_fuzzy_matching = true,
                disallow_partial_matching = false,
                disallow_prefix_unmatching = true,
            },
        })
    end,
}
