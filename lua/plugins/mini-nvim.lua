-- ================================================================================================
-- TITLE : mini.nvim
-- LINKS :
--   > github : https://github.com/nvim-mini/mini.nvim
-- ABOUT : Library of 40+ independent Lua modules.
-- ================================================================================================

return {
    { "nvim-mini/mini.ai", version = "*", opts = {} },
    -- { "nvim-mini/mini.comment", version = "*", opts = {} },
{
        "nvim-mini/mini.pairs",
        version = "*",
        opts = {
            modes = { insert = true, command = false, terminal = false },
        },
        config = function(_, opts)
            local mini_pairs = require("mini.pairs")
            mini_pairs.setup(opts)

            -- Custom function to check for whitespace around cursor
            local function has_whitespace_around()
                local line = vim.api.nvim_get_current_line()
                local col = vim.api.nvim_win_get_cursor(0)[2]

                -- Check character before cursor (or beginning of line)
                local char_before = col == 0 and " " or line:sub(col, col)
                -- Check character after cursor (or end of line)
                local char_after = col >= #line and " " or line:sub(col + 1, col + 1)

                -- Return true if both sides are whitespace or we're at line boundaries
                return char_before:match("%s") and char_after:match("%s")
            end

            -- Custom mapping function
            local function smart_pair(open_char, close_char)
                return function()
                        if has_whitespace_around() then
                        return open_char .. close_char .. "<Left>"
                        else
                        return open_char
                            end
                end
            end

            -- Create custom keymaps for autopairs
            local pairs_map = {
                ["("] = ")",
                ["["] = "]",
                ["{"] = "}",
                ['"'] = '"',
                ["'"] = "'",
                ["`"] = "`",
            }

            for open_char, close_char in pairs(pairs_map) do
                vim.keymap.set("i", open_char, smart_pair(open_char, close_char), {
                    expr = true,
                    noremap = true,
                    silent = true
                })
            end
        end,
    },
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
