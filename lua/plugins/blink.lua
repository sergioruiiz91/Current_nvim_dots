return {
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saghen/blink.compat", -- Necesario para cargar fuentes de nvim-cmp como cmp-latex-symbols
			"rafamadriz/friendly-snippets",
			"giuxtaposition/blink-cmp-copilot",
			"erooke/blink-cmp-latex", -- Completado de comandos LaTeX para blink.cmp
		},
		opts = {
			-- Integración con tu motor actual de snippets (LuaSnip)
			snippets = {
				preset = "luasnip",
			},

			-- Mapeos de teclado
			keymap = {
				preset = "none",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-d>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				-- Acepta solo si has seleccionado una opción; de lo contrario hace salto de línea normal
				["<CR>"] = { "accept", "fallback" },
			},

			-- Control de visualización y selección
			completion = {
				-- Configuración de la lista: NO auto-seleccionar ni auto-insertar
				list = {
					selection = {
						preselect = false, -- No marca la primera opción de forma automática
						auto_insert = false, -- No modifica el texto mientras navegas
					},
				},

				-- Ventana de documentación flotante con tiempo para leer
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500, -- Espera medio segundo antes de desplegar detalles
				},

				menu = {
					draw = {
						columns = {
							{ "kind_icon", gap = 1 },
							{ "label", "label_description", gap = 1 },
							{ "source_name" },
						},
					},
				},
			},

			-- Iconos personalizados
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
				kind_icons = {
					Text = "",
					Method = "m",
					Function = "",
					Constructor = "",
					Field = "",
					Variable = "",
					Class = "",
					Interface = "",
					Module = "",
					Property = "",
					Unit = "",
					Value = "",
					Enum = "",
					Keyword = "",
					Snippet = "",
					Color = "",
					File = "",
					Reference = "",
					Folder = "",
					EnumMember = "",
					Constant = "",
					Struct = "",
					Event = "",
					Operator = "",
					TypeParameter = "",
					Copilot = "",
				},
			},

			-- Fuentes de completado
			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
					"copilot",
					"latex",
				},

				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
					},

					latex = {
						name = "Latex",
						module = "blink-cmp-latex",

						-- Inserta el comando LaTeX en lugar del símbolo Unicode
						-- Ejemplo: \alp -> \alpha en lugar de α
						opts = {
							insert_command = true,
						},

						-- Solo activar en Markdown, Quarto, R Markdown y notebooks
						enabled = function()
							return vim.tbl_contains({
								"markdown",
								"quarto",
								"rmd",
								"rmarkdown",
								"ipynb",
							}, vim.bo.filetype)
						end,
					},
				},
			},
		},

		config = function(_, opts)
			-- Cargar friendly-snippets a través de LuaSnip
			require("luasnip.loaders.from_vscode").lazy_load()
			require("blink.cmp").setup(opts)
		end,
	},
}
