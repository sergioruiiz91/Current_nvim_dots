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

				-- Terminal and prompt buffers are not editable source buffers.
				return vim.bo[bufnr].buftype == ""
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
		end,
	},
}
