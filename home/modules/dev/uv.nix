{ pkgs, ... }:
{
  # uv: fast Python package/venv manager. It downloads its own standalone
  # (python-build-standalone) interpreters; those are unpatched prebuilt
  # binaries, so they rely on the nix-ld shim (modules/programs/nix-ld.nix)
  # to find the dynamic loader at runtime. If a wheel dlopen's a system
  # library that isn't in nix-ld's default set, add it to
  # `programs.nix-ld.libraries`.
  home.packages = with pkgs; [
    uv
  ];
}
