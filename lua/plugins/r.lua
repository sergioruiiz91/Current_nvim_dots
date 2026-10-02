return {
  "R-nvim/R.nvim",
  lazy = false,
  opts = {
    auto_start = "on startup",
    objbr_auto_start = false,
    auto_quit = true,
    auto_maps = false, -- Desactiva atajos por defecto para mantener control total
    R_args = { "--quiet", "--no-save" },
    rconsole_width = 0,
    rconsole_height = 20,
    min_editor_width = 72,
  },
  config = function(_, opts)
    require("r").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "r", "rmd", "quarto" },
      callback = function(ev)
        local buf = ev.buf
        local ft = vim.bo[buf].filetype
        local chunk_plug = (ft == "r") and "<Plug>RSendParagraph" or "<Plug>RSendChunk"
        local chunk_desc = (ft == "r") and "Enviar párrafo" or "Ejecutar Chunk"

        -- Función para ocultar la consola de R sin terminar la sesión
        local hide_r_console = function()
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local b = vim.api.nvim_win_get_buf(win)
            local buf_ft = vim.bo[b].filetype
            local buf_bt = vim.bo[b].buftype
            if buf_ft == "rout" or buf_bt == "terminal" then
              vim.api.nvim_win_hide(win)
              return
            end
          end
        end

        local ok_wk, wk = pcall(require, "which-key")
        if ok_wk then
          wk.add({
            -- Registro de Grupos en Which-Key
            { "<leader>r", group = "R", buffer = buf },
            { "<leader>rw", group = "Workspace / Data", buffer = buf },

            -- ========================================================
            -- GESTIÓN DE LA CONSOLA / TERMINAL
            -- ========================================================
            {
              "<leader>rf",
              "<Plug>RStart",
              desc = "Iniciar / mostrar consola R (split)",
              buffer = buf,
              remap = true,
            },
            {
              "<leader>rq",
              hide_r_console,
              desc = "Ocultar consola R (mantener viva la sesión)",
              buffer = buf,
            },

            -- ========================================================
            -- EJECUCIÓN (Líneas, Chunks, Párrafos)
            -- ========================================================
            {
              "<leader>rl",
              "<Plug>RDSendLine",
              desc = "Enviar línea a R",
              buffer = buf,
              remap = true,
            },
            {
              "<CR>",
              "<Plug>RDSendLine",
              desc = "Enviar línea a R",
              mode = "n",
              buffer = buf,
              remap = true,
            },
            {
              "<leader>rc",
              chunk_plug,
              desc = chunk_desc,
              buffer = buf,
              remap = true,
            },

            -- ========================================================
            -- SELECCIÓN VISUAL
            -- ========================================================
            {
              mode = { "x" },
              buffer = buf,
              remap = true,
              { "<CR>", "<Plug>RSendSelection", desc = "Enviar selección a R" },
              { "<leader><CR>", "<Plug>RSendSelection", desc = "Enviar selección a R" },
            },

            -- ========================================================
            -- WORKSPACE / INSPECCIÓN DE DATOS (<leader>rw)
            -- ========================================================
            {
              "<leader>rwo",
              "<Plug>ROBToggle",
              desc = "Abrir/cerrar Object Browser",
              buffer = buf,
              remap = true,
            },
            {
              "<leader>rwv",
              "<Plug>RViewDF",
              desc = "Ver DataFrame interactivo (View)",
              buffer = buf,
              remap = true,
            },
            {
              "<leader>rwl",
              "<Plug>RListSpace",
              desc = "Listar objetos en consola (ls)",
              buffer = buf,
              remap = true,
            },
            {
              "<leader>rws",
              "<Plug>RSummary",
              desc = "Resumen estadístico: summary(objeto)",
              buffer = buf,
              remap = true,
            },

            -- ========================================================
            -- KNIT / RENDER (<leader>rk)
            -- ========================================================
            {
              "<leader>rk",
              "<Plug>RKnit",
              desc = "Knit / Render documento",
              buffer = buf,
              remap = true,
            },
          })
        else
          -- Fallback nativo en caso de que Which-Key no esté disponible
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, remap = true, silent = true, desc = desc })
          end

          map("n", "<leader>rf", "<Plug>RStart", "Iniciar consola R (split)")
          vim.keymap.set("n", "<leader>rq", hide_r_console, { buffer = buf, silent = true, desc = "Ocultar consola R" })
          map("n", "<leader>rl", "<Plug>RDSendLine", "Enviar línea")
          map("n", "<CR>", "<Plug>RDSendLine", "Enviar línea")
          map("n", "<leader>rc", chunk_plug, chunk_desc)
          map("x", "<CR>", "<Plug>RSendSelection", "Enviar selección")
          map("x", "<leader><CR>", "<Plug>RSendSelection", "Enviar selección")
          map("n", "<leader>rwo", "<Plug>ROBToggle", "Object Browser")
          map("n", "<leader>rwv", "<Plug>RViewDF", "Ver DataFrame")
          map("n", "<leader>rwl", "<Plug>RListSpace", "Listar objetos")
          map("n", "<leader>rws", "<Plug>RSummary", "summary(objeto)")
          map("n", "<leader>rk", "<Plug>RKnit", "Knit / Render")
        end
      end,
    })
  end,
}
