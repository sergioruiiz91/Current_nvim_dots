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

local function nvjup_fold(lnum)
  local line = vim.fn.getline(lnum)
  if line:sub(1, 15) == "# %%[nvjup:cell " then
    return ">1"
  end
  return 1
end

local function configure_folds(buf)
  local filetype = vim.bo[buf].filetype
  if vim.tbl_contains({ "markdown", "rmd", "rmarkdown", "quarto" }, filetype) then
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.MarkdownFold(v:lnum)"
    vim.wo.foldenable = true
    vim.wo.foldlevel = 99
  elseif filetype == "nvjup" then
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.NvjupFold(v:lnum)"
    vim.wo.foldenable = true
    vim.wo.foldlevel = 99
  end
end

_G.MarkdownFold = markdown_fold
_G.NvjupFold = nvjup_fold

return {
  {
    "LazyVim/LazyVim",
    init = function()
      local group = vim.api.nvim_create_augroup("user-folding", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "markdown", "rmd", "rmarkdown", "quarto", "nvjup" },
        callback = function(args)
          configure_folds(args.buf)
        end,
      })

      vim.keymap.set("n", "<leader>zz", "za", {
        remap = true,
        desc = "Folding: toggle current",
      })
      vim.keymap.set("n", "<leader>za", "zR", {
        remap = true,
        desc = "Folding: open all",
      })
      vim.keymap.set("n", "<leader>zc", "zM", {
        remap = true,
        desc = "Folding: close all",
      })

      for level = 1, 4 do
        vim.keymap.set("n", "<leader>z" .. level, function()
          vim.cmd("normal! zM")
          vim.wo.foldlevel = level - 1
        end, {
          desc = "Folding: close level " .. level .. " and deeper",
        })
      end

      vim.keymap.set("n", "<leader>z9", "zR", {
        remap = true,
        desc = "Folding: show all levels",
      })
    end,
  },
}
