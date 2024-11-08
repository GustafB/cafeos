{ pkgs, ... }:
let
  derive = import ../../../../utils/derive.nix { inherit pkgs; };
in
{
  home.packages = [
    (derive.go {
      owner = "swaggo";
      pname = "swag";
      version = "v1.8.12";
      repoHash = "sha256-2rnaPN4C4pn9Whk5X2z1VVxm679EUpQdumJZx5uulr4=";
      vendorHash = "sha256-mLMOArOz7TPYvHWtAtwCMV/LWMC8CkMDGFBDYW1Z4NM=";
      cmd = "cmd/swag";
    })
  ];
}
