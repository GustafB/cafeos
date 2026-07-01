#!/usr/bin/env bash
#
# CafeOS installer.
#
# Run on a fresh NixOS machine, from inside a clone of this repo:
#
#     nix-shell -p git
#     git clone <this-repo> ~/cafeos
#     cd ~/cafeos
#     ./install-cafeos.sh            # defaults to the "laptop" host
#     ./install-cafeos.sh desktop    # or pick another host in ./hosts
#
# It generates this machine's hardware config, points the flake at the right
# username, and does the first nixos-rebuild switch.

set -euo pipefail

HOST="${1:-laptop}"

# Repo root = wherever this script lives. No hardcoded home paths.
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "-----"

if ! grep -qi nixos /etc/os-release 2>/dev/null; then
    echo "This is not NixOS (or /etc/os-release is missing). Aborting."
    exit 1
fi
echo "Verified this is NixOS."

if ! command -v git &>/dev/null; then
    echo "Git is not installed. Enter a shell with it and re-run:"
    echo "    nix-shell -p git"
    exit 1
fi
echo "Git is available."

HOST_DIR="$REPO_DIR/hosts/$HOST"
if [ ! -d "$HOST_DIR" ]; then
    echo "No host directory at hosts/$HOST."
    echo "Available hosts: $(ls "$REPO_DIR/hosts" | tr '\n' ' ')"
    exit 1
fi
echo "Installing host: $HOST"

echo "-----"
echo "Default options are in brackets []; just press enter to accept."
echo "-----"

# The invoking user (never root — we only sudo for the rebuild itself).
default_user="${SUDO_USER:-$USER}"
read -rp "Username for this install: [ $default_user ] " install_user
install_user="${install_user:-$default_user}"

# flake.nix is the single source of truth for the username; every host reads it
# through the `username` arg, so this one edit propagates everywhere.
sed -i "s/^\([[:space:]]*username[[:space:]]*=[[:space:]]*\)\"[^\"]*\"/\1\"$install_user\"/" "$REPO_DIR/flake.nix"
echo "Set username = \"$install_user\"."

echo "-----"

read -rp "Keyboard layout: [ us ] " kb_layout
kb_layout="${kb_layout:-us}"
sed -i "s/^\([[:space:]]*keyboardLayout[[:space:]]*=[[:space:]]*\)\"[^\"]*\"/\1\"$kb_layout\"/" "$HOST_DIR/variables.nix"
echo "Set keyboardLayout = \"$kb_layout\"."

echo "-----"

echo "Generating hardware configuration for '$HOST'..."
sudo nixos-generate-config --show-hardware-config >"$HOST_DIR/hardware.nix"

# Flakes only see files that git tracks. Stage everything so the freshly
# generated hardware.nix (and any edits above) are visible to the build.
git -C "$REPO_DIR" add -A

echo "-----"
echo "Building and switching to .#$HOST (this will take a while)..."
export NIX_CONFIG="experimental-features = nix-command flakes"
sudo nixos-rebuild switch --flake "$REPO_DIR#$HOST"

echo "-----"
echo "Done. CafeOS host '$HOST' is installed. Reboot to start it."
