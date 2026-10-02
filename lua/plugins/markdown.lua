return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "rmd", "quarto", "ipynb" },
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	opts = {
		file_types = { "markdown", "rmd", "quarto", "ipynb" },
		completions = {
			blink = { enabled = false }, -- Desactivado al usar nvim-cmp
		},
		latex = {
			enabled = false, -- Desactivado para no chocar con mdmath/image
		},
		html = {
			enabled = true,
			comment = {
				conceal = true,
			},
		},
		yaml = {
			enabled = true,
		},
	},
	config = function(_, opts)
		require("render-markdown").setup(opts)

		-- Atajo para alternar el renderizado
		vim.keymap.set("n", "<leader>um", function()
			require("render-markdown").toggle()
		end, { desc = "Toggle Render Markdown" })
	end,
}
