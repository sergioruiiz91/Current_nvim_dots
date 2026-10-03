-- ~/.config/nvim/lua/plugins/nvjup.lua
-- Config de nvjup: todos los comandos de abajo existen (verificados con :command NvJup)

-- { modo, lhs, comando, descripción }
local maps = {
  -- ── Celdas (<leader>c) ──────────────────────────────────────────
  { "n", "<leader>ck", "NvJupCellInsertAbove", "Insertar celda arriba" },
  { "n", "<leader>cj", "NvJupCellInsertBelow", "Insertar celda abajo" },
  { "n", "<leader>cd", "NvJupCellDelete", "Eliminar celda" },
  { "n", "<leader>cy", "NvJupCellDuplicate", "Duplicar celda" },
  { "n", "<leader>cs", "NvJupCellSplit", "Dividir celda en el cursor" },
  { "n", "<leader>cK", "NvJupCellMoveUp", "Mover celda arriba" },
  { "n", "<leader>cJ", "NvJupCellMoveDown", "Mover celda abajo" },
  { "n", "<leader>cH", "NvJupCellMergeBelow", "Unir con la celda de abajo" },
  { "n", "<leader>ct", "NvJupCellType", "Alternar tipo (código/md/raw)" },
  { "n", "<leader>cr", "NvJupCellToggleSource", "Alternar render Markdown / fuente" },
  { "n", "<leader>cf", "NvJupFormat", "Formatear celda" },
  { "n", "<leader>cF", "NvJupFormatAll", "Formatear todo el notebook" },
  { "n", "<leader>co", "NvJupOutline", "Índice del notebook" },
  -- Outputs
  { "n", "<leader>cx", "NvJupCellClearOutput", "Limpiar output de la celda" },
  { "n", "<leader>cX", "NvJupClearAllOutputs", "Limpiar todos los outputs" },
  { "n", "<leader>cv", "NvJupCellToggleOutput", "Mostrar/ocultar output de la celda" },
  { "n", "<leader>cp", "NvJupOutputOpen", "Abrir output completo" },
  -- Navegación (desactivada en el plugin, la hago yo)
  { "n", "]c", "NvJupCellNext", "Celda siguiente" },
  { "n", "[c", "NvJupCellPrevious", "Celda anterior" },

  -- ── Ejecución (<leader>r / <leader>R) ───────────────────────────
  { "n", "<leader>rc", "NvJupRunCurrent", "Ejecutar celda actual" },
  { "n", "<leader>rd", "NvJupRunAndAdvance", "Ejecutar celda y bajar" },
  { "n", "<leader>ru", "NvJupRunAbove", "Ejecutar celdas anteriores" },
  { "n", "<leader>rD", "NvJupRunBelow", "Ejecutar celdas posteriores" },
  { "n", "<leader>R", "NvJupRunAll", "Ejecutar todas las celdas" },
  { { "n", "i" }, "<C-CR>", "NvJupRunCurrent", "Ejecutar celda actual" },
  { { "n", "i" }, "<S-CR>", "NvJupRunAndAdvance", "Ejecutar celda y avanzar" },

  -- ── Kernel y remoto (<leader>k) ─────────────────────────────────
  -- No existe comando "start": el kernel arranca al ejecutar una celda.
  -- NvJupRemoteConnect es el selector de entorno (.venv / system / Jupyter Lab / Colab).
  { "n", "<leader>ks", "NvJupRemoteConnect", "Seleccionar entorno / conectar kernel" },
  { "n", "<leader>ki", "NvJupKernelStatus", "Estado del kernel" },
  { "n", "<leader>kr", "NvJupKernelRestart", "Reiniciar kernel" },
  { "n", "<leader>kR", "NvJupKernelRestartRunAll", "Reiniciar kernel y ejecutar todo" },
  { "n", "<leader>kq", "NvJupKernelInterrupt", "Interrumpir kernel" },
  { "n", "<leader>kQ", "NvJupKernelShutdown", "Detener kernel" },
  { "n", "<leader>kv", "NvJupVariables", "Inspector de variables" },
  { "n", "<leader>ke", "NvJupRemoteFiles", "Gestor de archivos remoto" },
  { "n", "<leader>kI", "NvJupRemoteStatus", "Estado de conexión remota" },
  { "n", "<leader>kd", "NvJupRemoteDisconnect", "Desconectar remoto" },
}

local function attach(buf)
  if vim.b[buf].nvjup_user_maps then
    return
  end
  vim.b[buf].nvjup_user_maps = true

  for _, m in ipairs(maps) do
    vim.keymap.set(m[1], m[2], "<cmd>" .. m[3] .. "<CR>", {
      buffer = buf,
      silent = true,
      desc = m[4],
    })
  end

  -- Nombres de grupo en which-key (solo en este buffer)
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add({
      { "<leader>c", group = "Celdas", buffer = buf },
      { "<leader>r", group = "Ejecutar", buffer = buf },
      { "<leader>k", group = "Kernel / remoto", buffer = buf },
    })
  end
end

return {
  "LumbaBalumba/nvjup",
  lazy = false, -- obligatorio: registra BufReadCmd antes de abrir un *.ipynb
  build = "uv sync --frozen", -- si falta Playwright/Plotly/Bokeh: :Lazy build nvjup
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- parsers: python, markdown, markdown_inline, latex
    "nvim-telescope/telescope.nvim",
    "MeanderingProgrammer/render-markdown.nvim",

    "saghen/blink.compat",
    "folke/snacks.nvim",
  },
  config = function()
    require("nvjup").setup({
      lsp = {
        enabled = true,
        auto_start = true,
        servers = {
          python = {
            {
              name = "nvjup-basedpyright",
              cmd = { "basedpyright-langserver", "--stdio" },
              settings = {
                basedpyright = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = "standard",
                  },
                },
              },
            },
            {
              name = "nvjup-ruff",
              cmd = { "ruff", "server" },
            },
          },
        },
      },
      -- Mapeos por defecto que desactivo porque los gestiono yo / LazyVim
      keymaps = {
        cursor_down = false,
        comment_line = false,
        comment_visual = false,
        format_cell = false,
        next_cell = false,
        previous_cell = false,
      },
      -- Python del kernel si no quieres que lo autodetecte:
      -- kernel = { python_path = vim.fn.expand("~/ruta/proyecto/.venv/bin/python") },
    })

    -- Mapeos buffer-local. Escucho FileType Y el nombre del archivo (*.ipynb)
    -- para que funcione aunque el filetype no sea exactamente "ipynb".
    vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
      group = vim.api.nvim_create_augroup("NvJupUserKeymaps", { clear = true }),
      pattern = { "ipynb", "*.ipynb" },
      callback = function(args)
        attach(args.buf)
      end,
    })
  end,
}
