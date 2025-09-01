return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "lua_ls",
        "bashls",
        "ansiblels",
        "basedpyright",
        "gopls",
        "jsonls",
        "dockerls",
        "terraformls",
        "efm",
      },
    },
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "stylua",     -- Lua formatter
        "shfmt",      -- Shell formatter
        "shellcheck", -- Shell linter
        "black",      -- Python formatter
        "flake8",     -- Python linter
        "prettier",   -- JS/TS/JSON formatter
        "eslint_d",   -- JS/TS linter
      },
      automatic_installation = true,
    },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim", -- null-ls fork
    },
  },
}

