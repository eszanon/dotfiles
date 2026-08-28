-- Personal input overrides, ported from the pre-Quattro input.conf.

hl.config({
  input = {
    -- br leads: Hyprland resolves keybindings against the first layout, and it
    -- has to be a Latin one for SUPER + W and friends to fire.
    kb_layout = "br,us",

    -- kb_options replaces Omarchy's default string rather than adding to it,
    -- so the two defaults are repeated here:
    --   compose:caps                 CapsLock is the compose key
    --   shift:both_capslock_cancel   both Shifts toggle CapsLock, one cancels
    --
    -- Layout switch is on both Alts, not Alt+Shift: shift:both_capslock_cancel
    -- puts Caps_Lock on level 2 of each Shift, which is exactly the slot
    -- grp:alt_shift_toggle needs for ISO_Next_Group. The two cancel out, and
    -- the Shift option wins. grp:alts_toggle sits on the Alt keys instead and
    -- coexists with it. Verify with:
    --   xkbcli compile-keymap --layout br,us --options "<options>" | grep -A3 "key <LFSH>"
    kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",

    touchpad = {
      -- Natural (inverse) scrolling. Omarchy's default is false.
      natural_scroll = true,
    },
  },
})

-- Three-finger vertical swipe toggles the scratchpad. Ported from the
-- pre-Quattro scratchpad.conf: gesture = 3, vertical, special, scratchpad
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "scratchpad" })
