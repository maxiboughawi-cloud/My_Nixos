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
	disable_splash_rendering = true,
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

-- Fenster mit Maus verschieben und skalieren
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- Fenstergroesse mit mainMod + CTRL + Pfeiltasten
local resizeOpts = { repeating = true }

hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -40, y = 0,   relative = true }), resizeOpts)
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 40,  y = 0,   relative = true }), resizeOpts)
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -40, relative = true }), resizeOpts)
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }), resizeOpts)



-- Screenshots: grim schiesst, slurp waehlt aus, satty editiert.
-- Bewusst nicht hyprshot -- grim/slurp sind die stabilen Referenztools.
local screenshotDir = os.getenv("HOME") .. "/Pictures/Screenshots"

-- Region auswaehlen, dann Editor zum Annotieren
hl.bind("Print", hl.dsp.exec_cmd(
    'grim -g "$(slurp)" - | satty --filename - '
    .. '--output-filename ' .. screenshotDir .. '/$(date +%Y%m%d-%H%M%S).png '
    .. '--early-exit --copy-command wl-copy'
))

-- Region direkt in die Zwischenablage, ohne Editor
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- Aktueller Monitor komplett in die Zwischenablage
hl.bind("CTRL + Print", hl.dsp.exec_cmd(
    'grim -o "$(hyprctl activeworkspace -j | jq -r .monitor)" - | wl-copy'
))


------------------
---- WALLPAPER ----
------------------
-- swaybg statt hyprpaper: kein Splash-Text, kein IPC-Gebastel,
-- pro Monitor ein eigener Prozess.
hl.on("hyprland.start", function()
    hl.exec_cmd("swaybg -o HDMI-A-1 -i /home/max/nix-config/wallpapers/black.jpg -m fill")
    hl.exec_cmd("swaybg -o DP-1 -i /home/max/nix-config/wallpapers/wall.jpg -m fill")
end)
