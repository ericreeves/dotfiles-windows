
local wezterm = require("wezterm")

local M = {}
local custom = {}

custom = wezterm.color.get_builtin_schemes()["catppuccin-mocha"]
custom.background = "#ffffff"
-- custom.tab_bar.background = "#040404"
-- custom.tab_bar.inactive_tab.bg_color = "#0f0f0f"
-- custom.tab_bar.new_tab.bg_color = "#080808"

function M.options(config)
	config.status_update_interval = 1000

	config.color_schemes = {
		['custom'] = custom
	}
	config.color_scheme = "custom"
	-- config.color_scheme = "catppuccin-mocha"

	config.animation_fps = 60
	config.max_fps = 60

	config.initial_cols = 115
	config.initial_rows = 28
	config.font = wezterm.font({
		family = "JetBrainsMono Nerd Font",
		weight = "Regular",
		stretch = "Normal",
		style = "Normal",
		harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
		-- scale = 1.0
	})
	config.font_size = 11
	config.window_decorations = "RESIZE"
	-- config.text_background_opacity = 1.5
	-- config.window_background_opacity = 1.5
	config.window_frame = {
		border_left_width = "10px",
		border_right_width = "10px",
		border_bottom_height = "10px",
		border_top_height = "10px",
		-- border_left_color = M.colors.background,
		-- border_right_color = M.colors.background,
		-- border_bottom_color = M.colors.background,
	  -- border_top_color = M.colors.background,
		-- font_size = 16,
	}
	config.enable_scroll_bar = false
	config.default_cursor_style = "BlinkingBar"
	config.cursor_blink_rate = 333
	config.inactive_pane_hsb = { saturation = 0.5, brightness = 1.0 }
	config.window_padding = { left = "0px", right = "0px", top = 0, bottom = 0 }

	----- Misc
	-- config.warn_about_missing_glyphs = false
	-- config.adjust_window_size_when_changing_font_size = false
	-- config.audible_bell = "Disabled"
	-- config.exit_behavior = "Close"
	-- config.window_close_confirmation = "NeverPrompt"
	-- config.scrollback_lines = 50000
	-- config.tab_max_width = 9999
	-- config.hide_tab_bar_if_only_one_tab = false
	-- config.tab_bar_at_bottom = false
	-- config.use_fancy_tab_bar = false
	-- config.show_new_tab_button_in_tab_bar = false
	-- config.allow_win32_input_mode = true
	-- config.disable_default_key_bindings = true
	-- config.quit_when_all_windows_are_closed = false
end
	-- config.selection_word_boundary = "{}[]()\"'`.,;:="

return M
