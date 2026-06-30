# courtesy of https://github.com/jchvz/dotfiles/blob/master/nixos/utils/derive.nix
{ pkgs, ... }:
{
  go =
    {
      owner,
      pname,
      cmd,
      version,
      repoHash,
      vendorHash,
      buildInputs ? [ ],
    }:
    let
      repoPath = pkgs.fetchFromGitHub {
        inherit owner;
        hash = repoHash;
        repo = pname;
        rev = version;
      };
    in
    pkgs.buildGoModule {
      src = repoPath;
      # Let buildGoModule own CGO_ENABLED. This stdenv sets it both in `env`
      # and as a top-level derivation arg, so overriding it either way collides
      # with the other copy. swaggo is pure Go, so the default build is fine.
      name = pname;
      proxyVendor = true;
      vendorHash = vendorHash;
      subPackages = [ cmd ];
      meta = { };
    };
}
