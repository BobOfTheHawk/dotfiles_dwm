# keyd

A kernel-level (evdev) key remapper. Runs as a systemd service, so it works identically in dwm, a bare TTY, or anything else — unlike `xmodmap`/`.xinitrc`, which only ever worked under X11.

Config lives at `etc/keyd/default.conf` in this repo and is installed by `install.sh` to `/etc/keyd/default.conf`.

---

## Why

A cluster of symbols heavily used in C/shell/Neovim — `() [] {} - _ = + \ | ' "` — all sit at the right edge of a standard QWERTY board, overworking the right pinky. This layer moves them onto the right hand's index/middle row instead.

---

## Layout

| Key | Behavior |
|---|---|
| `Caps Lock` (tap) | `Esc` |
| `Left Alt` (tap) | Normal `Alt` — dwm's Alt-based bindings still work |
| `Left Alt` (hold) | Activates the `symbols` layer below |
| `Right Alt` | Completely untouched, normal `Alt` |

### Symbol layer (hold Left Alt +)

| Key | Produces |
|---|---|
| `j` | `(` |
| `k` | `)` |
| `u` | `[` |
| `i` | `]` |
| `n` | `{` |
| `m` | `}` |
| `h` | `-` |
| `l` | `=` |
| `y` | `\` |
| `o` | `\|` |
| `p` | `"` |
| `,` | `'` |

> `,` was picked for single-quote because it's a middle/ring-finger key on the home block — `;` and `/` were also free, but both are pinky keys, which defeats the point of this layer.

---

## Editing / testing

```bash
sudo nvim /etc/keyd/default.conf   # edit
sudo systemctl restart keyd        # apply
keyd monitor                       # live-test keystrokes
```

If you edit the config, remember to also update `etc/keyd/default.conf` in this repo — `install.sh` overwrites `/etc/keyd/default.conf` from that file on every run, so local-only edits to `/etc/keyd/default.conf` will be silently reverted (a backup is taken first, at `/etc/keyd/default.conf.bak`).

---

## Gotcha already hit once

`pipe` and `quote` are **not** valid keyd identifiers — using them silently does nothing (no error). Use modifier syntax instead: `S-backslash` for `|`, `S-apostrophe` for `"`.
