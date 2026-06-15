return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-neotest/neotest-go",
    },
    keys = {
        { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
        { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
        { "<leader>tS", function() require("neotest").run.run({ suite = true }) end, desc = "Run test suite" },
        { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
        { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
        { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-go"),
            },
        })
    end,
}
