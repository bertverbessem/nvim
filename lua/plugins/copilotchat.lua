return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = { "CopilotChat" },
    lazy = false,
    opts = {
        auto_insert_mode = true,
        agent = "copilot",
        debug = false,
        model = "claude-sonnet-4.5",
        show_help = false,
        window = {
            layout = "vertical",
            width = 0.3, -- fractional width of parent, or absolute width in columns when > 1
        },
        headers = {
            user = "👤 Bert",
            assistant = "🤖 Copilot",
            tool = "🔧 Tool",
        },
        sticky = {
            "#buffer:visible",
        },
    },
    keys = {
        { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Open Copilot Chat" },
        { "<leader>ap", "<cmd>CopilotChatPrompts<cr>", desc = "Copilot Prompts" },
        {
            "<leader>aq",
            function()
                local input = vim.fn.input("Quick Chat: ")
                if input ~= "" then
                    require("CopilotChat").ask(input)
                end
            end,
            desc = "Quick chat",
        },
        -- Visual mode mappings
        { "<leader>aa", "<cmd>CopilotChat<cr>", mode = "v", desc = "Open Copilot Chat with selection" },
        { "<leader>ap", ":lua require(CopilotChat).prompts<cr>", mode = "v", desc = "Copilot Prompts with selection" },
        {
            "<leader>aq",
            function()
                local input = vim.fn.input("Quick Chat: ")
                if input ~= "" then
                    require("CopilotChat").ask(input)
                end
            end,
            mode = "v",
            desc = "Quick chat with selection",
        },
    },
}
