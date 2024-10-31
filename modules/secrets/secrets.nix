let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8vQ+hA29zMuLGe8crY8Mi3fZieJ3mo78W3qWx5tAGq johannes@kirby"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqwawUvIIvbEPCcoQIUmn/cyVhjah/l4LWzzkZLIaEr johannes@clay"
  ];
in
{
  "restic/env.age".publicKeys = keys;
  "restic/repo.age".publicKeys = keys;
  "restic/password.age".publicKeys = keys;
}
