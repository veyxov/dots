local wezterm = require("wezterm")

wezterm.on("update-right-status", function(window)
    window:set_right_status(wezterm.format({
        { Text = wezterm.strftime(" %A, %d %b %I:%M ") },
    }))
end)

return {
    disable_default_key_bindings = true,
    adjust_window_size_when_changing_font_size = true,
    window_background_opacity = 0.85,
    tab_bar_at_bottom = true,
    quick_select_alphabet="neiosart",
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    front_end = "WebGpu",
    color_scheme = "Argonaut",
    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = false,
    window_close_confirmation = 'NeverPrompt',
    font = wezterm.font_with_fallback({
        "Noto Color emoji",
    }),
    leader = { key = 'F1', mods = 'CTRL', timeout_milliseconds = 1000 },
    default_prog = { '/usr/bin/fish' },
    font_size = 20,
    keys = {
        { key = 'a', mods = 'ALT', action = wezterm.action.ShowLauncher },
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
        { key = "n", mods = "ALT", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
        { key = "q", mods = "ALT", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
        { key = "z", mods = "ALT", action = wezterm.action.TogglePaneZoomState },

        { key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
        { key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
        { key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
        { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },

        { key = "DownArrow", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
        { key = "UpArrow", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
        { key = "LeftArrow", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
        { key = "RightArrow", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

        { key = "LeftArrow", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = -1 }) },
        { key = "RightArrow", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },

        { key = "y", mods = "ALT", action = wezterm.action.QuickSelect },
        { key = "v", mods = "ALT", action = wezterm.action.ActivateCopyMode },
        { key = "c", mods = "CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },
        { key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },

        { key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
        { key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.DecreaseFontSize },

        { key = "s", mods = "CTRL", action = wezterm.action.SpawnCommandInNewTab {
            args = { "lazygit" }
        } },
    },
}
