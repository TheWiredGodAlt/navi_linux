-- hyprland.lua Configuration

----------------
--- MONITORS ---
----------------

-- See https://wiki.hypr.land/configuring/core/monitors/
hl.monitor({
  output   = "HDMI-A-1",
  mode     = "1366x768@60",
  position = "0x0",
  scale    = 1,
})

--=====Default programs used=====#
local terminal = "kitty"
local fileManager = "nemo"
local appmenu = "wofi --show drun"
local hyprlock = "hyprlock"
local changePaper = "python /home/wiredgod/.config/hypr/scripts/wallpaper.py"
-----------------
--- AUTOSTART ---
-----------------

-- See https://wiki.hypr.land/configuring/core/autostart/
hl.on("hyprland.start", function ()
    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

-- See https://wiki.hypr.land/configuring/core/environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("GDK_BACKEND", "wayland,x11")

----------------------
--- LOOK AND FEEL ---
----------------------

hl.config({
  general = {
    gaps_in     = 5,
    gaps_out    = 12,
    border_size = 0,
    col = {
      active_border   = "rgba(135,206,250,0.800)",
      inactive_border = "rgba(595959aa)",
    },
    resize_on_border = true,
    allow_tearing    = true,
    layout           = "dwindle",
  },
})

hl.config({
  decoration = {
    rounding       = 10,
    rounding_power = 4,

    -- Slightly transparent windows so the blur reads through them,
    -- like Win11's acrylic surfaces in apps.
    active_opacity   = 0.96,
    inactive_opacity = 1,

    shadow = {
      enabled      = true,
      range        = 7,
      render_power = 3,
      color        = "rgba(000000aa)",
    },

    -- FIX 1/3: tuned kawase blur to mimic Windows 11 Acrylic.
    -- There is NO "acrylic" shader variant in Hyprland; the look
    -- comes from: strong blur + visible noise grain + bright lift.
    blur = {
      enabled            = true,
      size               = 8,      -- blur radius (keep modest on 1366x768)
      passes             = 3,      -- more passes = smoother, costlier
      noise              = 0.0,   -- the acrylic "grain"; 0 = glass-smooth
      contrast           = 1.0,    -- >1 punchier, <1 flatter
      brightness         = 0.90,   -- acrylic lifts the background slightly
      vibrancy           = 0.25,   -- saturates blurred colors
      vibrancy_darkness  = 0.0,
      new_optimizations  = true,
      ignore_opacity     = true,   -- blur uses the values above, not window alpha
      popups             = true,
      popups_ignorealpha = 0.2,
    },
  },
})

-- FIX 2/3: layers (waybar, wofi, wallpapers...) are NOT windows,
-- so blur must be enabled per-layer with hl.layer_rule().
-- Old "blurls = ..." was removed from Hyprland years ago and did nothing.
-- Check namespaces anytime with: hyprctl layers
hl.layer_rule({
  name   = "blur-waybar",
  match  = { namespace = "waybar" },
  blur   = true,
  ignore_alpha = 0.40,  -- blur even through semi-opaque CSS pixels
})

hl.layer_rule({
  name   = "blur-wofi",
  match  = { namespace = "wofi" },
  blur   = true,
  ignore_alpha = 0.40,
})

hl.config({
  animations = { enabled = true },
})

hl.curve("overshot",  { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("smoothOut", { type = "bezier", points = { {0.36, 0}, {0.66, -0.56} } })
hl.curve("smoothIn",  { type = "bezier", points = { {0.25, 1}, {0.5, 1} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 4,  bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 10, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4,  bezier = "default" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "smoothIn" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "default", style = "slide" })

--hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
--hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })

hl.config({
  dwindle = { preserve_split = true },
  master  = { new_status = "master" },
  misc = {
    disable_hyprland_logo   = true,
  },
})

------------
--- INPUT ---
------------

hl.config({
  input = {
    kb_layout    = "us,br",
    kb_variant   = "",
    kb_model     = "",
    kb_options   = "grp:alt_shift_toggle",
    kb_rules     = "",
    follow_mouse = 1,
    sensitivity  = 0,
    touchpad = {
      natural_scroll       = true,
      clickfinger_behavior = true,
      scroll_factor        = 0.8,
    },
  },
})

hl.config({
  gestures = {
    workspace_swipe_distance = 300,
    workspace_swipe_invert   = true,
    workspace_swipe_min_speed_to_force = 30,
    workspace_swipe_cancel_ratio       = 0.5,
  },
})

hl.gesture({
  fingers   = 3,
  direction = "horizontal",
  action    = "workspace",
})

hl.device({
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
})

--======Keybinds======#
local mainMod = "SUPER"

-- Basic apps
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(appmenu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(changePaper))

hl.bind(mainMod .. " + SHIFT + CONTROL + Escape", hl.dsp.exit())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())

-- Window control and behavior
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Persistent workspaces
hl.workspace_rule({ workspace = "1", persistent = true })
hl.workspace_rule({ workspace = "2", persistent = true })
hl.workspace_rule({ workspace = "3", persistent = true })
hl.workspace_rule({ workspace = "4", persistent = true })
hl.workspace_rule({ workspace = "5", persistent = true })

-- Locker and Printscreen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('sh -c "grim -g \\"$(slurp)\\" - | wl-copy"'))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("sh -c 'grim - | wl-copy'"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

hl.window_rule({
  name  = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class       = "^$",
    title       = "^$",
    xwayland    = true,
    float       = true,
    fullscreen  = false,
    pin         = false,
  },
  no_focus = true,
})

-- Keep fullscreen content (video, games) fully opaque so the
-- transparency never degrades picture fidelity.
hl.window_rule({
  name  = "fullscreen-opaque",
  match = { fullscreen = true },
  opaque = true,
})

hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move  = "20 monitor_h-120",
  float = true,
})
