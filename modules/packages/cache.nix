{
  pkgs,
  config,
  lib,
  ...
}:
{

  nix.settings = {
    post-build-hook = pkgs.writeShellScript "testhook" ''
      /home/johannes/Projects/ncc/ncc put
    '';
  };
}
