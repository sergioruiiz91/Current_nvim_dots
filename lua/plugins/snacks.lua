return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- 1. Guías de indentación inteligentes con Treesitter
		indent = {
			enabled = true,
			animate = { enabled = false }, -- Desactivamos animaciones pesadas para máxima velocidad
		},

		-- 2. Sistema de notificaciones flotantes modernas
		notifier = {
			enabled = true,
			timeout = 3000, -- Tiempo que se quedan visibles (ms)
		},

		-- 3. Integración con LazyGit en ventana flotante
		lazygit = {
			enabled = true,
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)
	end,
}
