local function markdown_fold(lnum)
  local line = vim.fn.getline(lnum)
  local level = line:match("^%s*(#+)%s+")
  if level then
    return ">" .. #level
  end

  local previous = lnum - 1
  while previous > 0 do
    local previous_line = vim.fn.getline(previous)
    local previous_level = previous_line:match("^%s*(#+)%s+")
    if previous_level then
      return #previous_level
    end
    previous = previous - 1
  end

  return 0
end

local function configure_folds(buf)
  local filetype = vim.bo[buf].filetype
  if vim.tbl_contains({ "markdown", "rmd", "rmarkdown", "quarto" }, filetype) then
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.MarkdownFold(v:lnum)"
    vim.wo.foldenable = true
    vim.wo.foldlevel = 99
  end
end

_G.MarkdownFold = markdown_fold

return {
  {
    "LazyVim/LazyVim",
    init = function()
      local group = vim.api.nvim_create_augroup("user-folding", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "markdown", "rmd", "rmarkdown", "quarto" },
        callback = function(args)
          configure_folds(args.buf)
        end,
      })

    end,
  },
}
