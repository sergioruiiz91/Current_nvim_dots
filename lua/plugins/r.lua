return {
  "R-nvim/R.nvim",
  lazy = false,
  opts = {
    auto_start = "on startup",
    objbr_auto_start = true,
    objbr_place = "script,right",
    objbr_opendf = true,
    objbr_openlist = true,
    auto_quit = true,
    auto_maps = false,
    r_ls = {
      completion = true,
      hover = true,
      signature = true,
      implementation = true,
      definition = true,
      references = true,
      document_highlight = true,
      document_symbol = true,
      workspace_symbol = true,
      rename = true,
      use_git_files = true,
    },
    R_args = { "--quiet", "--no-save" },
    rconsole_width = 0,
    rconsole_height = 20,
    min_editor_width = 72,
    register_treesitter = true,
    set_params = "yes",
  },
  config = function(_, opts)
    vim.g.R_filetypes = { "r", "rmd", "quarto", "rnoweb", "rhelp" }
    require("r").setup(opts)
  end,
}
