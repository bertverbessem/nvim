-- ================================================================================================
-- TITLE : nvim-treesitter
-- ABOUT : Treesitter configurations and abstraction layer for Neovim.
-- LINKS :
--   > github : https://github.com/nvim-treesitter/nvim-treesitter
-- ================================================================================================

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        vim.treesitter.language.register("yaml", "yaml.ansible")
        vim.treesitter.language.register("terraform", "terraform-vars")

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(ev)
                local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
                if pcall(vim.treesitter.language.inspect, lang) then
                    vim.treesitter.start(ev.buf)
                    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
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
            "groovy",
            "nginx",
            "php",
            "twig",
        })
    end,
}
