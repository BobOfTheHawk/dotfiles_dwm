    #!/bin/bash
# ================================================================
#  dotfiles installer — bobofthehawk
# ================================================================

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"
USERNAME=$(whoami)

# ----------------------------------------------------------------
# LOGGING — every run writes a full transcript to disk, so a failure
# can be diagnosed later even if the terminal scrollback is gone.
# ----------------------------------------------------------------
LOG_DIR="$HOME_DIR/.local/share/dotfiles-install-logs"
mkdir -p "$LOG_DIR"
LOGFILE="$LOG_DIR/install-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOGFILE") 2>&1

# colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

CURRENT_SECTION="startup"

ok()      { echo -e "${GREEN}  ✓ $1${NC}"; }
info()    { echo -e "${YELLOW}  → $1${NC}"; }
err()     { echo -e "${RED}  ✗ $1${NC}"; exit 1; }
section() { CURRENT_SECTION="$1"; echo -e "\n${BLUE}══════════════════════════════════════════\n  $1\n══════════════════════════════════════════${NC}"; }
note()    { echo -e "${CYAN}  ⚑ $1${NC}"; }

# Fires on any command that fails unexpectedly (not on our own err() calls,
# since those exit explicitly). Reports exactly where things broke.
on_error() {
    local exit_code=$?
    echo -e "\n${RED}══════════════════════════════════════════"
    echo    "  ✗ INSTALL FAILED"
    echo -e "══════════════════════════════════════════${NC}"
    echo -e "${RED}  Section:${NC}   $CURRENT_SECTION"
    echo -e "${RED}  Line:${NC}      $1"
    echo -e "${RED}  Command:${NC}   $2"
    echo -e "${RED}  Exit code:${NC} $exit_code"
    echo ""
    echo "  Full log saved to: $LOGFILE"
    echo "  Most steps are idempotent — fix the issue above and re-run:"
    echo "    bash install.sh"
}
trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

echo ""
echo "================================================================"
echo "  dotfiles installer — $USERNAME"
echo "================================================================"
echo "  Logging full output to: $LOGFILE"
echo "================================================================"

# must not run as root
if [ "$EUID" -eq 0 ]; then
    err "Do not run this script as root. Run as your normal user."
fi

# ----------------------------------------------------------------
# 1. DETECT GPU
# ----------------------------------------------------------------
section "1 / 11  Detecting GPU..."

GPU_PACKAGES=""
GPU_INFO=$(lspci 2>/dev/null | grep -i "vga\|3d\|display" || echo "unknown")

if echo "$GPU_INFO" | grep -qi "nvidia"; then
    info "NVIDIA GPU detected."
    # linux-headers is REQUIRED for the nvidia kernel module to compile.
    # nvidia-dkms is used instead of nvidia because it works across all
    # kernel variants (linux, linux-lts, linux-zen, etc.) without needing
    # to reinstall drivers after a kernel update.
    GPU_PACKAGES="nvidia-dkms nvidia-utils nvidia-settings linux-headers"
    ok "Will install: nvidia-dkms nvidia-utils nvidia-settings linux-headers"
elif echo "$GPU_INFO" | grep -qi "amd\|radeon\|advanced micro"; then
    info "AMD GPU detected."
    GPU_PACKAGES="xf86-video-amdgpu mesa vulkan-radeon libva-mesa-driver linux-headers"
    ok "Will install: xf86-video-amdgpu mesa vulkan-radeon linux-headers"
elif echo "$GPU_INFO" | grep -qi "intel"; then
    info "Intel GPU detected."
    GPU_PACKAGES="xf86-video-intel mesa vulkan-intel intel-media-driver linux-headers"
    ok "Will install: xf86-video-intel mesa vulkan-intel linux-headers"
else
    info "GPU not detected or unknown — installing generic mesa."
    GPU_PACKAGES="mesa linux-headers"
fi

# ----------------------------------------------------------------
# 2. XORG + GPU
# ----------------------------------------------------------------
section "2 / 11  Installing Xorg + GPU drivers..."

sudo pacman -S --needed --noconfirm \
    xorg-server \
    xorg-xinit \
    xorg-xset \
    xorg-xrandr \
    xorg-xrdb \
    xorg-xprop \
    $GPU_PACKAGES

ok "Xorg + GPU done."

# For NVIDIA: verify the module loaded correctly after install.
# If 'nvidia-smi' works after reboot, you're good.
# If not, check: journalctl -b | grep -i nvidia

