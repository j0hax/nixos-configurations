{
  lib,
  pkgs,
  ...
}:
{
  programs = {
    fish = {
      enable = true;
      functions.fish_greeting = ''
        ${lib.getExe pkgs.fortune-kind}
      '';
    };

    starship = {
      enable = true;
      settings = {
        line_break.disabled = true;
        time = {
          disabled = false;
          format = "[\\[$time\\]]($style)";
          time_format = "%R";
        };
        right_format = "$time";
      };
    };
  };
}
