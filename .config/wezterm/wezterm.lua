local wezterm = require("wezterm")
local act = wezterm.action

local function font(opts)
    return wezterm.font_with_fallback({
        opts,
        "Symbols Nerd Font Mono",
    })
end

return {
    color_scheme = 'Tinacious Design (Dark)',
    inactive_pane_hsb = {
        saturation = 0,
        brightness = 0.25,
    },
    disable_default_key_bindings = true,
    window_background_opacity = 0.9,
    tab_bar_at_bottom = true,
    quick_select_alphabet = "neiosart",
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    unix_domains = {
        {
            name = "unix",
        },
    },
    adjust_window_size_when_changing_font_size = false,

    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = false,
    window_close_confirmation = "NeverPrompt",

    font = font("FiraCode Nerd Font Mono"),
    font_rules = {
        {
            italic = true,
            intensity = "Normal",
            font = font({
                family = "Victor Mono",
                style = "Italic",
            }),
        },
        {
            italic = true,
            intensity = "Half",
            font = font({
                family = "Victor Mono",
                weight = "DemiBold",
                style = "Italic",
            }),
        },
        {
            italic = true,
            intensity = "Bold",
            font = font({
                family = "Victor Mono",
                weight = "Bold",
                style = "Italic",
            }),
        },
    },

    leader = { key = "F1", mods = "", timeout_milliseconds = 1000 },
    default_prog = { "/usr/bin/zsh" },
    font_size = 20,
    keys = {
        { mods = "ALT|CTRL", key = "/", action = act.MoveTabRelative(1) },
        { mods = "ALT",      key = "/", action = act.MoveTabRelative(-1) },
        { mods = "ALT",      key = "d", action = wezterm.action.ShowDebugOverlay },
        {
            key = "f",
            mods = "ALT",
            action = wezterm.action({
                Search = { CaseInSensitiveString = "" },
            }),
        },
        { key = "l",          mods = "ALT",        action = wezterm.action.ShowLauncher },
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
            key = "j",
            mods = "ALT",
            action = wezterm.action.EmitEvent("toggle-color"),
        },
        { key = "n",          mods = "ALT",        action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
        { key = "_",          mods = "ALT|SHIFT",        action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
        { key = "z",          mods = "ALT",        action = wezterm.action.TogglePaneZoomState },
        { key = "a",          mods = "ALT",        action = wezterm.action({ ActivateTabRelative = -1 }) },
        { key = "h",          mods = "ALT",        action = wezterm.action({ ActivateTabRelative = 1 }) },
        { key = "y",          mods = "ALT",        action = wezterm.action.QuickSelect },
        { key = "v",          mods = "ALT",        action = wezterm.action.ActivateCopyMode },
        { key = "c",          mods = "CTRL",       action = wezterm.action({ CopyTo = "Clipboard" }) },
        { key = "v",          mods = "CTRL",       action = wezterm.action({ PasteFrom = "Clipboard" }) },
        { key = "e",  mods = "ALT",        action = wezterm.action({ ActivatePaneDirection = "Down" }) },
        { key = "i",  mods = "ALT",        action = wezterm.action({ ActivatePaneDirection = "Up" }) },
        { key = "UpArrow",    mods = "ALT",        action = wezterm.action.IncreaseFontSize },
        { key = "DownArrow",  mods = "ALT",        action = wezterm.action.DecreaseFontSize },
        {
            key = "p",
            mods = "ALT",
            action = act.PaneSelect({
                alphabet = '"asnd',
            }),
        },
    },
    key_tables = {
        copy_mode = {
            { key = 'Tab',    mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
            {
                key = 'Tab',
                mods = 'SHIFT',
                action = act.CopyMode 'MoveBackwardWord',
            },
            {
                key = 'Enter',
                mods = 'NONE',
                action = act.CopyMode 'MoveToStartOfNextLine',
            },
            { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
            {
                key = 'Space',
                mods = 'NONE',
                action = act.CopyMode { SetSelectionMode = 'Cell' },
            },
            {
                key = '$',
                mods = 'NONE',
                action = act.CopyMode 'MoveToEndOfLineContent',
            },
            {
                key = '$',
                mods = 'SHIFT',
                action = act.CopyMode 'MoveToEndOfLineContent',
            },
            { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
            { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
            { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
            {
                key = 'F',
                mods = 'NONE',
                action = act.CopyMode { JumpBackward = { prev_char = false } },
            },
            {
                key = 'F',
                mods = 'SHIFT',
                action = act.CopyMode { JumpBackward = { prev_char = false } },
            },
            {
                key = 'G',
                mods = 'NONE',
                action = act.CopyMode 'MoveToScrollbackBottom',
            },
            {
                key = 'G',
                mods = 'SHIFT',
                action = act.CopyMode 'MoveToScrollbackBottom',
            },
            { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
            {
                key = 'H',
                mods = 'SHIFT',
                action = act.CopyMode 'MoveToViewportTop',
            },
            {
                key = 'L',
                mods = 'NONE',
                action = act.CopyMode 'MoveToViewportBottom',
            },
            {
                key = 'L',
                mods = 'SHIFT',
                action = act.CopyMode 'MoveToViewportBottom',
            },
            {
                key = 'M',
                mods = 'NONE',
                action = act.CopyMode 'MoveToViewportMiddle',
            },
            {
                key = 'M',
                mods = 'SHIFT',
                action = act.CopyMode 'MoveToViewportMiddle',
            },
            {
                key = 'O',
                mods = 'NONE',
                action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
            },
            {
                key = 'O',
                mods = 'SHIFT',
                action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
            },
            {
                key = 'T',
                mods = 'NONE',
                action = act.CopyMode { JumpBackward = { prev_char = true } },
            },
            {
                key = 'T',
                mods = 'SHIFT',
                action = act.CopyMode { JumpBackward = { prev_char = true } },
            },
            {
                key = 'V',
                mods = 'NONE',
                action = act.CopyMode { SetSelectionMode = 'Line' },
            },
            {
                key = 'V',
                mods = 'SHIFT',
                action = act.CopyMode { SetSelectionMode = 'Line' },
            },
            {
                key = '^',
                mods = 'NONE',
                action = act.CopyMode 'MoveToStartOfLineContent',
            },
            {
                key = '^',
                mods = 'SHIFT',
                action = act.CopyMode 'MoveToStartOfLineContent',
            },
            { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
            { key = 'b', mods = 'ALT',  action = act.CopyMode 'MoveBackwardWord' },
            { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
            { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
            {
                key = 'd',
                mods = 'CTRL',
                action = act.CopyMode { MoveByPage = 0.5 },
            },
            {
                key = 'e',
                mods = 'NONE',
                action = act.CopyMode 'MoveForwardWordEnd',
            },
            {
                key = 'f',
                mods = 'NONE',
                action = act.CopyMode { JumpForward = { prev_char = false } },
            },
            { key = 'f', mods = 'ALT',  action = act.CopyMode 'MoveForwardWord' },
            { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
            {
                key = 'g',
                mods = 'NONE',
                action = act.CopyMode 'MoveToScrollbackTop',
            },
            { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
            { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
            { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
            { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
            { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
            {
                key = 'm',
                mods = 'ALT',
                action = act.CopyMode 'MoveToStartOfLineContent',
            },
            {
                key = 'o',
                mods = 'NONE',
                action = act.CopyMode 'MoveToSelectionOtherEnd',
            },
            { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
            {
                key = 't',
                mods = 'NONE',
                action = act.CopyMode { JumpForward = { prev_char = true } },
            },
            {
                key = 'u',
                mods = 'CTRL',
                action = act.CopyMode { MoveByPage = -0.5 },
            },
            {
                key = 'v',
                mods = 'NONE',
                action = act.CopyMode { SetSelectionMode = 'Cell' },
            },
            {
                key = 'v',
                mods = 'CTRL',
                action = act.CopyMode { SetSelectionMode = 'Block' },
            },
            { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
            {
                key = 'y',
                mods = 'NONE',
                action = act.Multiple {
                    { CopyTo = 'ClipboardAndPrimarySelection' },
                    { CopyMode = 'Close' },
                },
            },
            { key = 'PageUp',   mods = 'NONE', action = act.CopyMode 'PageUp' },
            { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
            {
                key = 'End',
                mods = 'NONE',
                action = act.CopyMode 'MoveToEndOfLineContent',
            },
            {
                key = 'Home',
                mods = 'NONE',
                action = act.CopyMode 'MoveToStartOfLine',
            },
            { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
            {
                key = 'LeftArrow',
                mods = 'ALT',
                action = act.CopyMode 'MoveBackwardWord',
            },
            {
                key = 'RightArrow',
                mods = 'NONE',
                action = act.CopyMode 'MoveRight',
            },
            {
                key = 'RightArrow',
                mods = 'ALT',
                action = act.CopyMode 'MoveForwardWord',
            },
            { key = 'UpArrow',   mods = 'NONE', action = act.CopyMode 'MoveUp' },
            { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        },
    },
}
