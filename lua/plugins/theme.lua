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
            bold = true,
            italic = true,
            -- Override highlights or add new highlights
            on_highlights = function(hl, _)
                -- For available options see `:h nvim_set_hl()`
                -- hl.NewHighlight = { fg = colors.fg, bg = colors.bg, bold = true }
                -- hl.ExistingHighlight.fg = colors.delta -- only overwrite fg
                -- Markdown headings with vague-style colors
                hl.RenderMarkdownH1 = { fg = "#d4be98", bold = true } -- warm yellow
                hl.RenderMarkdownH2 = { fg = "#7daea3", bold = true } -- teal
                hl.RenderMarkdownH3 = { fg = "#d3869b", bold = true } -- pink
                hl.RenderMarkdownH4 = { fg = "#a9b665", bold = true } -- green
                hl.RenderMarkdownH5 = { fg = "#89b4f5", bold = true } -- blue
                hl.RenderMarkdownH6 = { fg = "#e78a4e", bold = true } -- orange

                -- Background highlights (subtle)
                hl.RenderMarkdownH1Bg = { bg = "#3c3836", fg = "#d4be98" }
                hl.RenderMarkdownH2Bg = { bg = "#3c3836", fg = "#7daea3" }
                hl.RenderMarkdownH3Bg = { bg = "#3c3836", fg = "#d3869b" }
                hl.RenderMarkdownH4Bg = { bg = "#3c3836", fg = "#a9b665" }
                hl.RenderMarkdownH5Bg = { bg = "#3c3836", fg = "#89b4f5" }
                hl.RenderMarkdownH6Bg = { bg = "#3c3836", fg = "#e78a4e" }
            end,

            colors = {
                -- You can override specific colors here if needed
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
