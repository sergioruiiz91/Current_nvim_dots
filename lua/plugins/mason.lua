return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls",
				"basedpyright",
				"rust_analyzer",
				"jsonls",
				"yamlls",
				"taplo",
				"prismals",
			},
			automatic_installation = true,
		},
	},
}
