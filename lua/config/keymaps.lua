-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

local function command(command, description, modes)
  map(modes or "n", command[1], command[2], { desc = description })
end

local function hide_r_console()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "rout" or vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_win_hide(win)
      return
    end
  end
end

local function configure_r_keymaps(buf)
  local filetype = vim.bo[buf].filetype
  local chunk = filetype == "r" and "<Plug>RSendParagraph" or "<Plug>RSendChunk"
  local chunk_description = filetype == "r" and "Enviar párrafo" or "Ejecutar chunk R"

  local opts = { buffer = buf, remap = true, silent = true }
  map(
    "n",
    "<leader>rf",
    "<Plug>RStart",
    vim.tbl_extend("force", opts, {
      desc = "Iniciar / mostrar consola R",
    })
  )
  map("n", "<leader>rq", hide_r_console, {
    buffer = buf,
    silent = true,
    desc = "Ocultar consola R",
  })
  map(
    "n",
    "<leader>rl",
    "<Plug>RDSendLine",
    vim.tbl_extend("force", opts, {
      desc = "Enviar línea a R",
    })
  )
  map(
    "n",
    "<CR>",
    "<Plug>RDSendLine",
    vim.tbl_extend("force", opts, {
      desc = "Enviar línea a R",
    })
  )
  map(
    "n",
    "<leader>rc",
    chunk,
    vim.tbl_extend("force", opts, {
      desc = chunk_description,
    })
  )
  map(
    "x",
    "<leader>r<CR>",
    "<Plug>RSendSelection",
    vim.tbl_extend("force", opts, {
      desc = "Enviar selección a R",
    })
  )
  map(
    "n",
    "<leader>rwo",
    "<Plug>ROBToggle",
    vim.tbl_extend("force", opts, {
      desc = "Abrir/cerrar Object Browser",
    })
  )
  map(
    "n",
    "<leader>rwv",
    "<Plug>RViewDF",
    vim.tbl_extend("force", opts, {
      desc = "Ver DataFrame interactivo",
    })
  )

  map(
    "n",
    "g<A-o>",
    "<Plug>RListSpace",
    vim.tbl_extend("force", opts, {
      desc = "Listar objetos en consola",
    })
  )
  map(
    "n",
    "<leader>rws",
    "<Plug>RSummary",
    vim.tbl_extend("force", opts, {
      desc = "Resumen estadístico",
    })
  )
  map(
    "n",
    "<leader>rk",
    "<Plug>RKnit",
    vim.tbl_extend("force", opts, {
      desc = "Render R Markdown",
    })
  )

  if filetype == "quarto" then
    map(
      "n",
      "<leader>qr",
      "<Plug>RQuartoRender",
      vim.tbl_extend("force", opts, {
        desc = "Render Quarto",
      })
    )
    map(
      "n",
      "<leader>qp",
      "<Plug>RQuartoPreview",
      vim.tbl_extend("force", opts, {
        desc = "Preview Quarto",
      })
    )
    map(
      "n",
      "<leader>qs",
      "<Plug>RQuartoStop",
      vim.tbl_extend("force", opts, {
        desc = "Parar preview de Quarto",
      })
    )
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user-r-keymaps", { clear = true }),
  pattern = { "r", "rmd", "quarto" },
  callback = function(args)
    configure_r_keymaps(args.buf)
  end,
})
if vim.tbl_contains({ "r", "rmd", "quarto" }, vim.bo.filetype) then
  configure_r_keymaps(0)
end

local telescope = require("telescope.builtin")

map("n", "<leader>fr", telescope.oldfiles, { desc = "Recently opened" })
map("n", "<leader><space>", telescope.buffers, { desc = "Open buffers" })
map("n", "<leader>/", function()
  telescope.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "Search in current buffer" })
map("n", "<leader>sf", telescope.find_files, { desc = "Files" })
map("n", "<leader>sh", telescope.help_tags, { desc = "Help" })
map("n", "<leader>sw", telescope.grep_string, { desc = "Current word" })
map("n", "<leader>sg", telescope.live_grep, { desc = "Grep" })
map("n", "<leader>sd", telescope.diagnostics, { desc = "Diagnostics" })
map("n", "<C-p>", telescope.keymaps, { desc = "Search keymaps" })

