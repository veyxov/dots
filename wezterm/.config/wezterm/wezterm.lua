local wezterm = require("wezterm")
local act = wezterm.action

function create_tab_navigation_mappings(mappings)
    local keys = {"u", "o", "y", "k"}

    for index, key in ipairs(keys) do
        table.insert(mappings, {
            key = key,
            mods = "LEADER",
            action = act.ActivateTab(index - 1),
        })
    end

    return mappings
end

function create_pane_navigation_mappings(mappings)
    local directions = {
        { key = "e", direction = "Down" },
        { key = "i", direction = "Up" },
        { key = "a", direction = "Left" },
        { key = "h", direction = "Right" },
    }

    for _, mapping in ipairs(directions) do
        table.insert(mappings, {
            key = mapping.key,
            mods = "LEADER",
            action = act({ ActivatePaneDirection = mapping.direction }),
        })
    end

    return mappings
end

function create_split_pane_mappings(mappings)
    local splits = {
        { key = [[,]], direction = "Right" },
        { key = [[-]], direction = "Up" },
    }

    for _, split in ipairs(splits) do
        table.insert(mappings, {
            mods = "ALT",
            key = split.key,
            action = act.SplitPane({
                direction = split.direction,
                size = { Percent = 50 },
            }),
        })
    end

    return mappings
end

local mappings = {
    {
        key = "t",
        mods = "LEADER",
        action = act.ShowTabNavigator,
    },
    {
        key = "F5",
        mods = "LEADER",
        action = act.SendKey({
            key = "l",
            mods = "CTRL",
        }),
    },
    {
        key = "w",
        mods = "LEADER",
        action = act.ShowLauncherArgs({
            flags = "FUZZY|WORKSPACES",
        }),
    },
    {
        key = "p",
        mods = "LEADER",
        action = act.ActivateCommandPalette,
    },
    {
        key = "n",
        mods = "ALT",
        action = act({ SpawnTab = "CurrentPaneDomain" }),
    },
    {
        key = "_",
        mods = "LEADER|SHIFT",
        action = act({ CloseCurrentPane = { confirm = false } }),
    },
    {
        key = "z",
        mods = "ALT",
        action = act.TogglePaneZoomState,
    },
    {
        key = "a",
        mods = "ALT",
        action = act({ ActivateTabRelative = -1 }),
    },
    {
        key = "h",
        mods = "ALT",
        action = act({ ActivateTabRelative = 1 }),
    },
    {
        key = "y",
        mods = "ALT",
        action = act.QuickSelect,
    },
    {
        key = "s",
        mods = "LEADER",
        action = act.ActivateCopyMode,
    },
    {
        key = "/",
        mods = "LEADER",
        action = act.Search("CurrentSelectionOrEmptyString"),
    },
    {
        key = "c",
        mods = "CTRL",
        action = act({ CopyTo = "Clipboard" }),
    },
    {
        key = "v",
        mods = "CTRL",
        action = act({ PasteFrom = "Clipboard" }),
    },
    -- font
    {
        key = "Slash",
        mods = "ALT",
        action = act.IncreaseFontSize,
    },
    {
        key = "?",
        mods = "ALT|SHIFT",
        action = act.DecreaseFontSize,
    },
    -- navigation
    {
        key = "p",
        mods = "ALT",
        action = act.PaneSelect({
            alphabet = 'aeihrsnd',
        }),
    },
}

create_pane_navigation_mappings(mappings)
create_tab_navigation_mappings(mappings)
create_split_pane_mappings(mappings)

return {
    -- cosmetic settings
    use_resize_increments = true,
    enable_tab_bar = false,
    font_size = 24,
    color_scheme = "tokyonight_night",
    window_background_opacity = 0.7,

    default_prog = { "/usr/bin/fish" },
    quick_select_alphabet = "neiosart",
    window_close_confirmation = "NeverPrompt",

    leader = { key = "F5", mods = "", timeout_milliseconds = 1000 },

    disable_default_key_bindings = true,
    mouse_bindings = {
        {
            event = { Down = { streak = 3, button = 'Left' } },
            action = act.SelectTextAtMouseCursor 'SemanticZone',
            mods = 'NONE',
        },
    },

    keys = mappings,
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
