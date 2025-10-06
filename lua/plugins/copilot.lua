return {
    "zbirenbaum/copilot.lua",
    opts = {
        panel = {
            enabled = false,
            auto_refresh = true,
            -- keymap = {
            --     jump_prev = "<C-k>",
            --     jump_next = "<C-j>",
            --     accept = "<Tab>",
            --     refresh = "gr",
            --     open = "<M-CR>",
            -- },
            layout = {
                position = "bottom", -- | top | left | right
                ratio = 0.4,
            },
        },
        suggestion = {
            enabled = false,
            auto_trigger = false,
            hide_during_completion = true,
            debounce = 75,
            keymap = {
                accept = "<Tab>",
                accept_word = false,
                accept_line = false,
                prev = "<C-k>",
                next = "<C-j>",
                dismiss = "<C-e>",
            },
        },
        filetypes = {
            ["yaml.ansible"] = true,
            groovy = true,
            Jenkinsfile = true,
            dockerfile = true,
            terraform = true,
            hcl = true,
            lua = true,
            python = true,
            bash = true,
            sh = true,
            go = true,
            php = true,
            ["yaml.docker-compose"] = true,
            ["."] = false,
            ["*"] = false,
            markdown = false,
        },
    },
}