local function configure_lsp_keymaps(buf)
  local opts = { buffer = buf, silent = true, remap = false }
  local defaults = {
    "gd",
    "gD",
    "gr",
    "gri",
    "gI",
    "gt",
    "gy",
    "K",
    "gK",
    "<C-k>",
    "ga",
    "gra",
    "<leader>ca",
    "<leader>cc",
    "<leader>cC",
    "<leader>cR",
    "<leader>cr",
    "<leader>cA",
    "<leader>co",
    "<leader>cl",
    "]]",
    "[[",
    "<A-n>",
    "<A-p>",
  }
  for _, lhs in ipairs(defaults) do
    pcall(vim.keymap.del, "n", lhs, { buffer = buf })
    pcall(vim.keymap.del, "x", lhs, { buffer = buf })
    pcall(vim.keymap.del, "i", lhs, { buffer = buf })
  end

  map(
    "n",
    "gd",
    vim.lsp.buf.definition,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Ir a la definición",
    })
  )
  map(
    "n",
    "gD",
    vim.lsp.buf.declaration,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Ir a la declaración (Headers/Prototypes)",
    })
  )
  map(
    "n",
    "gr",
    vim.lsp.buf.references,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Listar referencias (Donde se usa)",
    })
  )
  map(
    "n",
    "gri",
    vim.lsp.buf.implementation,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Ir a la implementación (Traits/Interfaces/Clases)",
    })
  )
  map(
    "n",
    "gt",
    vim.lsp.buf.type_definition,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Ir a la definición del tipo de dato",
    })
  )
  map(
    "n",
    "gh",
    function()
      vim.lsp.buf.hover({ border = "rounded", focusable = true })
    end,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Mostrar documentación y firma",
    })
  )
  map(
    "n",
    "ga",
    vim.lsp.buf.code_action,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Acciones de código / Refactorización",
    })
  )
  map(
    "n",
    "go",
    vim.lsp.buf.document_symbol,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Símbolos del archivo actual",
    })
  )
  map(
    "n",
    "gO",
    vim.lsp.buf.workspace_symbol,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Símbolos de todo el proyecto",
    })
  )
  map(
    "n",
    "gx",
    vim.diagnostic.setloclist,
    vim.tbl_extend("force", opts, {
      desc = "LSP: Diagnósticos y errores del archivo",
    })
  )
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-keymaps", { clear = true }),
  callback = function(args)
    configure_lsp_keymaps(args.buf)
  end,
})
if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
  configure_lsp_keymaps(0)
end

command({
  "<leader>cf",
  function()
    require("conform").format({ async = true })
  end,
}, "Format buffer", { "n", "v" })
command({ "<leader>oe", "<CMD>Oil<CR>" }, "Open Oil (parent dir)")
command({ "<leader>oo", "<CMD>Oil --float<CR>" }, "Open Oil (floating)")
map("n", "<leader>-", function()
  local oil = require("oil")
  local current_file = vim.api.nvim_buf_get_name(0)
  oil.open(current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or nil)
end, { desc = "Open Oil in current file's directory" })

command({ "<leader>vs", "<cmd>VenvSelect<CR>" }, "[V]irtualenv [S]elect")
command({
  "<leader>gg",
  function()
    Snacks.lazygit()
  end,
}, "Git: Open LazyGit")
command({
  "<leader>um",
  function()
    require("render-markdown").toggle()
  end,
}, "Toggle Render Markdown")

command({
  "<leader>qs",
  function()
    require("persistence").load()
  end,
}, "Restore Session")
command({
  "<leader>qS",
  function()
    require("persistence").select()
  end,
}, "Select a Session to Load")
command({
  "<leader>ql",
  function()
    require("persistence").load({ last = true })
  end,
}, "Restore Last Session")
command({
  "<leader>qd",
  function()
    require("persistence").stop()
  end,
}, "Don't Save Current Session")

