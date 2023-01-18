local wezterm = require("wezterm")
return {
    font = wezterm.font_with_fallback({
        "Source code pro",
    }),
    leader = { key = 'F1', mods = 'CTRL', timeout_milliseconds = 1000 },
    default_prog = { '/usr/bin/fish' },
    font_size = 20,
    keys = {
        {
            mods = "ALT|SHIFT",
            key = [[i]],
            action = wezterm.action.SplitPane({
                top_level = true,
                direction = "Right",
                size = { Percent = 50 },
            }),
        },
        {
            mods = "ALT",
            key = [[i]],
            action = wezterm.action.SplitPane({
                direction = "Right",
                size = { Percent = 50 },
            }),
        },
        {
            mods = "ALT|SHIFT",
            key = [[e]],
            action = wezterm.action.SplitPane({
                top_level = true,
                direction = "Up",
                size = { Percent = 50 },
            }),
        },
        {
            mods = "ALT",
            key = [[e]],
            action = wezterm.action.SplitPane({
                direction = "Up",
                size = { Percent = 50 },
            }),
        },
        {
            key = "n",
            mods = "ALT",
            action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
        },
        {
            key = "q",
            mods = "ALT",
            action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
        },
        { key = "z", mods = "ALT", action = wezterm.action.TogglePaneZoomState },
        { key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
        { key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
        { key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
        { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },

        { key = "h", mods = "ALT", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
        { key = "j", mods = "ALT", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
        { key = "k", mods = "ALT", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
        { key = "l", mods = "ALT", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },

        { key = "[", mods = "ALT", action = wezterm.action({ ActivateTabRelative = -1 }) },
        { key = "]", mods = "ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },
        { key = "{", mods = "SHIFT|ALT", action = wezterm.action.MoveTabRelative(-1) },
        { key = "}", mods = "SHIFT|ALT", action = wezterm.action.MoveTabRelative(1) },
        --{ key = "v", mods = "ALT", action = wezterm.action.ActivateCopyMode },
        { key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
        { key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
        { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
        { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
        { key = "1", mods = "ALT", action = wezterm.action({ ActivateTab = 0 }) },
        { key = "2", mods = "ALT", action = wezterm.action({ ActivateTab = 1 }) },
        { key = "3", mods = "ALT", action = wezterm.action({ ActivateTab = 2 }) },
        { key = "4", mods = "ALT", action = wezterm.action({ ActivateTab = 3 }) },
        { key = "5", mods = "ALT", action = wezterm.action({ ActivateTab = 4 }) },
        { key = "6", mods = "ALT", action = wezterm.action({ ActivateTab = 5 }) },
        { key = "7", mods = "ALT", action = wezterm.action({ ActivateTab = 6 }) },
        { key = "8", mods = "ALT", action = wezterm.action({ ActivateTab = 7 }) },
        { key = "9", mods = "ALT", action = wezterm.action({ ActivateTab = 8 }) },
    },
}
