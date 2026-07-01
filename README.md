# cafeos

A NixOS flake that targets both a **full desktop** (Hyprland) and a **headless
WSL** install from a single, shared module tree.

## How it works

Every host imports the *same* module set. Each host carries a
`hosts/<host>/variables.nix` whose `gui` flag drives a feature toggle:

- `gui = true` &rarr; full desktop: Hyprland, waybar, rofi, audio (pipewire),
  graphics, bluetooth, fonts, greetd, 1Password GUI, virtualisation, …
- `gui = false` &rarr; only the portable bits take effect: locale, nix settings,
  zsh, ssh, openssh, garbage collection, and the shared home-manager shell/dev
  config (git, neovim, starship, fzf, …).

The toggle is read as the `vars` argument (passed through `specialArgs` /
`home-manager.extraSpecialArgs` from `flake.nix`):

- System modules gate their config with `lib.mkIf vars.gui { … }`.
- Home modules pull GUI modules in via `lib.optionals vars.gui [ … ]`
  (see `hosts/<host>/home.nix` &rarr; `home/modules/desktop`).

## Layout

```
flake.nix              # mkHost helper + nixosConfigurations
hosts/<host>/          # configuration.nix, home.nix, users.nix, variables.nix
modules/               # shared NixOS modules (default.nix aggregates them)
home/modules/          # shared home-manager modules
home/modules/desktop/  # GUI-only home modules (hyprland, kitty, waybar, rofi)
```

## Fresh install

On a freshly installed NixOS machine (with a normal user account created during
the NixOS install):

```sh
nix-shell -p git                      # if git isn't available yet
git clone <this-repo> ~/cafeos
cd ~/cafeos
./install-cafeos.sh                    # defaults to the "laptop" host
```

`install-cafeos.sh` verifies it's on NixOS, sets the `username` in `flake.nix`
and `keyboardLayout` in the host's `variables.nix`, generates this machine's
`hosts/<host>/hardware.nix`, stages it so the flake can see it, and runs the
first `nixos-rebuild switch --flake .#<host>`. Pass a host name to install a
different one, e.g. `./install-cafeos.sh desktop`.

## Build / switch

Once installed, rebuild with the matching host:

```sh
sudo nixos-rebuild switch --flake .#desktop   # bare-metal desktop
sudo nixos-rebuild switch --flake .#laptop    # bare-metal laptop
sudo nixos-rebuild switch --flake .#wsl        # NixOS-WSL
```

## Notes

- `hosts/default` is a bare template (no `hardware.nix`) and is not wired into
  `flake.nix`; the real hosts (`desktop`, `laptop`, `wsl`) each carry their own
  generated `hardware.nix`.
- The `laptop` host defaults to `drivers.nvidia.enable = false`; flip it to
  `true` in `hosts/laptop/configuration.nix` if the machine has an Nvidia GPU.
