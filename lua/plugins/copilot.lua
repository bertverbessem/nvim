return {
    "zbirenbaum/copilot.lua",
    opts = {
        panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
                jump_prev = "k",
                jump_next = "j",
                accept = "<C-y>",
                refresh = "gr",
                open = "<C-j>",
            },
            layout = {
                position = "bottom",
                ratio = 0.4,
            },
        },
        suggestion = {
            enabled = false,
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
