local wezterm = require("wezterm")
return {
    disable_default_key_bindings = true,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    color_scheme = "Dracula",
    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = false,
    font = wezterm.font_with_fallback({
        "Noto Color emoji",
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
        { key = "LeftArrow", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = -1 }) },
        { key = "RightArrow", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },
        --{ key = "v", mods = "ALT", action = wezterm.action.ActivateCopyMode },
        { key = "c", mods = "CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },
        { key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
        { key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
        { key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.DecreaseFontSize },
    },
}
