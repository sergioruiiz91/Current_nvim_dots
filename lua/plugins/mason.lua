return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
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
