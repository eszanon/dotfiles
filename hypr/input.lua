-- Personal input overrides, ported from the pre-Quattro input.conf.

hl.config({
  input = {
    -- br leads: Hyprland resolves keybindings against the first layout, and it
    -- has to be a Latin one for SUPER + W and friends to fire.
    kb_layout = "br,us",

    -- kb_options replaces Omarchy's default string rather than adding to it.
    --   compose:caps         CapsLock is the compose key (Omarchy default)
    --   grp:alt_shift_toggle Alt+Shift switches layout
    --
    -- Omarchy's other default, shift:both_capslock_cancel, is dropped on
    -- purpose: it puts Caps_Lock on level 2 of each Shift, the same slot
    -- grp:alt_shift_toggle needs for ISO_Next_Group, so Alt-then-Shift stops
    -- switching. Side effect: there is no CapsLock at all. Verify with:
    --   xkbcli compile-keymap --layout br,us --options "<options>" | grep -A3 "key <LFSH>"
    kb_options = "compose:caps,grp:alt_shift_toggle",

    touchpad = {
      -- Natural (inverse) scrolling. Omarchy's default is false.
      natural_scroll = true,
    },
  },
})

-- Three-finger vertical swipe toggles the scratchpad. Ported from the
-- pre-Quattro scratchpad.conf: gesture = 3, vertical, special, scratchpad
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "scratchpad" })
