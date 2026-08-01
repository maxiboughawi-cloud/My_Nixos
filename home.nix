{ config, pkgs, ... }:

{
  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "26.05";

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 17;
    };
    themeFile = "tokyo_night_night";
    settings = {
      background_opacity = "0.65";
      window_padding_width = 10;
      confirm_os_window_close = 0;
    };
  };

  home.sessionVariables = {
    SSH_ASKPASS = "";
    GIT_ASKPASS = "";
  };


  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 12";
    terminal = "${pkgs.kitty}/bin/kitty";

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      display-drun = "";
      display-run = "";
      display-window = "";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#1a1b26";
        bg-alt = mkLiteral "#24283b";
        fg = mkLiteral "#a9b1d6";
        accent = mkLiteral "#7aa2f7";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
      };

      "window" = {
        background-color = mkLiteral "@bg";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
        border-radius = mkLiteral "10px";
        width = mkLiteral "600px";
        padding = mkLiteral "16px";
      };

      "inputbar" = {
        background-color = mkLiteral "@bg-alt";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "10px";
        spacing = mkLiteral "10px";
        children = map mkLiteral [ "prompt" "entry" ];
      };

      "prompt" = {
        text-color = mkLiteral "@accent";
      };

      "listview" = {
        lines = 8;
        columns = 1;
        spacing = mkLiteral "4px";
        padding = mkLiteral "12px 0px 0px 0px";
      };

      "element" = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "6px";
        spacing = mkLiteral "10px";
      };

      "element selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@bg";
      };

      "element-icon" = {
        size = mkLiteral "22px";
      };
    };
  };

  # Polkit-Agent: ohne den koennen GUI-Programme nicht
  # nach dem Passwort fragen (z.B. Datentraeger einhaengen).
  services.hyprpolkitagent.enable = true;

  # Benachrichtigungs-Daemon
  services.mako.enable = true;

  # hyprpaper 0.8.x hat das IPC- und Configformat geaendert,
  # HMs settings-Generator schreibt noch das alte (preload=).
  # Deshalb nur das Paket, Wallpaper wird aus hyprland.lua gesetzt.
  home.packages = [ pkgs.swaybg ];
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
