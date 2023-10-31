local wezterm = require("wezterm")
local act = wezterm.action

return {
    -- cosmetic settings
    use_resize_increments = true,
    enable_tab_bar = false,
    font_size = 24,
    color_scheme = "Dracula",
    window_background_opacity = 0.95,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    default_prog = { "/usr/bin/fish" },
    quick_select_alphabet = "neiosart",
    unix_domains = {
        {
            name = "unix",
        },
    },
    window_close_confirmation = "NeverPrompt",

    leader = { key = "F5", mods = "", timeout_milliseconds = 1000 },

    disable_default_key_bindings = true,
    keys = {
        {
            key = "t",
            mods = "LEADER",
            action = wezterm.action.ShowTabNavigator,
        },
        {
            key = "u",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(0),
        },
        {
            key = "o",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(1),
        },
        {
            key = "y",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(2),
        },
        {
            key = "k",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(3),
        },
        {
            key = "F5",
            mods = "LEADER",
            action = wezterm.action.SendKey({
                key = "l",
                mods = "CTRL",
            }),
        },
        {
            key = "w",
            mods = "LEADER",
            action = wezterm.action.ShowLauncherArgs({
                flags = "FUZZY|WORKSPACES",
            }),
        },
        {
            key = "p",
            mods = "LEADER",
            action = wezterm.action.ActivateCommandPalette,
        },
        { mods = "ALT|CTRL", key = "/", action = act.MoveTabRelative(1) },
        { mods = "ALT", key = "/", action = act.MoveTabRelative(-1) },
        {
            mods = "ALT",
            key = "d",
            action = wezterm.action.ShowDebugOverlay,
        },
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
            key = [[,]],
            action = wezterm.action.SplitPane({
                direction = "Right",
                size = { Percent = 50 },
            }),
        },
        {
            mods = "ALT",
            key = [[-]],
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
            key = "_",
            mods = "LEADER|SHIFT",
            action = wezterm.action({ CloseCurrentPane = { confirm = true } }),
        },
        {
            key = "z",
            mods = "ALT",
            action = wezterm.action.TogglePaneZoomState,
        },
        {
            key = "a",
            mods = "ALT",
            action = wezterm.action({ ActivateTabRelative = -1 }),
        },
        {
            key = "h",
            mods = "ALT",
            action = wezterm.action({ ActivateTabRelative = 1 }),
        },
        {
            key = "y",
            mods = "ALT",
            action = wezterm.action.QuickSelect,
        },
        {
            key = "s",
            mods = "LEADER",
            action = wezterm.action.ActivateCopyMode,
        },
        {
            key = "/",
            mods = "LEADER",
            action = wezterm.action.Search("CurrentSelectionOrEmptyString"),
        },
        {
            key = "c",
            mods = "CTRL",
            action = wezterm.action({ CopyTo = "Clipboard" }),
        },
        {
            key = "v",
            mods = "CTRL",
            action = wezterm.action({ PasteFrom = "Clipboard" }),
        },
        {
            key = "e",
            mods = "ALT",
            action = wezterm.action({ ActivatePaneDirection = "Down" }),
        },
        {
            key = "i",
            mods = "ALT",
            action = wezterm.action({ ActivatePaneDirection = "Up" }),
        },
        {
            key = "e",
            mods = "LEADER",
            action = wezterm.action({ ActivatePaneDirection = "Down" }),
        },
        {
            key = "i",
            mods = "LEADER",
            action = wezterm.action({ ActivatePaneDirection = "Up" }),
        },
        {
            key = "a",
            mods = "LEADER",
            action = wezterm.action({ ActivatePaneDirection = "Left" }),
        },
        {
            key = "h",
            mods = "LEADER",
            action = wezterm.action({ ActivatePaneDirection = "Right" }),
        },
        {
            key = "Slash",
            mods = "ALT",
            action = wezterm.action.IncreaseFontSize,
        },
        {
            key = "?",
            mods = "ALT|SHIFT",
            action = wezterm.action.DecreaseFontSize,
        },
        {
            key = "p",
            mods = "ALT",
            action = act.PaneSelect({
                alphabet = '"asnd',
            }),
        },
    },
    key_tables = {
        search_mode = {
            {
                key = "Enter",
                mods = "NONE",
                action = act.CopyMode("PriorMatch"),
            },
            { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
            { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
            { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
            {
                key = "r",
                mods = "CTRL",
                action = act.CopyMode("CycleMatchType"),
            },
            {
                key = "Backspace",
                mods = "CTRL",
                action = act.CopyMode("ClearPattern"),
            },
            {
                key = "PageUp",
                mods = "NONE",
                action = act.CopyMode("PriorMatchPage"),
            },
            {
                key = "PageDown",
                mods = "NONE",
                action = act.CopyMode("NextMatchPage"),
            },
            {
                key = "UpArrow",
                mods = "NONE",
                action = act.CopyMode("PriorMatch"),
            },
            {
                key = "DownArrow",
                mods = "NONE",
                action = act.CopyMode("NextMatch"),
            },
        },
        copy_mode = {
            {
                key = "Enter",
                mods = "NONE",
                action = act.CopyMode("MoveToStartOfNextLine"),
            },
            { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
            {
                key = "Space",
                mods = "NONE",
                action = act.CopyMode({ SetSelectionMode = "Cell" }),
            },
            {
                key = "$",
                mods = "NONE",
                action = act.CopyMode("MoveToEndOfLineContent"),
            },
            {
                key = "$",
                mods = "SHIFT",
                action = act.CopyMode("MoveToEndOfLineContent"),
            },
            {
                key = ",",
                mods = "NONE",
                action = act.CopyMode("JumpReverse"),
            },
            {
                key = "0",
                mods = "NONE",
                action = act.CopyMode("MoveToStartOfLine"),
            },
            {
                key = ";",
                mods = "NONE",
                action = act.CopyMode("JumpAgain"),
            },
            {
                key = "F",
                mods = "NONE",
                action = act.CopyMode({ JumpBackward = { prev_char = false } }),
            },
            {
                key = "F",
                mods = "SHIFT",
                action = act.CopyMode({ JumpBackward = { prev_char = false } }),
            },
            {
                key = "G",
                mods = "NONE",
                action = act.CopyMode("MoveToScrollbackBottom"),
            },
            {
                key = "G",
                mods = "SHIFT",
                action = act.CopyMode("MoveToScrollbackBottom"),
            },
            {
                key = "H",
                mods = "NONE",
                action = act.CopyMode("MoveToViewportTop"),
            },
            {
                key = "H",
                mods = "SHIFT",
                action = act.CopyMode("MoveToViewportTop"),
            },
            {
                key = "L",
                mods = "NONE",
                action = act.CopyMode("MoveToViewportBottom"),
            },
            {
                key = "L",
                mods = "SHIFT",
                action = act.CopyMode("MoveToViewportBottom"),
            },
            {
                key = "M",
                mods = "NONE",
                action = act.CopyMode("MoveToViewportMiddle"),
            },
            {
                key = "M",
                mods = "SHIFT",
                action = act.CopyMode("MoveToViewportMiddle"),
            },
            {
                key = "O",
                mods = "NONE",
                action = act.CopyMode("MoveToSelectionOtherEndHoriz"),
            },
            {
                key = "O",
                mods = "SHIFT",
                action = act.CopyMode("MoveToSelectionOtherEndHoriz"),
            },
            {
                key = "T",
                mods = "NONE",
                action = act.CopyMode({ JumpBackward = { prev_char = true } }),
            },
            {
                key = "T",
                mods = "SHIFT",
                action = act.CopyMode({ JumpBackward = { prev_char = true } }),
            },
            {
                key = "V",
                mods = "NONE",
                action = act.CopyMode({ SetSelectionMode = "Line" }),
            },
            {
                key = "V",
                mods = "SHIFT",
                action = act.CopyMode({ SetSelectionMode = "Line" }),
            },
            {
                key = "^",
                mods = "NONE",
                action = act.CopyMode("MoveToStartOfLineContent"),
            },
            {
                key = "^",
                mods = "SHIFT",
                action = act.CopyMode("MoveToStartOfLineContent"),
            },
            {
                key = "b",
                mods = "NONE",
                action = act.CopyMode("MoveBackwardWord"),
            },
            { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
            {
                key = "d",
                mods = "CTRL",
                action = act.CopyMode({ MoveByPage = 0.5 }),
            },
            {
                key = "e",
                mods = "NONE",
                action = act.CopyMode("MoveForwardWordEnd"),
            },
            {
                key = "f",
                mods = "NONE",
                action = act.CopyMode({ JumpForward = { prev_char = false } }),
            },
            {
                key = "g",
                mods = "NONE",
                action = act.CopyMode("MoveToScrollbackTop"),
            },
            {
                key = "o",
                mods = "NONE",
                action = act.CopyMode("MoveToSelectionOtherEnd"),
            },
            { key = "q", mods = "NONE", action = act.CopyMode("Close") },
            {
                key = "t",
                mods = "NONE",
                action = act.CopyMode({ JumpForward = { prev_char = true } }),
            },
            {
                key = "v",
                mods = "NONE",
                action = act.CopyMode({ SetSelectionMode = "Cell" }),
            },
            {
                key = "v",
                mods = "CTRL",
                action = act.CopyMode({ SetSelectionMode = "Block" }),
            },
            {
                key = "w",
                mods = "NONE",
                action = act.CopyMode("MoveForwardWord"),
            },
            {
                key = "y",
                mods = "NONE",
                action = act.Multiple({
                    { CopyTo = "ClipboardAndPrimarySelection" },
                    { CopyMode = "Close" },
                }),
            },
            {
                key = "PageUp",
                mods = "NONE",
                action = act.CopyMode("PageUp"),
            },
            {
                key = "PageDown",
                mods = "NONE",
                action = act.CopyMode("PageDown"),
            },
            {
                key = "LeftArrow",
                mods = "NONE",
                action = act.CopyMode("MoveLeft"),
            },
            {
                key = "RightArrow",
                mods = "NONE",
                action = act.CopyMode("MoveRight"),
            },
            {
                key = "UpArrow",
                mods = "NONE",
                action = act.CopyMode("MoveUp"),
            },
            {
                key = "DownArrow",
                mods = "NONE",
                action = act.CopyMode("MoveDown"),
            },
        },
    },
}
