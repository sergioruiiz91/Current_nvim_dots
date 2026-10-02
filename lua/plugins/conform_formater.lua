return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Nota: Cambiado a <leader>cf ([C]ode [F]ormat o mantén <leader>ff si prefieres)
      "<leader>ff",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Activa el autoformato al guardar para tus lenguajes principales si lo deseas
      local enabled_filetypes = {
        lua = true,
        python = true,
        rust = true,
        sh = true,
        bash = true,
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      end
      return nil
    end,
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
