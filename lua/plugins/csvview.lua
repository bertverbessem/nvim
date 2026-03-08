-- ================================================================================================
-- TITLE : csvview.nvim
-- ABOUT : CSV/TSV table viewer with column alignment in Neovim.
-- LINKS :
--   > github: https://github.com/hat0uma/csvview.nvim
-- ================================================================================================

return {
    "hat0uma/csvview.nvim",
    ft = { "csv", "tsv" },
    opts = {
        parser = { async = true },
        view = {
            display_mode = "highlight",
        },
    },
    keys = {
        { "<leader>cv", "<cmd>CsvViewToggle<cr>", ft = { "csv", "tsv" }, desc = "Toggle CSV view" },
    },
}
