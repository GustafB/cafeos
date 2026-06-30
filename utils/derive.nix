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
      nativeBuildInputs = [ pkgs.musl ];
      # structured-attrs stdenv: CGO_ENABLED must live in `env`, not as a
      # top-level derivation argument (buildGoModule also sets env.CGO_ENABLED).
      env.CGO_ENABLED = 0;
      ldflags = [ ];
      name = pname;
      proxyVendor = true;
      vendorHash = vendorHash;
      subPackages = [ cmd ];
      meta = { };
    };
}
