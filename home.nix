{ config, pkgs, ... }:

{
  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "26.05";

  programs.ghostty.enable = true;
  programs.rofi.enable = true;

  # Polkit-Agent: ohne den koennen GUI-Programme nicht
  # nach dem Passwort fragen (z.B. Datentraeger einhaengen).
  services.hyprpolkitagent.enable = true;

  # Benachrichtigungs-Daemon
  services.mako.enable = true;

  # hyprpaper 0.8.x hat das IPC- und Configformat geaendert,
  # HMs settings-Generator schreibt noch das alte (preload=).
  # Deshalb nur das Paket, Wallpaper wird aus hyprland.lua gesetzt.
  services.hyprpaper.enable = true;
  home.packages = [ pkgs.hyprpaper ];  

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.main = {
      layer = "top";
      position = "top";
      height = 32;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "tray" ];

      "hyprland/workspaces" = {
        format = "{id}";
        on-click = "activate";
      };

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%A, %d. %B %Y}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      pulseaudio = {
        format = "VOL {volume}%";
        format-muted = "stumm";
        on-click = "pavucontrol";
      };

      network = {
        format-wifi = "{essid}";
        format-ethernet = "LAN";
        format-disconnected = "offline";
        on-click = "nm-connection-editor";
      };

      tray.spacing = 8;
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }
      #workspaces button {
        padding: 0 10px;
        color: #6c7086;
        background: transparent;
        border: none;
      }
      #workspaces button.active {
        color: #89b4fa;
        border-bottom: 2px solid #89b4fa;
      }
      #clock, #pulseaudio, #network, #tray {
        padding: 0 12px;
      }
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "lua";
    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
