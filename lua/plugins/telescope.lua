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

    end,
  },
}
