local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

-- ============================================================
-- HELPERS
-- ============================================================

local function today()
	return os.date("%Y-%m-%d")
end

-- ============================================================
-- TASK SYSTEM
--
-- Orden de las letras:
--
-- d = due date
-- h = hora
-- t = tag
-- f = from -> to
-- e = every
--
-- Ejemplo:
-- taskdht = task + due + hora + tag
-- taskdhtfe = task + due + hora + tag + from/to + every
--
-- La idea es que las letras SIEMPRE vayan en este orden.
-- ============================================================

return {

	-- ==========================================================
	-- TASK
	-- ==========================================================

	s(
		"task",
		fmt("- [ ] {}", {
			i(1, "Tarea"),
		}),
		{ desc = "Task" }
	),

	-- ==========================================================
	-- UNA PROPIEDAD
	-- ==========================================================

	-- taskd = due date
	s(
		"taskd",
		fmt("- [ ] {} 📅 {}", {
			i(1, "Tarea"),
			i(2, today()),
		}),
		{ desc = "Task + due" }
	),

	-- taskh = hora
	s(
		"taskh",
		fmt("- [ ] {} ⏰ {}", {
			i(1, "Tarea"),
			i(2, "18:00"),
		}),
		{ desc = "Task + hora" }
	),

	-- taskt = tag
	s(
		"taskt",
		fmt("- [ ] {} #{}", {
			i(1, "Tarea"),
			i(2, "tag"),
		}),
		{ desc = "Task + tag" }
	),

	-- taskf = from -> to
	s(
		"taskf",
		fmt("- [ ] {} {} → {}", {
			i(1, "Tarea"),
			i(2, "14:00"),
			i(3, "16:00"),
		}),
		{ desc = "Task + from/to" }
	),

	-- taske = every
	s(
		"taske",
		fmt("- [ ] {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, "day"),
			i(3, "18:00"),
		}),
		{ desc = "Task + every + hora" }
	),

	-- ==========================================================
	-- DOS PROPIEDADES
	-- ==========================================================

	-- taskdh = due + hora
	s(
		"taskdh",
		fmt("- [ ] {} 📅 {} ⏰ {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "18:00"),
		}),
		{ desc = "Task + due + hora" }
	),

	-- taskdt = due + tag
	s(
		"taskdt",
		fmt("- [ ] {} 📅 {} #{}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "tag"),
		}),
		{ desc = "Task + due + tag" }
	),

	-- taskdf = due + from/to
	s(
		"taskdf",
		fmt("- [ ] {} 📅 {} {} → {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "14:00"),
			i(4, "16:00"),
		}),
		{ desc = "Task + due + from/to" }
	),

	-- taskde = due + every
	s(
		"taskde",
		fmt("- [ ] {} 📅 {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "day"),
			i(4, "18:00"),
		}),
		{ desc = "Task + due + every + hora" }
	),

	-- taskht = hora + tag
	s(
		"taskht",
		fmt("- [ ] {} ⏰ {} #{}", {
			i(1, "Tarea"),
			i(2, "18:00"),
			i(3, "tag"),
		}),
		{ desc = "Task + hora + tag" }
	),

	-- taskhf = hora + from/to
	s(
		"taskhf",
		fmt("- [ ] {} ⏰ {} {} → {}", {
			i(1, "Tarea"),
			i(2, "18:00"),
			i(3, "14:00"),
			i(4, "16:00"),
		}),
		{ desc = "Task + hora + from/to" }
	),

	-- taskhe = hora + every
	s(
		"taskhe",
		fmt("- [ ] {} ⏰ {} 🔁 every {}", {
			i(1, "Tarea"),
			i(2, "18:00"),
			i(3, "day"),
		}),
		{ desc = "Task + hora + every" }
	),

	-- tasktf = tag + from/to
	s(
		"tasktf",
		fmt("- [ ] {} #{} {} → {}", {
			i(1, "Tarea"),
			i(2, "tag"),
			i(3, "14:00"),
			i(4, "16:00"),
		}),
		{ desc = "Task + tag + from/to" }
	),

	-- taskte = tag + every
	s(
		"taskte",
		fmt("- [ ] {} #{} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, "tag"),
			i(3, "day"),
			i(4, "18:00"),
		}),
		{ desc = "Task + tag + every + hora" }
	),

	-- taskfe = from/to + every
	s(
		"taskfe",
		fmt("- [ ] {} {} → {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, "14:00"),
			i(3, "16:00"),
			i(4, "day"),
			i(5, "18:00"),
		}),
		{ desc = "Task + from/to + every + hora" }
	),

	-- ==========================================================
	-- TRES PROPIEDADES
	-- ==========================================================

	-- taskdht = due + hora + tag
	s(
		"taskdht",
		fmt("- [ ] {} 📅 {} ⏰ {} #{}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "18:00"),
			i(4, "tag"),
		}),
		{ desc = "Task + due + hora + tag" }
	),

	-- taskdhf = due + hora + from/to
	s(
		"taskdhf",
		fmt("- [ ] {} 📅 {} ⏰ {} {} → {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "18:00"),
			i(4, "14:00"),
			i(5, "16:00"),
		}),
		{ desc = "Task + due + hora + from/to" }
	),

	-- taskdhe = due + hora + every
	s(
		"taskdhe",
		fmt("- [ ] {} 📅 {} ⏰ {} 🔁 every {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "18:00"),
			i(4, "day"),
		}),
		{ desc = "Task + due + hora + every" }
	),

	-- taskdtf = due + tag + from/to
	s(
		"taskdtf",
		fmt("- [ ] {} 📅 {} #{} {} → {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "tag"),
			i(4, "14:00"),
			i(5, "16:00"),
		}),
		{ desc = "Task + due + tag + from/to" }
	),

	-- taskdte = due + tag + every
	s(
		"taskdte",
		fmt("- [ ] {} 📅 {} #{} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "tag"),
			i(4, "day"),
			i(5, "18:00"),
		}),
		{ desc = "Task + due + tag + every + hora" }
	),

	-- taskdfe = due + from/to + every
	s(
		"taskdfe",
		fmt("- [ ] {} 📅 {} {} → {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "14:00"),
			i(4, "16:00"),
			i(5, "day"),
			i(6, "18:00"),
		}),
		{ desc = "Task + due + from/to + every + hora" }
	),

	-- taskhtf = hora + tag + from/to
	s(
		"taskhtf",
		fmt("- [ ] {} ⏰ {} #{} {} → {}", {
			i(1, "Tarea"),
			i(2, "18:00"),
			i(3, "tag"),
			i(4, "14:00"),
			i(5, "16:00"),
		}),
		{ desc = "Task + hora + tag + from/to" }
	),

	-- taskhte = hora + tag + every
	s(
		"taskhte",
		fmt("- [ ] {} ⏰ {} #{} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, "18:00"),
			i(3, "tag"),
			i(4, "day"),
			i(5, "18:00"),
		}),
		{ desc = "Task + hora + tag + every + hora" }
	),

	-- taskhfe = hora + from/to + every
	s(
		"taskhfe",
		fmt("- [ ] {} ⏰ {} {} → {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, "18:00"),
			i(3, "14:00"),
			i(4, "16:00"),
			i(5, "day"),
			i(6, "18:00"),
		}),
		{ desc = "Task + hora + from/to + every + hora" }
	),

	-- tasktfe = tag + from/to + every
	s(
		"tasktfe",
		fmt("- [ ] {} #{} {} → {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, "tag"),
			i(3, "14:00"),
			i(4, "16:00"),
			i(5, "day"),
			i(6, "18:00"),
		}),
		{ desc = "Task + tag + from/to + every + hora" }
	),

	-- ==========================================================
	-- CUATRO PROPIEDADES
	-- ==========================================================

	-- taskdhtf = due + hora + tag + from/to
	s(
		"taskdhtf",
		fmt("- [ ] {} 📅 {} ⏰ {} #{} {} → {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "18:00"),
			i(4, "tag"),
			i(5, "14:00"),
			i(6, "16:00"),
		}),
		{ desc = "Task + due + hora + tag + from/to" }
	),

	-- taskdhte = due + hora + tag + every
	s(
		"taskdhte",
		fmt("- [ ] {} 📅 {} ⏰ {} #{} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "18:00"),
			i(4, "tag"),
			i(5, "day"),
			i(6, "18:00"),
		}),
		{ desc = "Task + due + hora + tag + every + hora" }
	),

	-- taskdhfe = due + hora + from/to + every
	s(
		"taskdhfe",
		fmt("- [ ] {} 📅 {} ⏰ {} {} → {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "18:00"),
			i(4, "14:00"),
			i(5, "16:00"),
			i(6, "day"),
			i(7, "18:00"),
		}),
		{ desc = "Task + due + hora + from/to + every + hora" }
	),

	-- taskdtfe = due + tag + from/to + every
	s(
		"taskdtfe",
		fmt("- [ ] {} 📅 {} #{} {} → {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "tag"),
			i(4, "14:00"),
			i(5, "16:00"),
			i(6, "day"),
			i(7, "18:00"),
		}),
		{ desc = "Task + due + tag + from/to + every + hora" }
	),

	-- taskhtfe = hora + tag + from/to + every
	s(
		"taskhtfe",
		fmt("- [ ] {} ⏰ {} #{} {} → {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, "18:00"),
			i(3, "tag"),
			i(4, "14:00"),
			i(5, "16:00"),
			i(6, "day"),
			i(7, "18:00"),
		}),
		{ desc = "Task + hora + tag + from/to + every + hora" }
	),

	-- ==========================================================
	-- TODAS LAS PROPIEDADES
	-- ==========================================================

	-- taskdhtfe = due + hora + tag + from/to + every
	s(
		"taskdhtfe",
		fmt("- [ ] {} 📅 {} ⏰ {} #{} {} → {} 🔁 every {} {}", {
			i(1, "Tarea"),
			i(2, today()),
			i(3, "18:00"),
			i(4, "tag"),
			i(5, "14:00"),
			i(6, "16:00"),
			i(7, "day"),
			i(8, "18:00"),
		}),
		{ desc = "Task + due + hora + tag + from/to + every + hora" }
	),

	-- ==========================================================
	-- CALLOUT
	-- ==========================================================

	s(
		"callout",
		fmt("> {} {}\n> {}", {
			c(1, {
				t("[!info]"),
				t("[!tip]"),
				t("[!warning]"),
				t("[!important]"),
				t("[!question]"),
				t("[!example]"),
				t("[!note]"),
			}),
			i(2, "Título"),
			i(3, "Contenido"),
		}),
		{ desc = "Obsidian callout" }
	),

	-- ==========================================================
	-- LINK
	-- ==========================================================

	s(
		"link",
		fmt("[[{}]]", {
			i(1, "Nota"),
		}),
		{ desc = "Obsidian internal link" }
	),

	-- ==========================================================
	-- IMAGE
	-- ==========================================================

	s(
		"img",
		fmt("![[{}]]", {
			i(1, "imagen.png"),
		}),
		{ desc = "Obsidian image embed" }
	),

	-- ==========================================================
	-- CODE
	-- ==========================================================

	s(
		"code",
		fmt("```{}\n{}\n```", {
			c(1, {
				t("python"),
				t("r"),
				t("bash"),
				t("sql"),
				t("text"),
			}),
			i(2),
		}),
		{ desc = "Markdown code block" }
	),
	s(
		"coder",
		fmt("```{{r}}\n{}\n```", {
			i(1),
		}),
		{ desc = "R Markdown code block" }
	),
}
