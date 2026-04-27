return {
    "dlyongemallo/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
        { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
        { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
        { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File History (all)" },
        {
            "<leader>gm",
            function()
                local branch = vim.fn.input("Compare with branch: ")
                if branch ~= "" then
                    vim.cmd("DiffviewOpen " .. branch)
                end
            end,
            desc = "Compare with Branch",
        },
    },
    opts = {
        enhanced_diff_hl = true,
        view = {
            default = { layout = "diff2_horizontal" },
            merge_tool = { layout = "diff3_horizontal" },
        },
        file_panel = {
            listing_style = "tree",
            tree_options = { flatten_dirs = true, folder_statuses = "only_folded" },
            win_config = { position = "left", width = 35 },
        },
        default_args = {
            DiffviewOpen = { "--imply-local" },
        },
    },
}
