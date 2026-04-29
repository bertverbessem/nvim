return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                local groups = { "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer", "NeoTreeWinSeparator" }
                for _, group in ipairs(groups) do
                    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
                end
                vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { link = "CursorLine" })
            end,
        })
        vim.cmd("doautocmd ColorScheme")

        local function get_dir_under_cursor(state)
            local node = state.tree:get_node()
            if node.type == "directory" then
                return node:get_id()
            end
            return node:get_parent_id()
        end

        local picker_exclude = { ".venv", ".git", "node_modules", "__pycache__", ".cache" }

        require("neo-tree").setup({
            close_if_last_window = true,
            use_popups_for_input = false,
            window = {
                mappings = {
                    ["s"] = "noop",
                    ["S"] = "noop",
                    ["t"] = "noop",
                    ["<C-v>"] = "open_vsplit",
                    ["<C-x>"] = "open_split",
                    ["<C-t>"] = "open_tabnew",
                    ["W"] = "close_all_nodes",
                    ["y"] = function(state)
                        local node = state.tree:get_node()
                        local name = node.name
                        vim.fn.setreg("+", name)
                        vim.notify("Copied: " .. name)
                    end,
                    ["Y"] = function(state)
                        local node = state.tree:get_node()
                        local path = vim.fn.fnamemodify(node:get_id(), ":~:.")
                        vim.fn.setreg("+", path)
                        vim.notify("Copied: " .. path)
                    end,
                    ["gy"] = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path)
                        vim.notify("Copied: " .. path)
                    end,
                },
            },
            filesystem = {
                bind_to_cwd = true,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                group_empty_dirs = true,
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_by_name = { ".git" },
                },
                window = {
                    mappings = {
                        ["<leader>ff"] = function(state)
                            local dir = get_dir_under_cursor(state)
                            require("snacks").picker.files({
                                cwd = dir,
                                hidden = true,
                                ignored = true,
                                exclude = picker_exclude,
                            })
                        end,
                        ["<leader>fg"] = function(state)
                            local dir = get_dir_under_cursor(state)
                            require("snacks").picker.grep({
                                cwd = dir,
                                hidden = true,
                                ignored = true,
                                exclude = picker_exclude,
                            })
                        end,
                    },
                },
            },
        })
    end,
}
