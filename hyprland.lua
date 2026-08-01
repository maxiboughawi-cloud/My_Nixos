-- Hyprland-Konfiguration, ausgeliefert via Home Manager.
-- Bearbeiten in ~/nix-config/hyprland.lua, danach nixos-rebuild switch.

local mainMod  = "SUPER"
local terminal = "kitty"
local menu     = "rofi -show drun"





------------------
---- MONITORS ----
------------------
-- Reihenfolge zaehlt: spezifische Regeln zuerst,
-- der leere Fallback ganz zum Schluss.
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "2560x1440@75",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@120",
    position = "2560x0",
    scale    = 1,
})

-- Fallback, damit ein neu angestecktes Display nicht schwarz bleibt.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})




---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout    = "de",
        follow_mouse = 1,
        sensitivity  = 0,
    },
})

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,
        layout      = "dwindle",

        col = {
	    active_border = { colors = {"rgba(d6d9e0ee)"}, angle = 0 },		
            inactive_border = "rgba(414868aa)",
        },
    },
    decoration = {
        rounding = 10,
	blur = {
            enabled           = true,
            size              = 8,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = false,
            noise             = 0.0117,
            contrast          = 0.9,
            brightness        = 0.8,
        },
    }, 
    animations = {
        enabled = true,
    },

})
------------------
---- ANIMATIONS ----
------------------
hl.curve("snappy", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 3,   bezier = "snappy" })
hl.animation({ leaf = "windowsIn", enabled = false })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2,   bezier = "snappy", style = "popin 90%" })
hl.animation({ leaf = "border",     enabled = true, speed = 3,   bezier = "snappy" })
hl.animation({ leaf = "fade",       enabled = true, speed = 2,   bezier = "snappy" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3,   bezier = "snappy", style = "slide" })

---------------------
---- KEYBINDINGS ----
---------------------
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Fokus mit Pfeiltasten
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-9, mit SHIFT Fenster mitnehmen
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,   hl.dsp.window.move({ workspace = i }))
end

-- Fenstergroesse mit mainMod + CTRL + Pfeiltasten
local resizeOpts = { repeating = true }

hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -40, y = 0,   relative = true }), resizeOpts)
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 40,  y = 0,   relative = true }), resizeOpts)
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -40, relative = true }), resizeOpts)
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }), resizeOpts)


------------------
---- WALLPAPER ----
------------------
-- hyprpaper wird per systemd gestartet, das Bild setzen wir hier,
-- weil HMs Config-Generator noch das alte Format schreibt.
hl.on("hyprland.start", function()
    hl.exec_cmd("sleep 1 && hyprctl hyprpaper wallpaper 'HDMI-A-1,/home/max/nix-config/wallpapers/black.jpg'")
    hl.exec_cmd("sleep 1 && hyprctl hyprpaper wallpaper 'DP-1,/home/max/nix-config/wallpapers/wall[<65;147;30M.jpg'")
end)
