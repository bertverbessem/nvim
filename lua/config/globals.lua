-- ================================================================================================
-- TITLE : globals
-- ABOUT : you may have different global & local leaders
-- ================================================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- pyenv shims (zshrc lazy-loads pyenv, so shims aren't in PATH at nvim launch)
local pyenv_root = vim.env.PYENV_ROOT or (vim.env.HOME .. "/.pyenv")
local pyenv_shims = pyenv_root .. "/shims"
if vim.uv.fs_stat(pyenv_shims) and not vim.env.PATH:find(pyenv_shims, 1, true) then
    vim.env.PATH = pyenv_shims .. ":" .. vim.env.PATH
end
