-- ================================================================================================
-- TITLE : melange-nvim
-- ABOUT : A subtle, warm colorscheme for Neovim inspired by Sublime Text's Melange theme.
-- LINKS :
--   > github : https://github.com/savq/melange-nvim
-- ================================================================================================
return {
    "vague2k/vague.nvim",
    priority = 1000,
    config = function()
        require("vague").setup({
            transparent = true,
            style = {
                boolean = "none",
                number = "none",
                float = "none",
                error = "none",
                comments = "italic",
                conditionals = "none",
                functions = "none",
                headings = "bold",
                operators = "none",
                strings = "none",
                variables = "none",
                keywords = "italic",
                keyword_return = "none",
                keywords_loop = "none",
                keywords_label = "none",
                keywords_exception = "none",
                builtin_constants = "none",
                builtin_functions = "none",
                builtin_types = "none",
                builtin_variables = "none",
            },
            colors = {
                -- You can override specific colors here if needed
            },
            -- Custom highlight groups for markdown
            highlights = {
                -- Markdown headings with vague-style colors
                RenderMarkdownH1 = { fg = "#d4be98", bold = true }, -- warm yellow
                RenderMarkdownH2 = { fg = "#7daea3", bold = true }, -- teal
                RenderMarkdownH3 = { fg = "#d3869b", bold = true }, -- pink
                RenderMarkdownH4 = { fg = "#a9b665", bold = true }, -- green
                RenderMarkdownH5 = { fg = "#89b4f5", bold = true }, -- blue
                RenderMarkdownH6 = { fg = "#e78a4e", bold = true }, -- orange

                -- Background highlights (subtle)
                RenderMarkdownH1Bg = { bg = "#3c3836", fg = "#d4be98" },
                RenderMarkdownH2Bg = { bg = "#3c3836", fg = "#7daea3" },
                RenderMarkdownH3Bg = { bg = "#3c3836", fg = "#d3869b" },
                RenderMarkdownH4Bg = { bg = "#3c3836", fg = "#a9b665" },
                RenderMarkdownH5Bg = { bg = "#3c3836", fg = "#89b4f5" },
                RenderMarkdownH6Bg = { bg = "#3c3836", fg = "#e78a4e" },
            },
        })
        vim.cmd("colorscheme vague")
        vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
            callback = function()
                vim.api.nvim_set_hl(0, "Visual", { bg = "#d3869b", fg = "black" })
            end,
        })
    end,
}
