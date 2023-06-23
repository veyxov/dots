local wezterm = require("wezterm")
local act = wezterm.action

wezterm.on("update-right-status", function(window)
	window:set_right_status(wezterm.format({
		{ Text = wezterm.strftime(" %A, %d %b %I:%M ") },
	}))
end)

-- The set of schemes that we like and want to put in our rotation
local schemes = {}
for name, scheme in pairs(wezterm.get_builtin_color_schemes()) do
	table.insert(schemes, name)
end

function set_random_color(window)
	-- Pick a random scheme name
	local scheme = schemes[math.random(#schemes)]

	window:set_config_overrides({
		color_scheme = scheme,
	})

	local current_color_name = window:get_config_overrides().color_scheme
	wezterm.background_child_process({ "/usr/local/bin/herbe", current_color_name })
end

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("toggle-color", function(window, pane)
	set_random_color(window)
end)

local function font(opts)
  return wezterm.font_with_fallback({
    opts,
    "Symbols Nerd Font Mono",
  })
end

return {
	color_scheme = "nord",
	inactive_pane_hsb = {
		saturation = 0,
		brightness = 0.25,
	},
	disable_default_key_bindings = true,
	window_background_opacity = 0.95,
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

	leader = { key = "F1", mods = "CTRL", timeout_milliseconds = 1000 },
	default_prog = { "/usr/bin/zsh" },
	font_size = 20,
	keys = {
		{ mods = "ALT|CTRL", key = "/", action = act.MoveTabRelative(1) },
		{ mods = "ALT", key = "/", action = act.MoveTabRelative(-1) },
		{ mods = "ALT", key = "d", action = wezterm.action.ShowDebugOverlay },
		{
			key = "f",
			mods = "ALT",
			action = wezterm.action({
				Search = { CaseInSensitiveString = "" },
			}),
		},
		{ key = "a", mods = "ALT", action = wezterm.action.ShowLauncher },
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
			key = "j",
			mods = "ALT",
			action = wezterm.action.EmitEvent("toggle-color"),
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

		{ key = "r", mods = "CTRL|ALT", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "s", mods = "CTRL|ALT", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "n", mods = "CTRL|ALT", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "d", mods = "CTRL|ALT", action = wezterm.action({ ActivateTab = 3 }) },

		{ key = "LeftArrow", mods = "CTRL|ALT", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ key = "RightArrow", mods = "CTRL|ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "y", mods = "ALT", action = wezterm.action.QuickSelect },
		{ key = "v", mods = "ALT", action = wezterm.action.ActivateCopyMode },
		{ key = "c", mods = "CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
		{ key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.DecreaseFontSize },
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
			{
				key = "Enter",
				mods = "NONE",
				action = act.CopyMode("MoveToStartOfNextLine"),
			},
			{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
			{
				key = "$",
				mods = "NONE",
				action = act.CopyMode("MoveToEndOfLineContent"),
			},
			{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
			{
				key = "0",
				mods = "NONE",
				action = act.CopyMode("MoveToStartOfLine"),
			},
			{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
			{
				key = "F",
				mods = "NONE",
				action = act.CopyMode({ JumpBackward = { prev_char = false } }),
			},
			{
				key = "O",
				mods = "NONE",
				action = act.CopyMode("MoveToSelectionOtherEndHoriz"),
			},
			{
				key = "T",
				mods = "NONE",
				action = act.CopyMode({ JumpBackward = { prev_char = true } }),
			},
			{
				key = "V",
				mods = "NONE",
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
				key = "e",
				mods = "NONE",
				action = act.CopyMode("MoveForwardSemanticZone"),
			},
			{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
			{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
			{
				key = "f",
				mods = "NONE",
				action = act.CopyMode({ JumpForward = { prev_char = false } }),
			},
			{ key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
			{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
			{
				key = "g",
				mods = "NONE",
				action = act.CopyMode("MoveToScrollbackTop"),
			},
			{ key = "g", mods = "CTRL", action = act.CopyMode("Close") },
			{
				key = "m",
				mods = "ALT",
				action = act.CopyMode("MoveToStartOfLineContent"),
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

			{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },

			{
				key = "y",
				mods = "NONE",
				action = act.Multiple({
					{ CopyTo = "ClipboardAndPrimarySelection" },
					{ CopyMode = "Close" },
				}),
			},

			{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
			{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
			{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
		},
	},
}
