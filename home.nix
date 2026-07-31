{ config, pkgs, ... }:

{
  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "26.05";

  
  programs.ghostty = {
    enable = true;
    settings = {
      "font-family" = "JetBrainsMono Nerd Font";
      "font-size" = 14;
      "theme" = "TokyoNight Night";
      "background-blur" = true;
      "background-opacity" = 0.5;
      "window-padding-x" = 10;
      "window-padding-y" = 10;
      "window-decoration" = false;
      "cursor-style" = "block";
      "mouse-hide-while-typing" = true;
      "confirm-close-surface" = false;
      "scrollback-limit" = 50000000;
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    themeFile = "tokyo_night_night";
    settings = {
      background_opacity = "0.85";
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
