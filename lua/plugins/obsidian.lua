return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	ft = "markdown",
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/Zettlekasten_vault/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/Zettlekasten_vault/**.md",
	},
	cmd = {
		"ObsidianNew",
		"ObsidianQuickSwitch",
		"ObsidianTemplate",
		"ObsidianToday",
		"ObsidianYesterday",
		"ObsidianTomorrow",
		"ObsidianBacklinks",
		"ObsidianLinks",
		"ObsidianTags",
		"ObsidianOpen",
		"ObsidianExtractNote",
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},

	opts = {
		workspaces = {
			{
				name = "Zettlekasten_vault",
				path = "~/Zettlekasten_vault/",
			},
		},

		new_notes_location = "current_dir",

		ui = {
			enable = false,
		},

		picker = {
			name = "telescope.nvim",
		},

		-- Integración directa con blink.cmp (sin buscar nvim-cmp)
		completion = {
			blink = true,
			min_chars = 2,
		},

		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},

		-- Formato personalizado de ID para notas (evita nombres caóticos)
		note_id_func = function(title)
			if title ~= nil then
				-- Si das título, sanitiza el nombre
				return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- Si no das título, crea timestamp Zettelkasten
				return tostring(os.date("%Y%m%d%H%M"))
			end
		end,
	},

	config = function(_, opts)
		require("obsidian").setup(opts)

		local map = vim.keymap.set

		-- Navegación y creación
		map("n", "<leader>nn", "<cmd>ObsidianNew<cr>", { desc = "Notes: New note" })
		map("n", "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Notes: Find notes" })
		map("n", "<leader>nt", "<cmd>ObsidianTemplate<cr>", { desc = "Notes: Insert template" })
		map("n", "<leader>nb", "<cmd>ObsidianBacklinks<cr>", { desc = "Notes: Backlinks" })
		map("n", "<leader>nl", "<cmd>ObsidianLinks<cr>", { desc = "Notes: Links" })
		map("n", "<leader>ng", "<cmd>ObsidianTags<cr>", { desc = "Notes: Tags" })
		map("n", "<leader>no", "<cmd>ObsidianOpen<cr>", { desc = "Notes: Open in app" })

		-- Seguir enlaces (equivalente a gf para [[links]])
		map("n", "<cr>", function()
			if require("obsidian").util.cursor_on_markdown_link() then
				return "<cmd>ObsidianFollowLink<cr>"
			else
				return "<cr>"
			end
		end, { expr = true, desc = "Notes: Follow link under cursor" })

		-- Visual: extraer selección a nueva nota
		map("v", "<leader>ne", "<cmd>ObsidianExtractNote<cr>", { desc = "Notes: Extract selection" })
	end,
}
