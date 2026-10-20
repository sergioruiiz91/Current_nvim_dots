return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local ls = require("luasnip")

			-- ============================================================
			-- FRIENDLY-SNIPPETS
			-- ============================================================

			-- Cargar snippets generales compatibles con VS Code
			require("luasnip.loaders.from_vscode").lazy_load()

			-- ============================================================
			-- SNIPPETS PROPIOS
			-- ============================================================

			local obsidian = require("snippets.obsidian")

			-- Markdown
			ls.add_snippets("markdown", obsidian)

			-- Quarto
			ls.add_snippets("quarto", obsidian)

			-- R Markdown
			ls.add_snippets("rmd", obsidian)

		end,
	},
}
