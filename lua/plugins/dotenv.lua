-- ================================================================================================
-- TITLE : cloak.nvim
-- ABOUT : Masks sensitive values in .env files (replaces with *** in display only, file unchanged).
-- LINKS :
--   > github: https://github.com/laytan/cloak.nvim
-- ================================================================================================

return {
    "laytan/cloak.nvim",
    ft = { "sh", "dotenv" },
    opts = {
        enabled = true,
        cloak_character = "*",
        highlight_group = "Comment",
        cloak_telescope = true,
        patterns = {
            {
                file_pattern = { ".env", ".env.*", "*.env" },
                cloak_pattern = "=.+",
                replace = nil,
            },
        },
    },
    keys = {
        { "<leader>ct", "<cmd>CloakToggle<cr>", desc = "Toggle cloak (.env masking)" },
    },
}
