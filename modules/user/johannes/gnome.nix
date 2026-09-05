{
  lib,
  osConfig,
  ...
}:
{
  dconf.settings = lib.mkIf osConfig.services.desktopManager.gnome.enable {
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "eu"
        ])
      ];
      xkb-options = "";
    };

    "org/gnome/desktop/interface" = {
      accent-color = "green";
      clock-show-seconds = true;
      gtk-enable-primary-paste = true;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-schedule-automatic = true;
    };

    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-enabled = false;
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gnome/Console" = {
      transparency = true;
    };
  };
}
