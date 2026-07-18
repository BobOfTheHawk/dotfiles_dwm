# dotfiles_dwm

Minimal dwm setup for Arch Linux — keyboard-driven, no display manager, one-command install.

```bash
git clone https://github.com/BobOfTheHawk/dotfiles_dwm
cd dotfiles_dwm
bash install.sh
```

Then reboot and type `startx` from the TTY.

---

## Stack

| Role | Tool |
|---|---|
| Window manager | dwm (compiled from source, pre-patched) |
| Status bar | slstatus (compiled from source) |
| Terminal | kitty |
| Shell | zsh + zinit + Powerlevel10k |
| Browser | qutebrowser (config tracked in `config/qutebrowser/`, mirrored from [BobOfTheHawk/qutebrowser](https://github.com/BobOfTheHawk/qutebrowser)) |
| Launcher | dmenu |
| File manager | yazi (TUI) / Thunar (GUI, floats) |
| Editor | Neovim (lazy.nvim) |
| Compositor | picom |
| Clipboard | clipmenu |
| Screenshots | maim + xclip |
| Key remapping | keyd (kernel-level, evdev) |

---

## Docs

| File | What it covers |
|---|---|
| [docs/dwm.md](docs/dwm.md) | All keybinds, layouts, tags, mouse, bar |
| [docs/nvim.md](docs/nvim.md) | Full Neovim guide — plugins, keybinds, LSP |
| [docs/zshrc.md](docs/zshrc.md) | Aliases, fzf functions, shell keybinds |
| [docs/keyd.md](docs/keyd.md) | Caps→Esc, Alt-hold symbol layer, editing/testing |

---

## After install

Every run writes a full transcript to `~/.local/share/dotfiles-install-logs/install-<timestamp>.log` — check there first if a step fails; `install.sh` will also print the exact section, line, and command that broke on any failure.

Adjust these for your machine:

- `~/.xinitrc` — change the `xrandr` line to match your monitor output and resolution
- `~/slstatus/config.h` — network interface is auto-detected, but verify with `ip link show`

To find your monitor name: `xrandr | grep " connected"`
