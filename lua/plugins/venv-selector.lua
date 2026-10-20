return {
	"linux-cultist/venv-selector.nvim",
	branch = "regexp", -- Se recomienda usar la rama branch = "regexp" para la versión moderna del plugin
	ft = { "python" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		notify_user_on_venv_activation = true,
	},
}
