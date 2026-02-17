#!/usr/bin/env bash
set -oue pipefail

echo "==> [Zaatar OS] Installing MacTahoe Theme..."

# ── Dependencies ──────────────────────────────────────────────
dnf install -y \
    git \
    sassc \
    glib2-devel \
    gtk-murrine-engine \
    gtk2-engines \
    inkscape \
    optipng \
    wget \
    unzip

# ── GTK Theme ─────────────────────────────────────────────────
echo "==> Installing MacTahoe GTK Theme..."
cd /tmp
git clone https://github.com/vinceliuice/MacTahoe-gtk-theme.git --depth=1
cd MacTahoe-gtk-theme

./install.sh \
    -l \
    -c dark \
    -t all \
    -b \
    --right-placement \
    -i fedora

# Copy to system directory
mkdir -p /usr/share/themes
cp -r ~/.themes/MacTahoe* /usr/share/themes/ 2>/dev/null || true

# ── Icon Theme ────────────────────────────────────────────────
echo "==> Installing MacTahoe Icon Theme..."
cd /tmp
git clone https://github.com/vinceliuice/MacTahoe-icon-theme.git --depth=1
cd MacTahoe-icon-theme

./install.sh -t all

mkdir -p /usr/share/icons
cp -r ~/.local/share/icons/MacTahoe* /usr/share/icons/ 2>/dev/null || true

# ── Cursor Theme ──────────────────────────────────────────────
echo "==> Installing MacTahoe Cursor Theme..."
cd /tmp/MacTahoe-icon-theme/cursors
./install.sh
cp -r ~/.local/share/icons/MacTahoe-cursors /usr/share/icons/ 2>/dev/null || true

# ── Wallpapers ────────────────────────────────────────────────
echo "==> Installing Zaatar Wallpapers..."
mkdir -p /usr/share/backgrounds/zaatar
cp /tmp/MacTahoe-gtk-theme/wallpaper/* /usr/share/backgrounds/zaatar/ 2>/dev/null || true

# ── Cleanup ───────────────────────────────────────────────────
rm -rf /tmp/MacTahoe-gtk-theme
rm -rf /tmp/MacTahoe-icon-theme

echo "==> MacTahoe Theme Installed Successfully!"
