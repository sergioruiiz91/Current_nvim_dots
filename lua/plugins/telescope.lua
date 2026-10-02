-- Telescope fuzzy finding (all the things)
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master", -- Forzar la rama principal para evitar conflictos con Neovim
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
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
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})

			-- Habilitar extensiones
			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")

			-- Integración opcional con which-key para documentar grupos
			local ok_wk, wk = pcall(require, "which-key")
			if ok_wk then
				wk.add({
					{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
					{ "gr", group = "LSP Actions", mode = { "n" } },
				})
			end

			-- Atajos generales de Telescope
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recently opened" })
			vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "Open buffers" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "Search in current buffer" })

			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Current word" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
			vim.keymap.set("n", "<C-p>", builtin.keymaps, { desc = "Search keymaps" })

			-- Atajos de Navegación LSP (Bloque 'g') vinculados a Telescope al conectar un servidor
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
				callback = function(event)
					local buf = event.buf
					vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "GOTO [R]eferences" })
					vim.keymap.set(
						"n",
						"grc",
						builtin.lsp_implementations,
						{ buffer = buf, desc = "GOTO [C]alls / Implementation" }
					)
					vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "GOTO [D]efinition" })
					vim.keymap.set(
						"n",
						"grl",
						builtin.lsp_document_symbols,
						{ buffer = buf, desc = "GOTO LIST objects (Document)" }
					)
					vim.keymap.set(
						"n",
						"grL",
						builtin.lsp_dynamic_workspace_symbols,
						{ buffer = buf, desc = "GOTO LIST  project object (Workspace)" }
					)
					vim.keymap.set(
						"n",
						"grt",
						builtin.lsp_type_definitions,
						{ buffer = buf, desc = "[G]oto [T]ype Definition" }
					)
				end,
			})
		end,
	},
}
