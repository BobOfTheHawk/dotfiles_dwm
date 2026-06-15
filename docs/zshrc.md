# zshrc

Shell is zsh with vi mode. Plugins managed by zinit. Prompt is Powerlevel10k.

---

## Plugins

| Plugin | What it does |
|---|---|
| zsh-autosuggestions | Suggests commands from history as you type |
| zsh-syntax-highlighting | Colors commands as you type (green = valid, red = unknown) |
| zsh-history-substring-search | Search history by substring |
| fzf-tab | Tab completion uses fzf picker |
| zsh-you-should-use | Reminds you when you type a command that has an alias |
| zsh-autopair | Auto-closes `()`, `[]`, `{}`, `""` |
| Powerlevel10k | Prompt with git status, vi mode indicator, timing |

---

## Shell keybinds

Shell is in vi mode. Press `Escape` to go to normal mode.

| Key | Mode | Action |
|---|---|---|
| `Escape` | insert | Switch to normal mode |
| `Ctrl + F` | insert | Accept autosuggestion |
| `Ctrl + J` | both | Open atuin history search |
| `Ctrl + K` | both | Open atuin history search |
| `Up arrow` | both | Open atuin history search |
| `Down arrow` | both | Open atuin history search |
| `v` | normal | Edit current command in nvim |

---

## Aliases

### Files (eza)

| Alias | Command | What it shows |
|---|---|---|
| `l` / `ls` | `eza --icons --group-directories-first` | Basic list, dirs first |
| `ll` | `eza -l --icons --git` | Long list with git status |
| `la` | `eza -la --icons --git` | Long list including hidden files |
| `lt` | `eza --tree --level=2 --git` | Tree view, 2 levels deep |
| `lta` | `eza --tree --level=2 -a ...` | Clean tree — no perms, size, user, time |

### Files (bat)

| Alias | What it does |
|---|---|
| `cat` | `bat` with gruvbox-dark theme, shows line numbers and git changes |
| `lsblk` | `lsblk` output piped through bat for readability |

Man pages also use bat: `man ls` renders with syntax highlighting.

### Navigation

| Alias | What it does |
|---|---|
| `v` | Open nvim |
| `f` | fastfetch (system info) |
| `h` | history |
| `zi` | Interactive directory jump with zoxide |
| `reload` | Reload `.zshrc` without restarting shell |

### Network

| Alias | What it does |
|---|---|
| `myip` | Shows your public IP via `curl ifconfig.me` |
| `ping` | `ping -c 5` — stops after 5 packets automatically |

### Clipboard

| Alias | What it does | Example |
|---|---|---|
| `xcp` | Pipe anything to clipboard | `pwd \| xcp`, `echo "hello" \| xcp` |

### Git

`delta` is set as the git pager — diffs are highlighted with syntax colors.

### Neovim + fzf

| Alias | What it does |
|---|---|
| `nf` | Open fzf picker → open selected file in nvim |

---

## fzf functions

All of these open an interactive fzf picker. Navigate with arrow keys, confirm with Enter, cancel with Escape.

| Function | What it does |
|---|---|
| `y` | Open yazi; when you quit, your shell cds into the directory you were in |
| `ff` | Pick a file → open in nvim |
| `fcat` | Pick a file → view with bat |
| `fcopy` | Pick a file → copy its contents to clipboard |
| `fcd` | Pick a directory → cd into it (previews contents) |
| `fkill` | Pick a running process → kill it immediately |
| `fh` | Pick from command history → paste to command line (doesn't run it) |
| `fgit` | Pick a git branch → checkout |
| `fpurge` | Pick an installed package → remove with `pacman -Rns` |
| `fins` | Pick a package from repos → install with `pacman -S` |
| `fstop` | Pick a running systemd service → stop it |

### Examples

```bash
# navigate to a deeply nested directory quickly
fcd

# you want to check what's in a config file
fcat

# copy a file's contents to paste somewhere else
fcopy

# kill a frozen app without knowing its PID
fkill

# switch git branch interactively
fgit

# remove a package you installed but don't use
fpurge
```

---

## fzf config

All fzf pickers use:

- `bat` preview with gruvbox-dark theme
- 60% height
- Reverse layout (input at top)
- Border

File search uses `fd` — respects `.gitignore` and searches hidden files.

---

## Zoxide

Smart `cd` — learns which directories you visit most.

```bash
z projects        # jump to ~/projects (or wherever you go most with that name)
z dow             # jumps to ~/Downloads if that's where you usually go
zi                # interactive picker with fzf
```

After using it for a few days it becomes very fast to navigate.

---

## Atuin

History search that replaces the default up-arrow history.

Press `Ctrl+J`, `Ctrl+K`, or the up/down arrows to open it.  
Type to filter. It searches across all your history, not just the current session.

---

## Terminal startup

Every new terminal shows a random Pokémon next to fastfetch system info. This runs before the instant prompt so it doesn't slow down the shell.

---

## History

```
HISTSIZE=10000
SAVEHIST=10000
```

History is shared across all open terminals instantly (`SHARE_HISTORY`). Duplicates are ignored (`HIST_IGNORE_DUPS`).

---

## Vi mode cursor

Cursor shape changes automatically:

- **Beam** `|` — insert mode
- **Block** `█` — normal mode
