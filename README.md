# dotfiles

bobofthehawk's dwm setup. Minimal, fast, no bloat.  
Built on Arch Linux, X11, no display manager.

---

## Quick install

```bash
git clone https://github.com/BobOfTheHawk/dotfiles_dwm
cd dotfiles_dwm
bash install.sh
```

Then reboot or log out, and from the TTY:

```bash
startx
```

That's it. Everything is running.

---

## What install.sh does

The script runs 6 steps automatically:

**1. Packages** — installs everything via pacman  
**2. System setup** — enables NetworkManager, sets timezone to Asia/Tashkent  
**3. dwm** — clones from suckless.org, applies patches, copies config, compiles  
**4. slstatus** — clones from suckless.org, copies config, compiles  
**5. Dotfiles** — copies all configs to correct locations  
**6. Paths** — adds `~/.local/bin` to PATH  

If dwm or slstatus already exist it will update the configs and recompile instead of cloning again.

---

## Stack

| Role | Tool |
|------|------|
| Window manager | dwm 6.8 (from source) |
| Status bar | slstatus (from source) |
| Terminal | kitty |
| Browser | qutebrowser (autostarts on tag 1) |
| App launcher | dmenu |
| File manager GUI | Thunar (floats + centers) |
| File manager TUI | yazi (opens in kitty) |
| Editor | Zed |
| Compositor | picom (tearing fix only, no animations) |
| Clipboard | clipmenu (history persists across reboots) |
| Screenshots | maim + xclip |
| Polkit agent | lxpolkit (GUI root prompts) |

---

## Packages installed

```
base-devel libx11 libxft libxinerama git
dmenu kitty qutebrowser
maim xclip clipmenu
thunar yazi picom
brightnessctl lxsession
xdg-desktop-portal xdg-desktop-portal-gtk
xorg-xset xorg-xrandr xorg-xrdb xorg-xinit
networkmanager pipewire pipewire-pulse pavucontrol
wget patch
```

---

## dwm patches

Three patches are applied automatically by `install.sh`:

| Patch | How | What it does |
|-------|-----|-------------|
| `hide_vacant_tags` | `patch -p1` from suckless.org | Hides empty tags from bar |
| `togglefullscr` | Added manually to dwm.c via sed | True fullscreen — hides bar |
| `center` | Already in dwm 6.8 | Floating windows open centered |

---

## Keybindings

### Apps
| Key | Action |
|-----|--------|
| `Super + Enter` | Open kitty |
| `Super + D` | dmenu launcher |
| `Super + R` | Zed editor |
| `Super + E` | Thunar (GUI files) |
| `Super + Shift + E` | yazi (terminal files) |
| `Super + C` | Clipboard history |

### Screenshots
| Key | Action |
|-----|--------|
| `Print` | Full screenshot → save + copy to clipboard |
| `Super + Shift + S` | Region screenshot → save + copy to clipboard |

Screenshots save to `~/Screenshots/screenshot-YYYY-MM-DD_HH-MM-SS.png`

### Volume
| Key | Action |
|-----|--------|
| `Volume Up` | +5% |
| `Volume Down` | -5% |
| `Mute` | Toggle mute |
| `Mic Mute` | Toggle mic |

### Brightness
| Key | Action |
|-----|--------|
| `Brightness Up` | +5% |
| `Brightness Down` | -5% |

### Window Management
| Key | Action |
|-----|--------|
| `Super + Q` | Close window |
| `Super + Shift + Q` | Quit dwm |
| `Super + B` | Toggle bar |
| `Super + J` | Focus next window |
| `Super + K` | Focus previous window |
| `Super + H` | Shrink master |
| `Super + L` | Grow master |
| `Super + Shift + Enter` | Swap to master |
| `Super + Tab` | Last tag |
| `Super + Shift + Space` | Toggle float |

### Layouts
| Key | Action |
|-----|--------|
| `Super + T` | Tile (default) |
| `Super + Space` | Floating |
| `Super + M` | Monocle (fullscreen, bar visible) |
| `Super + F` | True fullscreen (bar hidden) |

### Tags
| Key | Action |
|-----|--------|
| `Super + 1-9` | Switch to tag |
| `Super + Shift + 1-9` | Move window to tag |
| `Super + 0` | View all tags |

---

## Status bar

Shows in the top-right. Updates every 250ms.

```
 CPU 4%    VOL 80%    ↓ 1.2 MB    ↑ 0.4 KB    Sat 14 Mar  18:17
```

Volume uses `pactl` directly because slstatus's built-in `vol_perc` uses ALSA and doesn't work with PipeWire.

---

## Autostart (xinitrc)

```bash
xrdb ~/.Xresources          # DPI (144 = 1.5x for 2560x1600)
xset r rate 300 30          # key repeat: 300ms delay, 30cps rate
xrandr --output DP-4 ...    # force 165hz
clipmenud                   # clipboard daemon
picom                       # compositor
slstatus                    # status bar
lxpolkit                    # polkit agent
xdg-desktop-portal-gtk      # file picker (needed by Zed)
qutebrowser                 # browser → lands on tag 1
exec dwm
```

---

## Repo structure

```
dotfiles/
├── README.md
├── install.sh                   ← run this
├── dwm/
│   └── config.h                 ← keybinds, rules, colors
├── slstatus/
│   └── config.h                 ← bar: CPU, VOL, net, time
├── home/
│   ├── .xinitrc                 ← autostart
│   └── .Xresources              ← DPI scaling
├── config/
│   └── picom/
│       └── picom.conf           ← vsync only
└── scripts/
    └── zed-launch.sh            ← kills orphan zed before launch
```

---

## After install — things to adjust for a different machine

| File | What to change |
|------|---------------|
| `home/.xinitrc` | `xrandr` line — monitor output name and resolution |
| `slstatus/config.h` | `wlan0` → `enp109s0` if on ethernet |
| `dwm/config.h` | `/home/bobofthehawk/` paths in screenshot commands |

To find your monitor output name:
```bash
xrandr | grep " connected"
```

To find your network interface:
```bash
ip link show | grep -E "^[0-9]"
```

---

## Rebuilding after config changes

**dwm:**
```bash
cd ~/dwm
# edit config.h
sudo make clean install
Super+Shift+Q   # quit dwm
startx          # relaunch
```

**slstatus:**
```bash
cd ~/slstatus
# edit config.h
sudo make clean install
# kills and restarts automatically on next startx
# or kill it and rerun: pkill slstatus && slstatus &
```

---

## Known quirks

**Volume shows n/a** — happens if PipeWire isn't running. Start it: `systemctl --user start pipewire pipewire-pulse`

**Zed opens invisible** — the wrapper script `zed-launch.sh` handles this by killing the orphan `/usr/lib/zed/zed-editor` process before relaunching.

**WiFi doesn't connect on boot** — run `sudo systemctl enable NetworkManager` if you skipped the installer.

**Key repeat too slow/fast** — change `xset r rate 300 30` in `~/.xinitrc`. First number = delay (ms), second = repeat speed (chars/sec).
