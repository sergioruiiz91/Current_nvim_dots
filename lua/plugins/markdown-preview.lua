return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown", "rmd", "quarto" },
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown", "rmd", "quarto" }
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_browser = "chromium"
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_command_for_global = 0
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_echo_preview_url = 0
  end,
  config = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*.md", "*.mkd", "*.mdown", "*.mkdn", "*.mdwn", "*.rmd", "*.qmd" },
      callback = function()
        if vim.fn.exists("*mkdp#rpc#get_server_status") == 1
            and vim.fn["mkdp#rpc#get_server_status"]() == 1 then
          vim.fn["mkdp#autocmd#init"]()
          vim.fn["mkdp#rpc#preview_refresh"]()
        end
      end,
      group = vim.api.nvim_create_augroup("markdown_preview_refresh", { clear = true }),
    })
  end,
}
