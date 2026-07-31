{ config, pkgs, ... }:

{
  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "26.05";

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 15;
    };
    themeFile = "tokyo_night_night";
    settings = {
      background_opacity = "0.65";
      window_padding_width = 10;
      confirm_os_window_close = 0;
    };
  };


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

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

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
        background: rgba(26, 27, 38, 0.85);
        color: #a9b1d6;
      }
      #workspaces button {
        padding: 0 10px;
        color: #565f89;
        background: transparent;
        border: none;
      }
      #workspaces button.active {
        color: #7aa2f7;
        border-bottom: 2px solid #7aa2f7;
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
