-- ================================================================================================
-- TITLE : nvim-tree.lua
-- ABOUT : A file explorer tree for Neovim, written in Lua.
-- LINKS :
--   > github : https://github.com/nvim-tree/nvim-tree.lua
-- ================================================================================================

return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
        -- Remove background color from the NvimTree window (ui fix)
        vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])

        require("nvim-tree").setup({
            filters = {
                dotfiles = false, -- Show hidden files (dotfiles)
                git_ignored = false,
            },
            view = {
                adaptive_size = true,
            },
            update_cwd = true,
            update_focused_file = {
                enable = true,
                update_cwd = true,
            },
        })
    end,
}
