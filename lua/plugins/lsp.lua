return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	opts = function(_, opts)
		opts.servers = opts.servers or {}
		opts.servers["*"] = type(opts.servers["*"]) == "table" and opts.servers["*"] or {}
		opts.servers["*"].keys = false
		return opts
	end,
	config = function()
		local servers = {
			["lua-language-server"] = {},
			r_language_server = {
				cmd = { "R", "--slave", "-e", "languageserver::run()" },
				filetypes = { "r", "rmd", "quarto" },
				root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, {
						".git",
						".Rproj",
						"_quarto.yml",
						"_quarto.yaml",
					})
					on_dir(root or vim.fn.getcwd())
				end,
				on_init = function(client)
					for _, capability in ipairs({
						"completionProvider",
						"hoverProvider",
						"signatureHelpProvider",
						"definitionProvider",
						"referencesProvider",
						"implementationProvider",
						"documentHighlightProvider",
						"documentSymbolProvider",
						"workspaceSymbolProvider",
						"renameProvider",
					}) do
						client.server_capabilities[capability] = nil
					end
				end,
			},
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