# ----------------------------------------------------------------
# 3. AUDIO
# ----------------------------------------------------------------
section "3 / 11  Installing audio (PipeWire)..."

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
section "4 / 11  Installing network..."

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
section "5 / 11  Installing fonts..."

# ttf-jetbrains-mono-nerd is required — kitty.conf and zed/settings.json
# both use "JetBrainsMono Nerd Font". The non-nerd version will NOT
# render icons in the terminal or Zed.
sudo pacman -S --needed --noconfirm \
    ttf-dejavu \
    ttf-liberation \
    noto-fonts \
    noto-fonts-emoji \
    noto-fonts-cjk \
    ttf-jetbrains-mono-nerd \
    fontconfig

ok "Fonts done."

# ----------------------------------------------------------------
# 6. APPS + TOOLS
# ----------------------------------------------------------------
section "6 / 11  Installing apps and tools..."

sudo pacman -S --needed --noconfirm \
    base-devel \
    keyd \
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
    imv \
    zsh \
    neovim \
    zoxide \
    fzf \
    eza \
    bat \
    git-delta \
    fastfetch \
    fd \
    tree \
    go

ok "Apps done."

# ----------------------------------------------------------------
# 7. AUR (yay + AUR packages)
# ----------------------------------------------------------------
section "7 / 11  Installing AUR packages..."

# Install yay if missing
if ! command -v yay &>/dev/null; then
    info "yay not found — installing yay (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$REPO"
    ok "yay installed."
else
    ok "yay already installed."
fi

info "Installing AUR packages..."
# zed          — code editor (not in official repos)
# atuin        — shell history with sync
# pokemon-colorscripts-git — random pokemon art used in .zshrc fastfetch splash
yay -S --needed --noconfirm zed atuin pokemon-colorscripts-git
ok "AUR packages done."

# ----------------------------------------------------------------
# 8. BUILD DWM + SLSTATUS
# ----------------------------------------------------------------
section "8 / 11  Building dwm + slstatus..."

# --- dwm ---
DWM_DIR="$HOME_DIR/dwm"

if [ ! -d "$DWM_DIR" ]; then
    info "Cloning dwm..."
    git clone https://git.suckless.org/dwm "$DWM_DIR"
else
    info "~/dwm exists — updating config and dwm.c..."
fi

# detect the real wireless/ethernet interface
# prefer wireless (starts with 'w'), fall back to first non-loopback ethernet
NET_IFACE=$(ip link show | awk -F': ' '/^[0-9]+: w/{print $2; exit}')
if [ -z "$NET_IFACE" ]; then
    NET_IFACE=$(ip link show | awk -F': ' '/^[0-9]+: /{iface=$2} /link\/ether/{print iface; exit}')
fi
[ -z "$NET_IFACE" ] && NET_IFACE="wlan0"   # last-resort fallback
info "Detected network interface: $NET_IFACE"

info "Copying dwm config.h and dwm.c..."
cp "$REPO/dwm/config.h" "$DWM_DIR/config.h"
cp "$REPO/dwm/dwm.c"    "$DWM_DIR/dwm.c"

# patch HOME_PLACEHOLDER → actual home dir (screenshot paths + zed-launch path)
sed -i "s|HOME_PLACEHOLDER|$HOME_DIR|g" "$DWM_DIR/config.h"
ok "dwm config.h patched: HOME_PLACEHOLDER → $HOME_DIR"

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
    info "~/slstatus exists — updating config..."
fi

info "Copying slstatus config.h..."
cp "$REPO/slstatus/config.h" "$SLSTATUS_DIR/config.h"

# patch IFACE_PLACEHOLDER → real interface detected above
sed -i "s|IFACE_PLACEHOLDER|$NET_IFACE|g" "$SLSTATUS_DIR/config.h"
ok "slstatus config.h patched: IFACE_PLACEHOLDER → $NET_IFACE"

info "Compiling slstatus..."
cd "$SLSTATUS_DIR" && sudo make clean install
ok "slstatus built and installed."
cd "$REPO"

# ----------------------------------------------------------------
# 9. DOTFILES — home files
# ----------------------------------------------------------------
section "9 / 11  Copying dotfiles..."

# .xinitrc + .Xresources
cp "$REPO/home/.xinitrc"    "$HOME_DIR/.xinitrc"
ok ".xinitrc"

cp "$REPO/home/.Xresources" "$HOME_DIR/.Xresources"
ok ".Xresources"

# .zshrc
cp "$REPO/home/.zshrc" "$HOME_DIR/.zshrc"
ok ".zshrc"

