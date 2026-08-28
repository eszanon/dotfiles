-- Personal look'n'feel overrides. Omarchy's defaults load first; only the
-- differences live here.

-- Slide the scratchpad down from the top instead of the default fade.
-- Ported from the pre-Quattro scratchpad.conf:
--   animation = specialWorkspace, 1, 2, default, slide top
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2, bezier = "default", style = "slide top" })
