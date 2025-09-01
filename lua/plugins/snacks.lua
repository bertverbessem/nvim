return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        dashboard = {
            enabled = true,
            wo = {
                listchars = "",
            },
        },
        explorer = { enabled = false },
        picker = { enabled = true },
        notifier = { enabled = false },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        terminal = {
            enabled = true,
            win = {
                position = "float",
                blend = 0,
                winblend = 0,
                transparency = 0,
                background = "NormalFloat",
                border = "rounded",
                height = 0.7,
                width = 0.8,
            },
            o = {
                filetype = "snacks_terminal",
            },
            wo = {},
            keys = {
                q = "hide",
                gf = function(self)
                    local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
                    if f == "" then
                        require("snacks").notify.warn("No file under cursor")
                    else
                        self:hide()
                        vim.schedule(function()
                            vim.cmd("e " .. f)
                        end)
                    end
                end,
                term_normal = {
                    "<esc>",
                    function(self)
                        self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
                        if self.esc_timer:is_active() then
                            self.esc_timer:stop()
                            vim.cmd("stopinsert")
                        else
                            self.esc_timer:start(200, 0, function() end)
                            return "<esc>"
                        end
                    end,
                    mode = "t",
                    expr = true,
                    desc = "Double escape to normal mode",
                },
            },
        },
    },
    keys = {
        -- Top Pickers
        {
            "<leader><space>",
            function()
                require("snacks").picker.smart()
            end,
            desc = "Smart Find Files",
        },
        {
            "<leader>,",
            function()
                require("snacks").picker.buffers()
            end,
            desc = "Buffers",
        },
        {
            "<leader>/",
            function()
                require("snacks").picker.grep()
            end,
            desc = "Grep",
        },
        {
            "<leader>:",
            function()
                require("snacks").picker.command_history()
            end,
            desc = "Command History",
        },
        {
            "<leader>n",
            function()
                require("snacks").picker.notifications()
            end,
            desc = "Notification History",
        },
        -- find
        {
            "<leader>fb",
            function()
                require("snacks").picker.buffers()
            end,
            desc = "Buffers",
        },
        {
            "<leader>fc",
            function()
                require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Find Config File",
        },
        {
            "<leader>ff",
            function()
                require("snacks").picker.files()
            end,
            desc = "Find Files",
        },
        {
            "<leader>fg",
            function()
                require("snacks").picker.git_files()
            end,
            desc = "Find Git Files",
        },
        {
            "<leader>fp",
            function()
                require("snacks").picker.projects()
            end,
            desc = "Projects",
        },
        {
            "<leader>fr",
            function()
                require("snacks").picker.recent()
            end,
            desc = "Recent",
        },
        -- git
        {
            "<leader>gb",
            function()
                require("snacks").picker.git_branches()
            end,
            desc = "Git Branches",
        },
        {
            "<leader>gl",
            function()
                require("snacks").picker.git_log()
            end,
            desc = "Git Log",
        },
        {
            "<leader>gL",
            function()
                require("snacks").picker.git_log_line()
            end,
            desc = "Git Log Line",
        },
        {
            "<leader>gs",
            function()
                require("snacks").picker.git_status()
            end,
            desc = "Git Status",
        },
        {
            "<leader>gS",
            function()
                require("snacks").picker.git_stash()
            end,
            desc = "Git Stash",
        },
        {
            "<leader>gd",
            function()
                require("snacks").picker.git_diff()
            end,
            desc = "Git Diff (Hunks)",
        },
        {
            "<leader>gf",
            function()
                require("snacks").picker.git_log_file()
            end,
            desc = "Git Log File",
        },
        -- Grep
        {
            "<leader>sb",
            function()
                require("snacks").picker.lines()
            end,
            desc = "Buffer Lines",
        },
        {
            "<leader>sB",
            function()
                require("snacks").picker.grep_buffers()
            end,
            desc = "Grep Open Buffers",
        },
        {
            "<leader>sg",
            function()
                require("snacks").picker.grep()
            end,
            desc = "Grep",
        },
        {
            "<leader>sw",
            function()
                require("snacks").picker.grep_word()
            end,
            desc = "Visual selection or word",
            mode = { "n", "x" },
        },
        -- search
        {
            '<leader>s"',
            function()
                require("snacks").picker.registers()
            end,
            desc = "Registers",
        },
        {
            "<leader>s/",
            function()
                require("snacks").picker.search_history()
            end,
            desc = "Search History",
        },
        {
            "<leader>sa",
            function()
                require("snacks").picker.autocmds()
            end,
            desc = "Autocmds",
        },
        {
            "<leader>sc",
            function()
                require("snacks").picker.command_history()
            end,
            desc = "Command History",
        },
        {
            "<leader>sC",
            function()
                require("snacks").picker.commands()
            end,
            desc = "Commands",
        },
        {
            "<leader>sd",
            function()
                require("snacks").picker.diagnostics()
            end,
            desc = "Diagnostics",
        },
        {
            "<leader>sD",
            function()
                require("snacks").picker.diagnostics_buffer()
            end,
            desc = "Buffer Diagnostics",
        },
        {
            "<leader>sh",
            function()
                require("snacks").picker.help()
            end,
            desc = "Help Pages",
        },
        {
            "<leader>sH",
            function()
                require("snacks").picker.highlights()
            end,
            desc = "Highlights",
        },
        {
            "<leader>si",
            function()
                require("snacks").picker.icons()
            end,
            desc = "Icons",
        },
        {
            "<leader>sj",
            function()
                require("snacks").picker.jumps()
            end,
            desc = "Jumps",
        },
        {
            "<leader>sk",
            function()
                require("snacks").picker.keymaps()
            end,
            desc = "Keymaps",
        },
        {
            "<leader>sl",
            function()
                require("snacks").picker.loclist()
            end,
            desc = "Location List",
        },
        {
            "<leader>sm",
            function()
                require("snacks").picker.marks()
            end,
            desc = "Marks",
        },
        {
            "<leader>sM",
            function()
                require("snacks").picker.man()
            end,
            desc = "Man Pages",
        },
        {
            "<leader>sp",
            function()
                require("snacks").picker.lazy()
            end,
            desc = "Search for Plugin Spec",
        },
        {
            "<leader>sq",
            function()
                require("snacks").picker.qflist()
            end,
            desc = "Quickfix List",
        },
        {
            "<leader>sR",
            function()
                require("snacks").picker.resume()
            end,
            desc = "Resume",
        },
        {
            "<leader>su",
            function()
                require("snacks").picker.undo()
            end,
            desc = "Undo History",
        },
        {
            "<leader>uC",
            function()
                require("snacks").picker.colorschemes()
            end,
            desc = "Colorschemes",
        },
        -- LSP
        {
            "gd",
            function()
                require("snacks").picker.lsp_definitions()
            end,
            desc = "Goto Definition",
        },
        {
            "gD",
            function()
                require("snacks").picker.lsp_declarations()
            end,
            desc = "Goto Declaration",
        },
        {
            "gr",
            function()
                require("snacks").picker.lsp_references()
            end,
            nowait = true,
            desc = "References",
        },
        {
            "gI",
            function()
                require("snacks").picker.lsp_implementations()
            end,
            desc = "Goto Implementation",
        },
        {
            "gy",
            function()
                require("snacks").picker.lsp_type_definitions()
            end,
            desc = "Goto T[y]pe Definition",
        },
        {
            "<leader>ss",
            function()
                require("snacks").picker.lsp_symbols()
            end,
            desc = "LSP Symbols",
        },
        {
            "<leader>sS",
            function()
                require("snacks").picker.lsp_workspace_symbols()
            end,
            desc = "LSP Workspace Symbols",
        },
    },
}