# .p10k.zsh — Powerlevel10k prompt config
# (sourced by .zshrc via [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh)
cp "$REPO/home/.p10k.zsh" "$HOME_DIR/.p10k.zsh"
ok ".p10k.zsh"

# .vimrc + gruvbox colorscheme (uses vim built-in package manager)
info "Installing gruvbox for vim..."
mkdir -p "$HOME_DIR/.vim/pack/plugins/start"
if [ ! -d "$HOME_DIR/.vim/pack/plugins/start/gruvbox" ]; then
    git clone https://github.com/morhetz/gruvbox.git "$HOME_DIR/.vim/pack/plugins/start/gruvbox"
    ok "gruvbox vim colorscheme installed."
else
    ok "gruvbox already installed."
fi
cp "$REPO/home/.vimrc" "$HOME_DIR/.vimrc"
ok ".vimrc"

# set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    ok "Default shell set to zsh (takes effect on next login)"
fi

# ----------------------------------------------------------------
# 10. DOTFILES — XDG config files
# ----------------------------------------------------------------
section "10 / 11  Copying XDG configs..."

# picom
mkdir -p "$HOME_DIR/.config/picom"
cp "$REPO/config/picom/picom.conf" "$HOME_DIR/.config/picom/picom.conf"
ok "picom.conf"

# kitty — 3 files:
#   kitty.conf          — main config (shell, keymaps, font, theme include)
#   current-theme.conf  — active theme (included at bottom of kitty.conf)
#   dark-theme.auto.conf — Gruvbox Dark color values
mkdir -p "$HOME_DIR/.config/kitty"
cp "$REPO/config/kitty/kitty.conf"           "$HOME_DIR/.config/kitty/kitty.conf"
cp "$REPO/config/kitty/current-theme.conf"   "$HOME_DIR/.config/kitty/current-theme.conf"
cp "$REPO/config/kitty/dark-theme.auto.conf" "$HOME_DIR/.config/kitty/dark-theme_auto.conf"
ok "kitty (kitty.conf + Gruvbox Dark theme)"

# zed
mkdir -p "$HOME_DIR/.config/zed"
cp "$REPO/config/zed/settings.json" "$HOME_DIR/.config/zed/settings.json"
ok "zed settings.json"

# fastfetch — two configs:
#   config.jsonc         — full detailed fetch (used standalone with 'f' alias)
#   config-pokemon.jsonc — compact fetch shown on every terminal open
mkdir -p "$HOME_DIR/.config/fastfetch"
cp "$REPO/config/fastfetch/config.jsonc"         "$HOME_DIR/.config/fastfetch/config.jsonc"
cp "$REPO/config/fastfetch/config-pokemon.jsonc" "$HOME_DIR/.config/fastfetch/config-pokemon.jsonc"
ok "fastfetch (config.jsonc + config-pokemon.jsonc)"

# nvim
# Lazy.nvim bootstraps itself on first launch — no pre-install needed.
# Mason will auto-install LSP servers on first :Mason open or :MasonInstall.
# Plugins: telescope, harpoon2, oil.nvim, mini.*, gopls, treesitter,
#          trouble, noice, lualine, gitsigns, lazygit, fugitive, etc.
# Note: 'go' package above is required for gopls to work.
mkdir -p "$HOME_DIR/.config/nvim"
cp -r "$REPO/config/nvim/." "$HOME_DIR/.config/nvim/"
ok "nvim (full config — lazy.nvim will bootstrap on first launch)"

# yazi
# The repo ships both flavors directly, so no curl needed.
#   flavors/gruvbox-dark.yazi  — active flavor (set in theme.toml)
#   flavors/catppuccin-mocha.yazi — extra flavor included
mkdir -p "$HOME_DIR/.config/yazi/flavors"
cp "$REPO/config/yazi/yazi.toml" "$HOME_DIR/.config/yazi/yazi.toml"
cp "$REPO/config/yazi/theme.toml" "$HOME_DIR/.config/yazi/theme.toml"
cp -r "$REPO/config/yazi/flavors/gruvbox-dark.yazi"      "$HOME_DIR/.config/yazi/flavors/"
cp -r "$REPO/config/yazi/flavors/catppuccin-mocha.yazi"  "$HOME_DIR/.config/yazi/flavors/"
ok "yazi (yazi.toml + theme.toml + gruvbox-dark + catppuccin-mocha flavors)"

# ----------------------------------------------------------------
# 11. KEYD — custom keyboard remapping
# ----------------------------------------------------------------
section "11 / 11  Configuring keyd (custom keymap)..."

