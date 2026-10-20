return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      char = {
        enabled = false,
      },
    },
  },
  keys = {
    {
      "<leader>ms",
      mode = "n",
      function()
        require("flash").jump({
          search = {
            mode = "exact",
            max_length = 2,
          },
        })
      end,
      desc = "Flash: saltar usando dos caracteres",
    },
    {
      "<leader>mf",
      mode = "n",
      function()
        require("flash").jump({
          search = {
            mode = "exact",
            max_length = 1,
          },
        })
      end,
      desc = "Flash: saltar a un carácter",
    },
    {
      "<leader>ml",
      mode = "n",
      function()
        require("flash").jump({
          search = {
            mode = "search",
            max_length = 0,
          },
          label = {
            after = { 0, 0 },
          },
          pattern = "^",
        })
      end,
      desc = "Flash: saltar a una línea",
    },
    {
      "<leader>mw",
      mode = "n",
      function()
        require("flash").jump({
          search = {
            mode = "search",
            max_length = 0,
          },
          pattern = "\\<\\k",
        })
      end,
      desc = "Flash: saltar a una palabra",
    },
  },
}
