-- Telescope fuzzy finding (all the things)
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",

    dependencies = {
      "nvim-lua/plenary.nvim",

      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = vim.fn.executable("make") == 1,
      },

      "nvim-telescope/telescope-ui-select.nvim",
    },

    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      -- Telescope configuration
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },

        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")

      -- Which-key groups
      local ok_wk, wk = pcall(require, "which-key")

      if ok_wk then
        wk.add({
          { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
          { "gr", group = "LSP Actions", mode = { "n" } },
        })
      end

      -- ============================================================
      -- Telescope general keymaps
      -- ============================================================

      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {
        desc = "Recently opened",
      })

      vim.keymap.set("n", "<leader><space>", builtin.buffers, {
        desc = "Open buffers",
      })

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, {
        desc = "Search in current buffer",
      })

      vim.keymap.set("n", "<leader>sf", builtin.find_files, {
        desc = "Files",
      })

      vim.keymap.set("n", "<leader>sh", builtin.help_tags, {
        desc = "Help",
      })

      vim.keymap.set("n", "<leader>sw", builtin.grep_string, {
        desc = "Current word",
      })

      vim.keymap.set("n", "<leader>sg", builtin.live_grep, {
        desc = "Grep",
      })

      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, {
        desc = "Diagnostics",
      })

      vim.keymap.set("n", "<C-p>", builtin.keymaps, {
        desc = "Search keymaps",
      })

      -- ============================================================
      -- GOTO / LSP
      -- ============================================================

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),

        callback = function(event)
          local buf = event.buf

          -- --------------------------------------------------------
          -- Navigation
          -- --------------------------------------------------------

          -- Declaration: where the symbol is declared
          vim.keymap.set("n", "grD", vim.lsp.buf.declaration, {
            buffer = buf,
            desc = "GOTO [D]eclaration",
          })

          -- Definition: where the function/symbol is programmed
          vim.keymap.set("n", "grd", builtin.lsp_definitions, {
            buffer = buf,
            desc = "GOTO [D]efinition",
          })

          -- References: where the function/symbol is used
          vim.keymap.set("n", "grr", builtin.lsp_references, {
            buffer = buf,
            desc = "GOTO [R]eferences",
          })

          -- Implementation: concrete implementation of a symbol/interface
          vim.keymap.set("n", "gri", builtin.lsp_implementations, {
            buffer = buf,
            desc = "GOTO [I]mplementation",
          })

          -- Type definition: where the type of the symbol is defined
          vim.keymap.set("n", "grt", builtin.lsp_type_definitions, {
            buffer = buf,
            desc = "GOTO [T]ype Definition",
          })

          -- --------------------------------------------------------
          -- Symbols
          -- --------------------------------------------------------

          -- Symbols in current document
          vim.keymap.set("n", "grl", builtin.lsp_document_symbols, {
            buffer = buf,
            desc = "GOTO [L]ist — Document Symbols",
          })

          -- Symbols across the workspace/project
          vim.keymap.set("n", "grL", builtin.lsp_dynamic_workspace_symbols, {
            buffer = buf,
            desc = "GOTO [L]ist — Workspace Symbols",
          })
          -- --------------------------------------------------------
          -- Diagnostics
          -- --------------------------------------------------------

          -- Diagnostics in current document
          vim.keymap.set("n", "grx", function()
            builtin.diagnostics({ bufnr = buf })
          end, {
            buffer = buf,
            desc = "LSP Diagnostics",
          })

          -- --------------------------------------------------------
          -- Code Actions
          -- --------------------------------------------------------

          -- Quick fixes / refactors / LSP actions
          vim.keymap.set("n", "gra", vim.lsp.buf.code_action, {
            buffer = buf,
            desc = "LSP Code Actions",
          })
        end,
      })
    end,
  },
}
