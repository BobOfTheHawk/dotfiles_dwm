# dwm

Modifier key is `Super` (Windows key).

---

## Apps

| Key | Action |
|---|---|
| `Super + Enter` | kitty terminal |
| `Super + D` | dmenu launcher |
| `Super + R` | Zed editor |
| `Super + E` | Thunar (floats, centered) |
| `Super + Shift + E` | yazi in kitty |
| `Super + C` | Clipboard history (clipmenu) |

---

## Screenshots

| Key | Action |
|---|---|
| `Print` | Full screenshot → saved + copied to clipboard |
| `Super + Shift + S` | Region select → saved + copied to clipboard |

Saved to `~/Screenshots/screenshot-YYYY-MM-DD_HH-MM-SS.png`

---

## Volume

| Key | Action |
|---|---|
| `Volume Up` | +5% |
| `Volume Down` | -5% |
| `Mute` | Toggle mute |
| `Mic Mute` | Toggle mic |

Uses `pactl` (PipeWire). Not ALSA.

---

## Brightness

| Key | Action |
|---|---|
| `Brightness Up` | +5% |
| `Brightness Down` | -5% |

---

## Window management

| Key | Action |
|---|---|
| `Super + Q` | Close focused window |
| `Super + Shift + Q` | Quit dwm |
| `Super + B` | Toggle status bar |
| `Super + J` | Focus next window |
| `Super + K` | Focus previous window |
| `Super + H` | Shrink master area (-5%) |
| `Super + L` | Grow master area (+5%) |
| `Super + I` | Add window to master stack |
| `Super + O` | Remove window from master stack |
| `Super + Shift + Enter` | Swap focused window into master |
| `Super + Tab` | Jump to last visited tag |
| `Super + Shift + Space` | Toggle floating for focused window |

---

## Layouts

| Key | Symbol | Description |
|---|---|---|
| `Super + T` | `[]=` | Tile (default) |
| `Super + Space` | `><>` | Floating |
| `Super + M` | `[M]` | Monocle — one window, bar visible |
| `Super + F` | — | True fullscreen — bar hidden |

Click the layout symbol in the bar to cycle between tile and monocle.

---

## Tags

| Key | Action |
|---|---|
| `Super + 1–9` | Switch to tag |
| `Super + Shift + 1–9` | Move focused window to tag |
| `Super + Ctrl + 1–9` | Toggle tag view (show multiple tags at once) |
| `Super + Ctrl + Shift + 1–9` | Assign window to additional tag |
| `Super + 0` | View all tags at once |
| `Super + Shift + 0` | Assign focused window to all tags |

qutebrowser always opens on tag 1 (set in `rules[]`).  
Thunar always floats and centers (set in `rules[]`).

---

## Monitor focus

| Key | Action |
|---|---|
| `Super + ,` | Focus previous monitor |
| `Super + .` | Focus next monitor |
| `Super + Shift + ,` | Move window to previous monitor |
| `Super + Shift + .` | Move window to next monitor |

---

## Mouse

| Action | Result |
|---|---|
| `Super + Left click drag` | Move floating window |
| `Super + Right click drag` | Resize floating window |
| `Super + Middle click` | Toggle floating |
| Click layout symbol | Cycle layout |
| Right click layout symbol | Set monocle |
| Middle click window title | Swap to master |
| Middle click status text | Open kitty |
| Click tag (bar) | Switch to tag |
| Right click tag (bar) | Toggle tag view |
| `Super + Click tag (bar)` | Move window to tag |
| `Super + Right click tag (bar)` | Toggle window on tag |

---

## Patches applied

| Patch | Effect |
|---|---|
| `hide_vacant_tags` | Empty tags don't show in the bar |
| `togglefullscr` | `Super+F` hides bar for true fullscreen |

---

## Status bar (slstatus)

Updates every 200ms. Shows CPU usage, volume, download speed, upload speed, date and time.

```
 CPU 3%    VOL 75%    ↓ 0.8 MB    ↑ 0.1 KB    Mon 15 Jun  18:42
```

To change what's shown, edit `~/slstatus/config.h` and recompile:

```bash
cd ~/slstatus
sudo make clean install
pkill slstatus && slstatus &
```

---

## Recompiling dwm

After editing `~/dwm/config.h`:

```bash
cd ~/dwm
sudo make clean install
```

Then `Super + Shift + Q` to quit, and `startx` to relaunch.
