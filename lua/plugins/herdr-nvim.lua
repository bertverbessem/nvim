return {
  "ChmaraX/herdr-nvim",
  config = function()
    local herdr = require("herdr-nvim")
    herdr.setup({ prefix = "<leader>a", keymaps = true, clear_after_send = true })
    herdr.setup = function() end
  end,
}
