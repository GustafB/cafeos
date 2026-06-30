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

## Build / switch

Desktop (bare-metal NixOS):

```sh
sudo nixos-rebuild switch --flake .#desktop
```

WSL (after installing the NixOS-WSL distro and cloning this repo):

```sh
sudo nixos-rebuild switch --flake .#wsl
```

## Notes

- The `laptop` host still uses the pre-refactor layout and is not wired into
  `flake.nix`; mirror `hosts/desktop` to migrate it.
- `hosts/default` is the install-time template (no `hardware.nix`).
