{ config, pkgs, ... }:

{
  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "26.05";

  programs.ghostty.enable = true;
  programs.rofi.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Lua statt hyprlang. settings wird bewusst NICHT gesetzt --
    # der Nix->Lua-Generator ist derzeit fehlerhaft.
    configType = "lua";
    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