# keyd is a kernel-level (evdev) key remapper — works identically in
# dwm, TTY, or anywhere else, unlike xmodmap/.xinitrc (X11-only).
#
# Layout shipped here:
#   Caps Lock (tap)      -> Esc
#   Left Alt  (tap)      -> normal Alt (dwm bindings untouched)
#   Left Alt  (hold) + jkuinmhlyop, -> ( ) [ ] { } - = \ | " '
#   Right Alt                       -> completely untouched
#
# This moves the C/shell/Neovim symbol cluster ( ) [ ] { } - _ = + \ ' "
# off the right pinky and onto the right hand's index/middle row.

KEYD_CONF="/etc/keyd/default.conf"
KEYD_SRC="$REPO/etc/keyd/default.conf"

sudo mkdir -p /etc/keyd

if [ -f "$KEYD_CONF" ] && ! cmp -s "$KEYD_SRC" "$KEYD_CONF"; then
    info "Existing $KEYD_CONF differs from repo version — backing up to $KEYD_CONF.bak"
    sudo cp "$KEYD_CONF" "$KEYD_CONF.bak"
fi

sudo cp "$KEYD_SRC" "$KEYD_CONF"
ok "keyd config installed -> $KEYD_CONF"

sudo systemctl enable --now keyd
sudo systemctl restart keyd
ok "keyd enabled + restarted (picks up the new config immediately)"

note "Test live with: keyd monitor"

# ----------------------------------------------------------------
# MISC SETUP
# ----------------------------------------------------------------

# zed-launch script
mkdir -p "$HOME_DIR/.local/bin"
cp "$REPO/scripts/zed-launch.sh" "$HOME_DIR/.local/bin/zed-launch.sh"
chmod +x "$HOME_DIR/.local/bin/zed-launch.sh"
ok "zed-launch.sh → ~/.local/bin/"

# ensure ~/.local/bin is on PATH in .bashrc (fallback for non-zsh sessions)
if ! grep -q ".local/bin" "$HOME_DIR/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.bashrc"
    ok "~/.local/bin added to .bashrc"
fi

# create standard dirs
mkdir -p "$HOME_DIR/Screenshots"
ok "~/Screenshots"

mkdir -p "$HOME_DIR/.cache/clipmenu"
ok "~/.cache/clipmenu"

# bootstrap zinit (used by .zshrc — clones itself on first zsh launch,
# but we clone it now so the first shell open is instant)
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME/.git" ]; then
    info "Bootstrapping zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    ok "zinit cloned."
else
    ok "zinit already present."
fi

xdg-user-dirs-update 2>/dev/null || true
ok "xdg user dirs updated"

sudo systemctl enable bluetooth 2>/dev/null && ok "Bluetooth enabled." || true

# ----------------------------------------------------------------
# DONE
# ----------------------------------------------------------------
echo ""
echo "================================================================"
echo -e "${GREEN}  All done!${NC}"
echo ""
echo "  Start dwm:   startx"
echo ""
echo -e "${YELLOW}  ⚠  First launch notes:${NC}"
echo ""
echo "  nvim         — open it once; lazy.nvim will auto-install all"
echo "                 plugins. Then run :Mason to install LSP servers."
echo "  zsh          — first open will compile zinit plugins (one-time)."
echo "                 Subsequent opens will be instant."
echo ""
echo -e "${YELLOW}  ⚠  Adjust for your hardware:${NC}"
echo ""
echo "  ~/.xinitrc          → xrandr line (monitor output + resolution)"
echo "  ~/slstatus/config.h → network interface was auto-detected as: $NET_IFACE"
echo "                        if wrong, edit and run: cd ~/slstatus && sudo make clean install"
echo "  ~/dwm/config.h      → home paths were auto-patched to: $HOME_DIR"
echo ""
echo -e "${YELLOW}  ⚠  Keyboard remap (keyd):${NC}"
echo ""
echo "  Caps Lock  (tap)        → Esc"
echo "  Left Alt   (hold) + jkuinmhlyop, → ( ) [ ] { } - = \\ | \" '"
echo "  Edit:    sudo nvim /etc/keyd/default.conf"
echo "  Apply:   sudo systemctl restart keyd"
echo "  Test:    keyd monitor"
echo ""
echo "  NVIDIA: after first boot run 'nvidia-smi' to confirm the"
echo "  kernel module loaded. If it fails: journalctl -b | grep -i nvidia"
echo ""
echo "  GPU detected: $GPU_INFO"
echo "================================================================"
echo ""
echo "  Full install log saved to: $LOGFILE"
echo ""
