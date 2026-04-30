-- ================================================================================================
-- TITLE : lazy.nvim Bootstrap & Plugin Setup
-- ABOUT :
--   bootstraps the 'lazy.nvim' plugin manager by cloning it if not present, prepends it to the
--   runtime path, and then loads core configuration files (globals, options, keymaps, autocmds).
--   Last, initialises 'lazy.nvim' with plugins.
-- LINKS :
--   > lazy.nvim github  : https://github.com/folke/lazy.nvim
--   > lazy.nvim website : https://lazy.folke.io/installation
-- ================================================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("config.globals")
require("config.options")
require("config.filetypes")
require("config.keymaps")
require("config.autocmds")
require("config.spell")

local plugins_dir = "plugins"
vim.diagnostic.config({
    virtual_text = { current_line = true },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
})
-- vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })

require("lazy").setup({
    ui = {
        border = "rounded",
    },
    spec = {
        { import = plugins_dir },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
                "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
                "getscript", "getscriptPlugin", "vimball", "vimballPlugin",
                "2html_plugin", "tohtml", "logipat", "rrhelper",
                "tutor", "rplugin",
            },
        },
    },
    install = { colorscheme = { "vague" } },
    checker = { enabled = false },
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    once = true,
    callback = function()
        require("config.lsp")
    end,
})
