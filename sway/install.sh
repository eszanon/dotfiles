#!/bin/bash
# One-time setup for the Sway + Omarchy-style environment on this Ubuntu 24.04 PC.
# Run from anywhere: bash sway/install.sh
set -e

echo "==> Installing the sway stack via apt"
sudo apt install -y \
  sway swaybg swaylock swayidle waybar wofi mako-notifier foot \
  grim slurp wl-clipboard cliphist wf-recorder wlsunset \
  brightnessctl playerctl pavucontrol pulsemixer pulseaudio-utils blueman \
  xdg-desktop-portal-wlr xdg-desktop-portal-gtk policykit-1-gnome \
  python3-i3ipc fonts-jetbrains-mono jq tesseract-ocr pngquant \
  pkg-config libpipewire-0.3-dev libdbus-1-dev clang

echo "==> Building swappy (screenshot annotation; not packaged on noble)"
sudo apt install -y meson ninja-build scdoc gettext libgtk-3-dev
SWAPPY_SRC=$(mktemp -d)
# clone (not the tarball): meson.build embeds the version via git rev-parse
git clone --depth 1 --branch v1.8.0 https://github.com/jtheoof/swappy.git "$SWAPPY_SRC"
meson setup "$SWAPPY_SRC/build" "$SWAPPY_SRC" --prefix ~/.local
ninja -C "$SWAPPY_SRC/build" install
rm -rf "$SWAPPY_SRC"

echo "==> Installing the Omarchy TUIs (wiremix + bluetui) via cargo (rust from mise)"
mise use -g rust@latest
~/.local/share/mise/shims/cargo install wiremix bluetui
mkdir -p ~/.local/bin
ln -sf ~/.cargo/bin/wiremix ~/.cargo/bin/bluetui ~/.local/bin/

echo "==> Installing ghostty (snap)"
sudo snap install ghostty --classic

echo "==> Installing autotiling (dwindle-like auto split) to ~/.local/bin"
mkdir -p ~/.local/bin
curl -fsSL -o ~/.local/bin/autotiling \
  https://raw.githubusercontent.com/nwg-piotr/autotiling/master/autotiling/main.py
chmod +x ~/.local/bin/autotiling

echo
echo "Done. Next steps:"
echo "  1. cd to the dotfiles repo and run: stow ."
echo "     (links sway/, swaylock/, swayidle/, mako/, wofi/ into ~/.config)"
echo "  2. Log out and pick the 'Sway' session on the GDM login screen."
