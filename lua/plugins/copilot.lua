return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",

		opts = {
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
				if vim.b.copilot_enabled == false then
					vim.cmd("Copilot enable")
					vim.notify("Copilot: ENABLED")
				else
					vim.cmd("Copilot disable")
					vim.notify("Copilot: DISABLED")
				end
			end, {
				desc = "Copilot: Toggle",
			})
		end,
	},
}
