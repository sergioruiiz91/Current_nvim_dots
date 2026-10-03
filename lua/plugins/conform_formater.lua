return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = false,
    format_after_save = false,
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      -- Ruff combinado: primero corrige imports/lints rápidos y luego aplica el formato oficial de ruff
      python = { "ruff_fix", "ruff_format" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      sql = { "sqlfluff" },
      rust = { "rustfmt" },
    },
    -- Opciones específicas para formateadores concretos si es necesario
    formatters = {
      sqlfluff = {
        args = { "format", "--dialect=ansi", "-" }, -- Cambia ansi por tu dialecto si usas postgres, mysql, etc.
      },
    },
  },
}
