{ config, ... }:

let

  server = "100.120.246.92";
  intel = [ "i686-linux" "x86_64-linux" ];
  all = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

in {

  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.buildMachines = [{
    hostName = server;
    sshUser = "johannes";
    systems = intel;
    supportedFeatures = all;
    maxJobs = 4;
  }];
  #nix.trustedBinaryCaches = [ "http://${server}:5000" ];
}

