-- automatically set colors
return {
  "f-person/auto-dark-mode.nvim",
  opts = {
    set_dark_mode = function()
      vim.api.nvim_set_option_value("background", "dark", {})
      vim.cmd("colorscheme vague")
      vim.cmd(":hi statusline guibg=NONE")
    end,
    set_light_mode = function()
      vim.api.nvim_set_option_value("background", "light", {})
      vim.cmd("colorscheme rose-pine")
    end,
    update_interval = 3000,
    fallback = "dark",
  },
}

