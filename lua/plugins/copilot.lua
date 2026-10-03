return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",

		opts = {
			should_attach = function(bufnr, _)
				if not vim.api.nvim_buf_is_valid(bufnr) then
					return false
				end

				-- nvjup notebooks use buftype=acwrite; terminal and prompt
				-- buffers are not editable source buffers.
				return vim.bo[bufnr].buftype == "" or vim.bo[bufnr].buftype == "acwrite"
			end,
			suggestion = {
				enabled = false,
				auto_trigger = false,

				keymap = {
					accept = "<C-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				["*"] = true, -- Evita que ningún filetype reactive suggestion
			},
			panel = {
				enabled = false,
			},
		},

		config = function(_, opts)
			require("copilot").setup(opts)

			vim.keymap.set("n", "<leader>ña", "<cmd>Copilot auth<cr>", {
				desc = "Copilot: Authenticate",
			})

			vim.keymap.set("n", "<leader>ñs", "<cmd>Copilot status<cr>", {
				desc = "Copilot: Status",
			})

			vim.keymap.set("n", "<leader>ñt", function()
				local copilot = require("copilot.command")
				copilot.toggle()

				vim.schedule(function()
					local attached = #vim.lsp.get_clients({ bufnr = 0, name = "copilot" }) > 0
					vim.notify("Copilot: " .. (attached and "ENABLED" or "DISABLED"))
				end)
			end, {
				desc = "Copilot: Toggle",
			})
		end,
	},
}
