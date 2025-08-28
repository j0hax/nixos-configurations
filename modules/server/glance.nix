{ ... }:
let
  port = 5346;
  companyColor = "214 72 47";
  gruvbox = {
    background-color = "0 0 16";
    primary-color = "43 59 81";
    positive-color = "61 66 44";
    negative-color = "6 96 59";
  };
  teal-city = {
    background-color = "255 14 15";
    primary-color = "157 47 65";
    contrast-multiplier = 1.1;
  };
in
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."dash.jka.one" = {
    serverAliases = [ "start.jka.one" ];
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
        encode zstd gzip
    '';
  };

  services.glance = {
    enable = true;
    settings = {

      server = {
        inherit port;
        host = "127.0.0.1";
        proxied = true;
      };

      branding = {
        logo-text = "JKA";
      };

      theme = {
        contrast = 1.1;

        presets = {
          inherit gruvbox;
          inherit teal-city;
        };
      };

      pages = [
        {
          name = "Home";
          width = "slim";
          desktop-navigation-width = "default";
          center-vertically = true;
          head-widgets = [
            {
              type = "search";
              search-engine = "google";
              autofocus = true;
            }
          ];
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "Hannover, Germany";
                  hour-format = "24h";
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "General";
                      links = [
                        {
                          title = "DeepL Write";
                          url = "https://www.deepl.com/en/write";
                        }
                        {
                          title = "Frisia Intern";
                          url = "https://intern.avfrisia.de";
                        }
                      ];
                    }
                    {
                      title = "Tech";
                      links = [
                        {
                          title = "GitHub";
                          url = "https://github.com";
                        }
                        {
                          title = "/g/";
                          url = "https://4chan.org/g/catalog";
                        }

                      ];
                    }
                    {
                      title = "Entertainment";
                      links = [
                        {
                          title = "YouTube";
                          url = "https://youtube.com";
                        }
                        {
                          title = "Jellyfin";
                          url = "https://jellyfin.jka.one";
                        }
                      ];
                    }
                    {
                      title = "Work";
                      color = companyColor;
                      links = [
                        {
                          title = "Open-Xchange";
                          url = "https://ox.intern.b1-systems.de/appsuite/";
                        }
                        {
                          title = "Vaultwarden";
                          url = "https://pass.intern.b1-systems.de";
                        }
                        {
                          title = "Wiki";
                          url = "https://wiki.intern.b1-systems.de";
                        }
                        {
                          title = "Zeiterfassung";
                          url = "https://zeiterfassung.intern.b1-systems.de/";
                        }
                        {
                          title = "BigBlueButton";
                          url = "https://b1.b1-athome.de";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        }
        {
          name = "News";

          head-widgets = [
            {
              type = "markets";
              markets = [
                {
                  symbol = "EURUSD=X";
                  name = "Euro";
                }
                {
                  symbol = "GC=F";
                  name = "Gold";
                }
                {
                  symbol = "INTC";
                  name = "Intel Corp";
                }
                {
                  symbol = "AAPL";
                  name = "Apple Inc";
                }
                {
                  symbol = "GOOG";
                  name = "Alphabet Inc";
                }
              ];
            }
          ];
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "clock";
                  hour-format = "24h";
                  timezones = [
                    {
                      timezone = "Etc/UTC";
                      label = "UTC";
                    }
                    {
                      timezone = "Europe/Berlin";
                      label = "Hannover";
                    }
                    {
                      timezone = "America/Los_Angeles";
                      label = "Portland";
                    }
                  ];
                }
                {
                  type = "calendar";
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "group";
                  widgets = [
                    {
                      type = "rss";
                      title = "RSS";
                      style = "detailed-list";
                      feeds = [
                        {
                          title = "Tagesschau";
                          #url = "https://www.tagesschau.de/infoservices/rssfeeds/tagesschau-homepage-ohne-sport-100~atom.xml";
                          url = "https://www.tagesschau.de/index~rss2.xml";
                        }
                        {
                          title = "WELT";
                          url = "https://www.welt.de/feeds/topnews.rss";
                        }
                        {
                          title = "Heise";
                          url = "https://www.heise.de/rss/heise-atom.xml";
                        }
                        {
                          title = "iX";
                          url = "https://www.heise.de/ix/feed.xml";
                        }
                        {
                          title = "Slashdot";
                          url = "http://rss.slashdot.org/Slashdot/slashdotMainatom";
                        }
                        {
                          title = "LWN";
                          url = "https://lwn.net/headlines/rss";
                        }
                      ];
                    }
                    {
                      type = "hacker-news";
                    }
                    {
                      type = "lobsters";
                    }

                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "releases";
                  repositories = [
                    "meshtastic/firmware"
                    "Ralim/IronOS"
                    "glanceapp/glance"
                    "merge/skulls"
                  ];
                }
              ];
            }
          ];
        }
        {
          name = "Status";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "monitor";
                  sites = [
                    {
                      title = "Homepage";
                      url = "https://jka.one";
                    }
                    {
                      title = "Cloud";
                      url = "https://cloud.jka.one";
                    }
                    {
                      title = "Jellyfin";
                      url = "https://jellyfin.jka.one";
                    }
                  ];
                }
                {
                  type = "server-stats";
                  servers = [
                    {
                      type = "local";
                      name = "Skylab";
                    }
                  ];
                }
              ];
            }
          ];
        }
        {
          name = "Frisia";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "monitor";
                  sites = [
                    {
                      title = "Homepage";
                      url = "https://avfrisia.de";
                    }
                    {
                      title = "Intern";
                      url = "https://intern.avfrisia.de";
                    }
                    {
                      title = "Wiki";
                      url = "https://wiki.avfrisia.de";
                    }
                    {
                      title = "Cloud";
                      url = "https://cloud.avfrisia.de";
                    }
                  ];
                }
                {
                  type = "rss";
                  feeds = [
                    {
                      url = "https://avfrisia.de/index.xml";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };

}
