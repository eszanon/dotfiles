-- Personal keybinding overrides, ported from the pre-Quattro bindings.conf.
--
-- Only the bindings that differ from Omarchy 4's defaults live here. These
-- already match upstream and were dropped instead of being repeated:
-- browser (+ private), nautilus (+ cwd), editor, 1Password, Signal, Spotify,
-- cliamp, Docker/lazydocker, YouTube, Google Photos, Google Messages, Grok,
-- X (+ post).

-- Terminal -------------------------------------------------------------------

-- Swap Omarchy's two terminal bindings: tmux is the default here, the bare
-- terminal moves to where tmux used to be. omarchy-launch-terminal-tmux runs
-- `tmux attach || tmux new -s Work`, so this reattaches instead of piling up a
-- new session per window. SUPER + CTRL + RETURN still opens herdr.
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Terminal (tmux)", { omarchy = "terminal-tmux" })

hl.unbind("SUPER + ALT + RETURN")
o.bind("SUPER + ALT + RETURN", "Terminal (no tmux)", { omarchy = "terminal" })

-- Applications ---------------------------------------------------------------

-- SUPER + C was "Universal copy" (Quattro's copy-in-any-app helper).
hl.unbind("SUPER + C")
o.bind("SUPER + C", "Visual Studio Code", { launch = "code" })

-- gnome-calculator is no longer installed; qalc is the calculator that ships.
o.bind("SUPER + R", "Calculator", { tui = "qalc" })

-- SUPER + SHIFT + S was "Google Maps".
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Slack", { focus = "slack", launch = "slack" })

o.bind("SUPER + SHIFT + T", "Activity", { tui = "btop" })

-- Upstream binds plain "obsidian"; keep the GPU/IME flags.
hl.unbind("SUPER + SHIFT + O")
o.bind("SUPER + SHIFT + O", "Obsidian", {
  focus = "^obsidian$",
  launch = "obsidian -disable-gpu --enable-wayland-ime",
})

-- Web apps -------------------------------------------------------------------

-- SUPER + SHIFT + A was ChatGPT.
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "Claude", { webapp = "https://claude.ai/" })

-- SUPER + SHIFT + C was the HEY calendar.
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.google.com/calendar/b/0/r" })

-- SUPER + SHIFT + E was HEY email. Lua takes the URL literally, so the "##"
-- escape the old .conf format needed for anchors is gone.
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://mail.google.com/mail/u/0/#inbox" })

-- SUPER + SHIFT + W was Omawrite; upstream puts WhatsApp on SUPER + SHIFT + ALT + G.
hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
