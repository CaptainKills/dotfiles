-- INFO: Keybinds

local mainMod = "SUPER"

local flatpak = "flatpak run "
local browser = flatpak .. "com.brave.Browser"
local spotify = flatpak .. "com.spotify.Client"
local bitwarden = flatpak .. "com.bitwarden.desktop"
local discord = flatpak .. "com.discordapp.Discord"
local teams = flatpak .. "com.github.IsmaelMartinez.teams_for_linux"

local whatsapp = browser .. " https://web.whatsapp.com"
local notion = browser .. " https://app.notion.com"
local outlook = browser .. " https://outlook.office.com"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + BRACKETLEFT", hl.dsp.workspace.move({ monitor = -1 }))
hl.bind(mainMod .. " + BRACKETRIGHT", hl.dsp.workspace.move({ monitor = 1 }))

-- Keybinds for applications
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("hyprlauncher"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("grim"))

-- Dark Mode / Light Mode
hl.bind(mainMod .. " + TAB", function()
	hl.dispatch(hl.dsp.exec_cmd("hyprctl hyprsunset temperature 6000"))
	hl.dispatch(hl.dsp.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"'))
	hl.dispatch(hl.dsp.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-light"'))
end)

hl.bind(mainMod .. " + SHIFT + TAB", function()
	hl.dispatch(hl.dsp.exec_cmd("hyprctl hyprsunset temperature 1500"))
	hl.dispatch(hl.dsp.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"'))
	hl.dispatch(hl.dsp.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"'))
end)

-- Applications
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(spotify))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(discord))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(whatsapp))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(bitwarden))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notion))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(outlook))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(teams))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

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
