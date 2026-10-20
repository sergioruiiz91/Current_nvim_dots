return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "rmd", "quarto" },
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	opts = {
		file_types = { "markdown", "rmd", "quarto" },
		completions = {
			blink = { enabled = false },
		},
		latex = {
			enabled = false, -- Desactivado para no chocar con image.nvim
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
	end,
}
