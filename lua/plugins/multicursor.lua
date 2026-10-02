return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	event = "VeryLazy",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		local set = vim.keymap.set

		-- Añadir o saltar cursores arriba/abajo
		set({ "n", "x" }, "<up>", function()
			mc.lineAddCursor(-1)
		end)
		set({ "n", "x" }, "<down>", function()
			mc.lineAddCursor(1)
		end)
		set({ "n", "x" }, "<leader><up>", function()
			mc.lineSkipCursor(-1)
		end)
		set({ "n", "x" }, "<leader><down>", function()
			mc.lineSkipCursor(1)
		end)

		-- Añadir por coincidencia de palabra/selección
		set({ "n", "x" }, "<leader>mj", function()
			mc.matchAddCursor(1)
		end, { desc = "Add cursor next match" })
		set({ "n", "x" }, "<leader>mk", function()
			mc.matchAddCursor(-1)
		end, { desc = "Add cursor prev match" })
		set({ "n", "x" }, "<leader>ml", function()
			mc.matchSkipCursor(1)
		end, { desc = "Skip to next match" })
		set({ "n", "x" }, "<leader>mh", function()
			mc.matchSkipCursor(-1)
		end, { desc = "Skip to prev match" })

		-- Ratón (Ctrl + Click)
		set("n", "<c-leftmouse>", mc.handleMouse)
		set("n", "<c-leftdrag>", mc.handleMouseDrag)
		set("n", "<c-leftrelease>", mc.handleMouseRelease)

		-- Activar / Desactivar cursores
		set({ "n", "x" }, "<leader>mt", function()
			mc.toggleCursor()
		end, { desc = "Toggle cursor" })

		-- Capa de atajos activa solo cuando hay múltiples cursores
		mc.addKeymapLayer(function(layerSet)
			layerSet({ "n", "x" }, "<left>", mc.prevCursor)
			layerSet({ "n", "x" }, "<right>", mc.nextCursor)
			layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

			layerSet("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end)

			layerSet({ "n", "x" }, "q", function()
				mc.clearCursors()
			end)
		end)

		-- Highlights de cursores
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
