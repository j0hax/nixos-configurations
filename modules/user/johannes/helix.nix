{
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "gruvbox";
      editor = {
        cursorline = true;
        rulers = [
          80
          132
        ];
        indent-guides = {
          render = true;
          skip-levels = 1;
        };
        whitespace.characters = {
          space = "·";
          nbsp = "⍽";
          nnbsp = "␣";
          tab = "→";
          newline = "⏎";
          tabpad = "·";
        };
        bufferline = "always";
        popup-border = "all";
        inline-diagnostics = {
          cursor-line = "hint";
        };

        soft-wrap.enable = true;
      };
    };
    languages = {
      language-server = {
        harper-ls = {
          command = "harper-ls";
          args = [ "--stdio" ];
        };
      };

      language = [
        {
          name = "markdown";
          language-servers = [
            "marksman"
            "markdown-oxide"
            "harper-ls"
          ];
        }
        {
          name = "salt";
          scope = "source.yaml.salt";
          injection-regex = "sls";
          block-comment-tokens = [
            {
              start = "{{";
              end = "}}";
            }
            {
              start = "{%";
              end = "%}";
            }
            {
              start = "{#";
              end = "#}";
            }
          ];
          file-types = [ "sls" ];
          grammar = "yaml";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "salt-lint" ];
        }
      ];
    };
  };
}
