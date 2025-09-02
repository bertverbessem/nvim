-- ================================================================================================
-- TITLE : mini.nvim
-- LINKS :
--   > github : https://github.com/nvim-mini/mini.nvim
-- ABOUT : Library of 40+ independent Lua modules.
-- ================================================================================================

return {
    { "nvim-mini/mini.ai", version = "*", opts = {} },
    -- { "nvim-mini/mini.comment", version = "*", opts = {} },
    { "nvim-mini/mini.move", version = "*", opts = {} },
    {
        "nvim-mini/mini.surround",
        version = "*",
        opts = {
            mappings = {
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                replace = "gsr", -- Replace surrounding
                update_n_lines = "gsn", -- Update `n_lines`

                suffix_last = "l", -- Suffix to search with "prev" method
                suffix_next = "n", -- Suffix to search with "next" method
            },
        },
    },
    { "nvim-mini/mini.cursorword", version = "*", opts = {} },
    { "nvim-mini/mini.indentscope", version = "*", opts = {} },
    { "nvim-mini/mini.pairs", version = "*", opts = {} },
    {
        "nvim-mini/mini.trailspace",
        event = "VeryLazy",
        version = "*",
        opts = {},
    },
    { "nvim-mini/mini.bufremove", version = "*", opts = {} },
    -- { "nvim-mini/mini.notify", version = "*", opts = {} },
    -- { "nvim-mini/mini.pick", version = "*", opts = {} },
}
