{ pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.johannes = ({ pkgs, ...}:
  {
    programs.home-manager.enable = true;

    home.packages = [
      pkgs.fortune
    ];
    
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-nix ];
      extraConfig = ''
        set number
      '';
    };
  });
}
