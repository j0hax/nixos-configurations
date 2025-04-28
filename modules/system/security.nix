{ pkgs, lib, ... }:
{
  environment.wordlist = {
    enable = true;
    lists = lib.readDir (pkgs.wordlists);
  };
}
