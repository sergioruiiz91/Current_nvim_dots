return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local servers = {
			["lua-language-server"] = {},
			basedpyright = {
				settings = {
					basedpyright = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly",
							typeCheckingMode = "standard",
						},
					},
				},
			},
			rust_analyzer = {},
			jsonls = {},
			yamlls = {},
			taplo = {},
			prismals = {},
		}

		for server, config in pairs(servers) do
			config.capabilities = vim.lsp.protocol.make_client_capabilities()

			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end
	end,
}
