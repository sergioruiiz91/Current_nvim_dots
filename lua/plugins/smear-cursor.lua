return {
	"sphamba/smear-cursor.nvim",
	event = "VeryLazy",
	opts = {
		-- Suavizado y estela entre líneas y movimientos
		smear_between_buffers = true,
		smear_between_neighbor_lines = true,
		scroll_buffer_space = true,
		smear_insert_mode = true,

		-- Velocidad de refresco (baja los milisegundos si notas lag)
		time_interval = 14,

		-- Ajusta la "elasticidad" de la estela (más bajo = más rebote)
		damping = 0.85,
	},
}
