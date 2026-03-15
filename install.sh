#!/bin/bash
# ================================================================
#  dotfiles installer — bobofthehawk
#  Installs dwm, slstatus, and all configs from scratch.
#  Run: bash install.sh
# ================================================================

set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"
USERNAME=$(whoami)

# colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}  ✓ $1${NC}"; }
info() { echo -e "${YELLOW}  → $1${NC}"; }
err()  { echo -e "${RED}  ✗ $1${NC}"; exit 1; }

echo ""
echo "================================================================"
echo "  dotfiles installer — $USERNAME"
echo "================================================================"
echo ""

# ----------------------------------------------------------------
# 1. PACKAGES
# ----------------------------------------------------------------
echo "[ 1 / 6 ]  Installing packages..."
info "This may take a few minutes on a fresh system."

sudo pacman -S --needed --noconfirm \
    base-devel \
    libx11 \
    libxft \
    libxinerama \
    git \
    dmenu \
    kitty \
    qutebrowser \
    maim \
    xclip \
    clipmenu \
    thunar \
    yazi \
    picom \
    brightnessctl \
    lxsession \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    xorg-xset \
    xorg-xrandr \
    xorg-xrdb \
    xorg-xinit \
    networkmanager \
    pipewire \
    pipewire-pulse \
    pavucontrol \
    wget \
    patch

ok "Packages installed."

# ----------------------------------------------------------------
# 2. SYSTEM SETUP
# ----------------------------------------------------------------
echo ""
echo "[ 2 / 6 ]  System setup..."

sudo systemctl enable NetworkManager
ok "NetworkManager enabled."

sudo timedatectl set-timezone Asia/Tashkent
ok "Timezone set to Asia/Tashkent."

# ----------------------------------------------------------------
# 3. BUILD DWM
# ----------------------------------------------------------------
echo ""
echo "[ 3 / 6 ]  Building dwm..."

DWM_DIR="$HOME_DIR/dwm"

# clone fresh if not there, otherwise pull latest
if [ ! -d "$DWM_DIR" ]; then
    info "Cloning dwm from suckless.org..."
    git clone https://git.suckless.org/dwm "$DWM_DIR"
else
    info "~/dwm exists, pulling latest..."
    cd "$DWM_DIR" && git pull && cd "$REPO"
fi

# --- patch 1: hide_vacant_tags ---
info "Applying hide_vacant_tags patch..."
cd "$DWM_DIR"
wget -q -O hide_vacant_tags.diff \
    "https://dwm.suckless.org/patches/hide_vacant_tags/dwm-hide_vacant_tags-6.3.diff"

# apply only if not already applied
if patch --dry-run -p1 < hide_vacant_tags.diff &>/dev/null; then
    patch -p1 < hide_vacant_tags.diff
    ok "hide_vacant_tags patch applied."
else
    ok "hide_vacant_tags already applied, skipping."
fi
rm -f hide_vacant_tags.diff

# --- patch 2: togglefullscr (manual — official patch URL is broken) ---
info "Adding togglefullscr..."

# only add if not already there
if ! grep -q "togglefullscr" "$DWM_DIR/dwm.c"; then
    # add declaration before zoom declaration
    sed -i '/^static void zoom/i static void togglefullscr(const Arg *arg);' dwm.c
    # add function body at end of file
    cat >> dwm.c << 'CEOF'

void
togglefullscr(const Arg *arg)
{
	if (selmon->sel)
		setfullscreen(selmon->sel, !selmon->sel->isfullscreen);
}
CEOF
    ok "togglefullscr added."
else
    ok "togglefullscr already present, skipping."
fi

# --- copy config and compile ---
info "Copying dwm config.h..."
cp "$REPO/dwm/config.h" "$DWM_DIR/config.h"

info "Compiling dwm..."
sudo make clean install
ok "dwm built and installed."
cd "$REPO"

# ----------------------------------------------------------------
# 4. BUILD SLSTATUS
# ----------------------------------------------------------------
echo ""
echo "[ 4 / 6 ]  Building slstatus..."

SLSTATUS_DIR="$HOME_DIR/slstatus"

if [ ! -d "$SLSTATUS_DIR" ]; then
    info "Cloning slstatus from suckless.org..."
    git clone https://git.suckless.org/slstatus "$SLSTATUS_DIR"
else
    info "~/slstatus exists, pulling latest..."
    cd "$SLSTATUS_DIR" && git pull && cd "$REPO"
fi

info "Copying slstatus config.h..."
cp "$REPO/slstatus/config.h" "$SLSTATUS_DIR/config.h"

info "Compiling slstatus..."
cd "$SLSTATUS_DIR"
sudo make clean install
ok "slstatus built and installed."
cd "$REPO"

# ----------------------------------------------------------------
# 5. DOTFILES
# ----------------------------------------------------------------
echo ""
echo "[ 5 / 6 ]  Installing dotfiles..."

# .xinitrc
cp "$REPO/home/.xinitrc" "$HOME_DIR/.xinitrc"
ok ".xinitrc"

# .Xresources
cp "$REPO/home/.Xresources" "$HOME_DIR/.Xresources"
ok ".Xresources"

# picom config
mkdir -p "$HOME_DIR/.config/picom"
cp "$REPO/config/picom/picom.conf" "$HOME_DIR/.config/picom/picom.conf"
ok "picom.conf"

# zed launch script
mkdir -p "$HOME_DIR/.local/bin"
cp "$REPO/scripts/zed-launch.sh" "$HOME_DIR/.local/bin/zed-launch.sh"
chmod +x "$HOME_DIR/.local/bin/zed-launch.sh"
ok "zed-launch.sh"

# create required directories
mkdir -p "$HOME_DIR/Screenshots"
ok "~/Screenshots"

mkdir -p "$HOME_DIR/.cache/clipmenu"
ok "~/.cache/clipmenu"

# ----------------------------------------------------------------
# 6. XINITRC SETUP
# ----------------------------------------------------------------
echo ""
echo "[ 6 / 6 ]  Final setup..."

# make sure ~/.local/bin is in PATH
if ! grep -q ".local/bin" "$HOME_DIR/.zshrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.zshrc"
    ok "Added ~/.local/bin to PATH in .zshrc"
fi

if ! grep -q ".local/bin" "$HOME_DIR/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.bashrc"
    ok "Added ~/.local/bin to PATH in .bashrc"
fi

echo ""
echo "================================================================"
echo "  All done!"
echo ""
echo "  Start dwm:   startx"
echo ""
echo "  NOTE: If your monitor or interface is different, edit:"
echo "    ~/.xinitrc       → xrandr line (monitor output + resolution)"
echo "    ~/slstatus/config.h → wlan0 (if using ethernet: enp109s0)"
echo "    ~/dwm/config.h   → username in screenshot paths"
echo "================================================================"
echo ""
