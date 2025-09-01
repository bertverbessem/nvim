-- Auto-download missing spell files
local function ensure_spell(lang)
    local spell_dir = vim.fn.stdpath("config") .. "/spell"
    local utf_file = spell_dir .. "/" .. lang .. ".utf-8.spl"

    if vim.fn.filereadable(utf_file) == 0 then
        vim.fn.mkdir(spell_dir, "p")
        local url = "https://ftp.nluug.nl/pub/vim/runtime/spell/" .. lang .. ".utf-8.spl"
        local ok = os.execute(string.format("curl -fLo %s --create-dirs %s", utf_file, url))
        if ok == 0 then
            vim.notify("Downloaded spell file for " .. lang)
        else
            vim.notify("Failed to download spell file for " .. lang, vim.log.levels.ERROR)
        end
    end
end

-- Hook into :set spelllang dynamically
vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "spelllang",
    callback = function()
        for _, lang in ipairs(vim.opt.spelllang:get()) do
            ensure_spell(lang)
        end
    end,
})
