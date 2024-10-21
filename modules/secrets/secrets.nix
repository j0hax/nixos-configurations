let
  johannes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8vQ+hA29zMuLGe8crY8Mi3fZieJ3mo78W3qWx5tAGq johannes@kirby";
  kirby = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhtBoMIofjJ8fWt3H2TlFbAyvBfr8NumMhEn0CzLgGm root@kirby";
  keys = [
    johannes
    kirby
  ];
in
{
  "restic/env.age".publicKeys = keys;
  "restic/repo.age".publicKeys = keys;
  "restic/password.age".publicKeys = keys;
}
