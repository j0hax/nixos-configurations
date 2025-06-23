{ lib, pkgs, ... }:
{
  programs = {
    foot = {
      enable = true;

      settings = {
        main = {
          font = "monospace:size=10";
          dpi-aware = true;
          pad = "6x6 center";
        };
        colors = {
          alpha = 0.5;
        };
      };
    };

    tofi.enable = true;

    waybar.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    # Set to null, as installed as NixOS Module
    package = null;
    portalPackage = null;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = lib.getExe pkgs.foot;
      "$menu" = "${pkgs.tofi}/bin/tofi-drun --drun-launch=true";

      "monitor" = ",highrr,auto,auto";

      "exec-once" = lib.getExe pkgs.waybar;

      decoration = {
        rounding = 10;
        rounding_power = 2;

        shadow = {
          enabled = true;
        };
      };

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bind =
        [
          ", Print, exec, grimblast copy area"
          "$mod, RETURN, exec, $terminal"
          "$mod SHIFT, Q, exit"
          "$mod, D, exec, $menu"
          "$mod, F, fullscreen"
          "$mod, J, togglesplit"
          "$mod, P, pseudo"
          "$mod, SPACE, togglefloating"
          "$mod SHIFT, P, exec, ${lib.getExe pkgs.grim} -g $(${lib.getExe pkgs.slurp})"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );

      bindl = [
        ", switch:on:Lid Switch, exec, hyprctl keyword monitor eDP-1, disable"
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor eDP-1, enable"
      ];
    };
  };

  services.hyprpaper = {
    #enable = true;
    settings = {
      ipc = "on";
      preload = [ "~/B1/nixos-b1-artwork/nix-wallpaper-nineish-b1.png" ];
      wallpaper = [
        ", ~/B1/nixos-b1-artwork/nix-wallpaper-nineish-b1.png"
      ];
    };
  };
}
