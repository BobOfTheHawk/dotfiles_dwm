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

# colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

ok()      { echo -e "${GREEN}  ✓ $1${NC}"; }
info()    { echo -e "${YELLOW}  → $1${NC}"; }
err()     { echo -e "${RED}  ✗ $1${NC}"; exit 1; }
section() { echo -e "\n${BLUE}[ $1 ]${NC}"; }

echo ""
echo "================================================================"
echo "  dotfiles installer — $USERNAME"
echo "================================================================"

# must not run as root
if [ "$EUID" -eq 0 ]; then
    err "Do not run this script as root. Run as your normal user."
fi

# ----------------------------------------------------------------
# 1. DETECT GPU
# ----------------------------------------------------------------
section "1 / 7  Detecting GPU..."

GPU_PACKAGES=""
GPU_INFO=$(lspci 2>/dev/null | grep -i "vga\|3d\|display" || echo "unknown")

if echo "$GPU_INFO" | grep -qi "nvidia"; then
    info "NVIDIA GPU detected."
    GPU_PACKAGES="nvidia nvidia-utils nvidia-settings"
    ok "Will install: nvidia nvidia-utils nvidia-settings"
elif echo "$GPU_INFO" | grep -qi "amd\|radeon\|advanced micro"; then
    info "AMD GPU detected."
    GPU_PACKAGES="xf86-video-amdgpu mesa vulkan-radeon libva-mesa-driver"
    ok "Will install: xf86-video-amdgpu mesa vulkan-radeon"
elif echo "$GPU_INFO" | grep -qi "intel"; then
    info "Intel GPU detected."
    GPU_PACKAGES="xf86-video-intel mesa vulkan-intel intel-media-driver"
    ok "Will install: xf86-video-intel mesa vulkan-intel"
else
    info "GPU not detected or unknown — installing generic mesa."
    GPU_PACKAGES="mesa"
fi

# ----------------------------------------------------------------
# 2. XORG + GPU
# ----------------------------------------------------------------
section "2 / 7  Installing Xorg..."

sudo pacman -S --needed --noconfirm \
    xorg-server \
    xorg-xinit \
    xorg-xset \
    xorg-xrandr \
    xorg-xrdb \
    xorg-xprop \
    $GPU_PACKAGES

ok "Xorg + GPU done."

# ----------------------------------------------------------------
# 3. AUDIO
# ----------------------------------------------------------------
section "3 / 7  Installing audio (PipeWire)..."

sudo pacman -S --needed --noconfirm \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
    wireplumber \
    pavucontrol \
    alsa-utils

systemctl --user enable pipewire pipewire-pulse wireplumber 2>/dev/null || true
ok "Audio done."

# ----------------------------------------------------------------
# 4. NETWORK
# ----------------------------------------------------------------
section "4 / 7  Installing network..."

sudo pacman -S --needed --noconfirm \
    networkmanager \
    network-manager-applet \
    iw \
    wpa_supplicant \
    dhcpcd \
    curl \
    wget \
    openssh

sudo systemctl enable NetworkManager
ok "Network done."

# ----------------------------------------------------------------
# 5. FONTS
# ----------------------------------------------------------------
section "5 / 7  Installing fonts..."

sudo pacman -S --needed --noconfirm \
    ttf-dejavu \
    ttf-liberation \
    noto-fonts \
    noto-fonts-emoji \
    noto-fonts-cjk \
    ttf-jetbrains-mono \
    fontconfig

ok "Fonts done."

# ----------------------------------------------------------------
# 6. APPS + TOOLS
# ----------------------------------------------------------------
section "6 / 7  Installing apps and tools..."

sudo pacman -S --needed --noconfirm \
    base-devel \
    libx11 \
    libxft \
    libxinerama \
    git \
    patch \
    dmenu \
    kitty \
    qutebrowser \
    maim \
    xclip \
    clipmenu \
    thunar \
    thunar-volman \
    thunar-archive-plugin \
    file-roller \
    gvfs \
    yazi \
    picom \
    brightnessctl \
    lxsession \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    xdg-user-dirs \
    polkit \
    bluez \
    bluez-utils \
    ntfs-3g \
    unzip \
    zip \
    p7zip \
    tar \
    gvim \
    btop \
    man-db \
    man-pages \
    less \
    feh \
    mpv \
    imv

