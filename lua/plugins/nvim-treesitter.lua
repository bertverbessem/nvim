-- ================================================================================================
-- TITLE : nvim-treesitter
-- ABOUT : Treesitter configurations and abstraction layer for Neovim.
-- LINKS :
--   > github : https://github.com/nvim-treesitter/nvim-treesitter
-- ================================================================================================

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    lazy = false,
    config = function()
        vim.treesitter.language.register("yaml", "yaml.ansible")
        vim.treesitter.language.register("terraform", "terraform-vars")

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "yaml.ansible", "terraform-vars" },
            callback = function()
                vim.treesitter.start()
            end,
        })

        require("nvim-treesitter").setup({
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    scope_incremental = "<TAB>",
                    node_decremental = "<S-TAB>",
                },
            },
        })

        require("nvim-treesitter").install({
            "bash",
            "c",
            "cpp",
            "css",
            "dockerfile",
            "go",
            "html",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "rust",
            "svelte",
            "typescript",
            "vue",
            "yaml",
        })
    end,
}