command({ "<leader>ña", "<cmd>Copilot auth<cr>" }, "Copilot: Authenticate")
command({ "<leader>ñs", "<cmd>Copilot status<cr>" }, "Copilot: Status")
map("n", "<leader>ñt", function()
  require("copilot.command").toggle()
  vim.schedule(function()
    local attached = #vim.lsp.get_clients({ bufnr = 0, name = "copilot" }) > 0
    vim.notify("Copilot: " .. (attached and "ENABLED" or "DISABLED"))
  end)
end, { desc = "Copilot: Toggle" })

command({ "<leader>nn", "<cmd>ObsidianNew<cr>" }, "Notes: New note")
command({ "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>" }, "Notes: Find notes")
command({ "<leader>nt", "<cmd>ObsidianTemplate<cr>" }, "Notes: Insert template")
command({ "<leader>nb", "<cmd>ObsidianBacklinks<cr>" }, "Notes: Backlinks")
command({ "<leader>nl", "<cmd>ObsidianLinks<cr>" }, "Notes: Links")
command({ "<leader>ng", "<cmd>ObsidianTags<cr>" }, "Notes: Tags")
command({ "<leader>no", "<cmd>ObsidianOpen<cr>" }, "Notes: Open in app")
map("v", "<leader>ne", "<cmd>ObsidianExtractNote<cr>", { desc = "Notes: Extract selection" })
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user-obsidian-keymaps", { clear = true }),
  pattern = "markdown",
  callback = function(args)
    map("n", "<CR>", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<cr>"
      end
      return "<CR>"
    end, { buffer = args.buf, expr = true, desc = "Notes: Follow link under cursor" })
  end,
})
if vim.bo.filetype == "markdown" then
  map("n", "<CR>", function()
    if require("obsidian").util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<cr>"
    end
    return "<CR>"
  end, { expr = true, desc = "Notes: Follow link under cursor" })
end

local mc = require("multicursor-nvim")
map({ "n", "x" }, "<leader>mj", function()
  mc.matchAddCursor(1)
end, { desc = "Add cursor next match" })
map({ "n", "x" }, "<leader>mk", function()
  mc.matchAddCursor(-1)
end, { desc = "Add cursor prev match" })
map({ "n", "x" }, "<leader>mn", function()
  mc.matchSkipCursor(1)
end, { desc = "Skip to next match" })
map({ "n", "x" }, "<leader>mp", function()
  mc.matchSkipCursor(-1)
end, { desc = "Skip to prev match" })
map({ "n", "x" }, "<leader>ma", function()
  mc.matchAllAddCursors(-1)
end, { desc = "All cursor for this" })
map({ "n", "x" }, "<leader>m&", function()
  mc.alignCursors(-1)
end, { desc = "Align Cursors" })

map("n", "<c-leftmouse>", mc.handleMouse)
map("n", "<c-leftdrag>", mc.handleMouseDrag)
map("x", "<leader>mx", mc.matchCursors, { desc = "Match cursors (visual)" })
map("n", "<c-leftrelease>", mc.handleMouseRelease)
map({ "n", "x" }, "<leader>mt", mc.toggleCursor, { desc = "Toggle cursor" })
mc.addKeymapLayer(function(layer_set)
  layer_set({ "n", "x" }, "<left>", mc.prevCursor)
  layer_set({ "n", "x" }, "<right>", mc.nextCursor)
  layer_set({ "n", "x" }, "<leader>x", mc.deleteCursor)
  layer_set("n", "<esc>", function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
  layer_set({ "n", "x" }, "q", mc.clearCursors)
end)

map("n", "<leader>zz", "za", { remap = true, desc = "Folding: toggle current" })
map("n", "<leader>za", "zR", { remap = true, desc = "Folding: open all" })
map("n", "<leader>zc", "zM", { remap = true, desc = "Folding: close all" })
for level = 1, 4 do
  map("n", "<leader>z" .. level, function()
    vim.cmd("normal! zM")
    vim.wo.foldlevel = level - 1
  end, { desc = "Folding: close level " .. level .. " and deeper" })
end
map("n", "<leader>z9", "zR", { remap = true, desc = "Folding: show all levels" })

local ok_wk, wk = pcall(require, "which-key")
if ok_wk then
  wk.add({
    { "<leader>r", group = "R" },
    { "<leader>rw", group = "Workspace / Data" },
    { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
    { "gr", group = "LSP Actions", mode = { "n" } },
  })
end
