-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

hl.monitor({
    output = "DP-2",
    mode = "preferred",
    position = "auto-left",
    scale = 1,
    transform = 3
})

local mainMod = "ALT"
local terminal = "ghostty"
local fileManager = "dolphin"
local menu = "wmenu-run -f \"Meslo 11\""

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & ~/.config/hypr/random_wallpaper.sh & hyprpaper")
    hl.exec_cmd("dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE")
end)

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons
-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 2,
        border_size = 1,
        ["col.active_border"] = "rgba(00ff9955)",
        ["col.inactive_border"] = "rgba(595959aa)",
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 5,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
    input = {
        kb_layout = "us,dk",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:win_space_toggle",
        kb_rules = "",
        repeat_rate = 75,
        repeat_delay = 200,
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },
    cursor = {
        no_hardware_cursors = true,
        use_cpu_buffer = true,
    },
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.animation({ leaf = "global", enabled = true, speed = 2, bezier = "quick" })

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.scripts/bin/passmenu"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + DELETE", hl.dsp.exec_cmd("poweroff"))
hl.bind(mainMod .. " + CONTROL + DELETE", hl.dsp.exec_cmd("systemctl suspend"))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + SHIFT + PAGE_DOWN", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind(mainMod .. " + SHIFT + PAGE_UP", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/random_wallpaper.sh & hyprpaper"))
