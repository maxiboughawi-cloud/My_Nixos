-- Hyprland-Konfiguration, ausgeliefert via Home Manager.
-- Bearbeiten in ~/nix-config/hyprland.lua, danach nixos-rebuild switch.

local mainMod  = "SUPER"
local terminal = "ghostty"
local menu     = "rofi -show drun"

------------------
---- MONITORS ----
------------------
-- Auto-Erkennung. Sobald der zweite Monitor dranhaengt,
-- wird daraus ein zweiter hl.monitor()-Aufruf mit festem output.
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
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,
        layout      = "dwindle",
    },
    decoration = {
        rounding = 10,
    },
    animations = {
        enabled = true,
    },
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

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
