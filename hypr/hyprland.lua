-- INFO: Monitors
-- https://wiki.hypr.land/Configuring/Monitors/

hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@60",
	position = "0x0",
	scale = "1.25",
})

hl.monitor({
	output = "desc:Dell Inc. DELL P2418D MY3ND0120JTT,",
	mode = "2560x1440@60",
	position = "auto-right",
	scale = "1.25",
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

-- INFO: Autostart

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprsunset")

	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")

	hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-light"')
end)

-- INFO: Environment Variables
-- https://wiki.hypr.land/Configuring/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- INFO: Hyprland Config

hl.config({
	-- Variables - General
	-- https://wiki.hypr.land/Configuring/Variables/#general

	general = {
		gaps_in = 5,
		gaps_out = 5,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	-- INFO: Variables - Decoration
	-- https://wiki.hypr.land/Configuring/Variables/#decoration

	decoration = {
		rounding = 10,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		-- https://wiki.hypr.land/Configuring/Variables/#blur
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	-- INFO: Variables - Animations
	-- https://wiki.hypr.land/Configuring/Variables/#animations

	animations = {
		enabled = true,
	},
})

-- INFO: Window Layout
-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more

hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

-- https://wiki.hypr.land/Configuring/Variables/#misc
hl.config({
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
})

-- INFO: Peripherals
-- https://wiki.hypr.land/Configuring/Variables/#input

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
		},
	},
})

-- INFO: Gestures
-- https://wiki.hypr.land/Configuring/Gestures

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- INFO: Keybinds
-- https://wiki.hypr.land/Configuring/Binds/

local mainMod = "ALT"

local flatpak = "flatpak run "
local browser = flatpak .. "com.brave.Browser"
local spotify = flatpak .. "com.spotify.Client"
local bitwarden = flatpak .. "com.bitwarden.desktop"
local discord = flatpak .. "com.discordapp.Discord"
local obsidian = flatpak .. "md.obsidian.Obsidian"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + BRACKETLEFT", hl.dsp.workspace.move({ monitor = -1 }))
hl.bind(mainMod .. " + BRACKETRIGHT", hl.dsp.workspace.move({ monitor = 1 }))

-- Keybinds for applications
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("hyprlauncher"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + J", hl.dsp.layout("hyprlock"))
hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

-- Dark Mode / Light Mode
hl.bind(mainMod .. " + TAB", function()
	hl.dispatch(hl.dsp.exec_cmd("hyprctl hyprsunset temperature 6000"))
	hl.dispatch(hl.dsp.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"'))
end)

hl.bind(mainMod .. " + SHIFT + TAB", function()
	hl.dispatch(hl.dsp.exec_cmd("hyprctl hyprsunset temperature 1500"))
	hl.dispatch(hl.dsp.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"'))
end)

-- Applications
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(spotify))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(discord))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser .. " https://web.whatsapp.com"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(bitwarden))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(obsidian))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(browser .. " https://outlook.office.com"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("teams-for-linux"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- INFO: Workspace Rules
-- https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "monitor:desc:Dell Inc. DELL P2418D MY3ND0120JTT", default = true })
hl.workspace_rule({ workspace = "7", monitor = "monitor:desc:Dell Inc. DELL P2418D MY3ND0120JTT" })
hl.workspace_rule({ workspace = "8", monitor = "monitor:desc:Dell Inc. DELL P2418D MY3ND0120JTT" })
hl.workspace_rule({ workspace = "9", monitor = "monitor:desc:Dell Inc. DELL P2418D MY3ND0120JTT" })
hl.workspace_rule({ workspace = "10", monitor = "monitor:desc:Dell Inc. DELL P2418D MY3ND0120JTT" })

-- INFO: Windows Rules
-- https://wiki.hypr.land/Configuring/Window-Rules/

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Application Window Rules
hl.window_rule({
	name = "spotify-workspace",
	match = { title = ".*Spotify.*" },
	workspace = "2",
})

hl.window_rule({
	name = "whatsapp-workspace",
	match = { title = ".*Untitled.*" },
	workspace = "1",
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})
