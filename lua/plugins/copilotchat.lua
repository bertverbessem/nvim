return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = function()
        -- local user = vim.env.USER or "User"
        -- user = user:sub(1, 1):upper() .. user:sub(2)
        return {
            auto_insert_mode = true,
            agent = "copilot",
            debug = false,
            model = "claude-sonnet-4",
            show_help = false,
            question_header = "  " .. "Bert" .. " ",
            answer_header = "  Copilot ",
            window = {
                layout = "vertical",
                width = 0.3, -- fractional width of parent, or absolute width in columns when > 1
            },
            sticky = {
                "#buffers:visible",
            },
        }
    end,
    keys = {
        { "<leader>aa", "<cmd>CopilotChat<cr>", desc = "Open Copilot Chat" },
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
        { "<leader>ap", "<cmd>CopilotChatPrompts<cr>", mode = "v", desc = "Copilot Prompts with selection" },
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
