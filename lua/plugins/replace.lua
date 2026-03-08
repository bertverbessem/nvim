return {
    "MagicDuck/grug-far.nvim",
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
        -- optional setup call to override plugin options
        -- alternatively you can set options with vim.g.grug_far = { ... }
        require("grug-far").setup({})
    end,
    keys = {
        {
            "<leader>rl",
            function()
                local search = vim.fn.getreg("/")
                if search and vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
                    search = "\\b" .. search:sub(3, -3) .. "\\b"
                end
                require("grug-far").open({
                    prefills = {
                        search = search,
                        path = vim.fn.expand("%:p:h"),
                    },
                })
            end,
            mode = { "n", "x" },
            desc = "grug-far: Search using @/ register value or visual selection",
        },
        {
            "<leader>ri",
            function()
                require("grug-far").open(
                    { visualSelectionUsage = "operate-within-range" },
                    { prefills = { paths = vim.fn.expand("%:p:h") } }
                )
            end,
            mode = { "n", "x" },
            desc = "grug-far: Search within range",
        },
        {
            "<leader>rw",
            function()
                require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>"), paths = vim.fn.expand("%:p:h") } })
            end,
            mode = { "n", "x", "v" },
            desc = "grug-far: current word",
        },
        {
            "<leader>ro",
            function()
                require("grug-far").open({ prefills = { paths = vim.fn.expand("%:p:h") } })
            end,
            desc = "grug-far: open",
        },
    },
}

