{ config, ... }:

let

intel = [ "i686-linux" "x86_64-linux" ];
all = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

in

{

  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.buildMachines = [
    {
      hostName = "adh";
      systems = intel;
      supportedFeatures = all;
    }
  ];
}