ok "Apps done."

# ----------------------------------------------------------------
# 7. BUILD DWM + SLSTATUS
# ----------------------------------------------------------------
section "7 / 7  Building dwm + slstatus..."

# --- dwm ---
DWM_DIR="$HOME_DIR/dwm"

if [ ! -d "$DWM_DIR" ]; then
    info "Cloning dwm..."
    git clone https://git.suckless.org/dwm "$DWM_DIR"
else
    info "~/dwm exists, using repo's config and dwm.c..."
fi

info "Copying dwm config.h and dwm.c..."
cp "$REPO/dwm/config.h" "$DWM_DIR/config.h"
cp "$REPO/dwm/dwm.c"    "$DWM_DIR/dwm.c"

info "Compiling dwm..."
cd "$DWM_DIR" && sudo make clean install
ok "dwm built and installed."
cd "$REPO"

# --- slstatus ---
SLSTATUS_DIR="$HOME_DIR/slstatus"

if [ ! -d "$SLSTATUS_DIR" ]; then
    info "Cloning slstatus..."
    git clone https://git.suckless.org/slstatus "$SLSTATUS_DIR"
else
    info "~/slstatus exists, updating config only..."
fi

info "Copying slstatus config.h..."
cp "$REPO/slstatus/config.h" "$SLSTATUS_DIR/config.h"

info "Compiling slstatus..."
cd "$SLSTATUS_DIR" && sudo make clean install
ok "slstatus built and installed."
cd "$REPO"

# ----------------------------------------------------------------
# DOTFILES
# ----------------------------------------------------------------
section "Copying dotfiles..."

cp "$REPO/home/.xinitrc"    "$HOME_DIR/.xinitrc"
ok ".xinitrc"

cp "$REPO/home/.Xresources" "$HOME_DIR/.Xresources"
ok ".Xresources"

mkdir -p "$HOME_DIR/.config/picom"
cp "$REPO/config/picom/picom.conf" "$HOME_DIR/.config/picom/picom.conf"
ok "picom.conf"

mkdir -p "$HOME_DIR/.local/bin"
cp "$REPO/scripts/zed-launch.sh" "$HOME_DIR/.local/bin/zed-launch.sh"
chmod +x "$HOME_DIR/.local/bin/zed-launch.sh"
ok "zed-launch.sh"

mkdir -p "$HOME_DIR/Screenshots"
ok "~/Screenshots"

mkdir -p "$HOME_DIR/.cache/clipmenu"
ok "~/.cache/clipmenu"

xdg-user-dirs-update 2>/dev/null || true
ok "xdg user dirs updated"

sudo systemctl enable bluetooth 2>/dev/null && ok "Bluetooth enabled." || true

# PATH
if ! grep -q ".local/bin" "$HOME_DIR/.zshrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.zshrc"
    ok "~/.local/bin added to .zshrc"
fi
if ! grep -q ".local/bin" "$HOME_DIR/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.bashrc"
    ok "~/.local/bin added to .bashrc"
fi

# ----------------------------------------------------------------
# DONE
# ----------------------------------------------------------------
echo ""
echo "================================================================"
echo -e "${GREEN}  All done!${NC}"
echo ""
echo "  Start dwm:   startx"
echo ""
echo "  ⚠  Adjust these if your hardware differs:"
echo "     ~/.xinitrc          → xrandr line (monitor output + resolution)"
echo "     ~/slstatus/config.h → wlan0 (use enp109s0 if on ethernet)"
echo "     ~/dwm/config.h      → /home/bobofthehawk/ in screenshot paths"
echo ""
echo "  GPU detected: $GPU_INFO"
echo "================================================================"
echo ""
