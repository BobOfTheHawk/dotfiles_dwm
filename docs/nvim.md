# Neovim

Config lives in `~/.config/nvim/lua/bob/`.  
Plugin manager: lazy.nvim — auto-installs on first launch.  
Leader key: `Space`  
Colorscheme: Gruvbox (transparent background)

---

## File navigation

| Key | Action |
|---|---|
| `-` | oil.nvim — edit the current directory like a buffer |
| `leader + ee` | mini.files — floating file tree |
| `leader + pf` | Find files (fff) |
| `leader + ps` | Live grep across project |
| `leader + pr` | Recent files |
| `leader + pk` | Search keymaps |
| `leader + pt` | Search TODOs |
| `leader + pws` | Grep word under cursor |

**oil.nvim tip:** press `-` to open the parent directory. You can rename, delete, and move files by editing the buffer directly, then saving with `:w`.

---

## Harpoon

Quick-access bookmarks for files you jump between constantly.

| Key | Action |
|---|---|
| `leader + a` | Mark current file |
| `Ctrl + E` | Open harpoon menu |
| `Ctrl + Y` | Jump to slot 1 |
| `Ctrl + I` | Jump to slot 2 |
| `Ctrl + N` | Jump to slot 3 |
| `Ctrl + S` | Jump to slot 4 |

Marks persist across sessions. Put your most-used files in slots.

---

## LSP

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gR` | Show all references |
| `K` | Hover documentation |
| `leader + vca` | Code actions |
| `leader + rn` | Rename symbol |
| `leader + D` | All diagnostics in buffer (Trouble) |
| `leader + d` | Diagnostics for current line |
| `leader + f` | Format with LSP |
| `leader + mp` | Format with conform.nvim |
| `leader + rs` | Restart LSP |
| `leader + lx` | Toggle inline diagnostic text |

### Installed servers (via Mason)

`lua_ls` `ts_ls` `gopls` `cssls` `tailwindcss` `astro` `marksman` `emmet_ls` `biome` `prettier` `stylua` `pylint` `clangd`

To install more: `:Mason`

---

## Editing

### Surround (mini.surround)

| Key | Action | Example |
|---|---|---|
| `sa` | Add surround | `saiw"` → wrap word in `"` |
| `ds` | Delete surround | `ds"` → remove `"` around cursor |
| `ca` | Change surround | `ca"'` → change `"` to `'` |

### Comments (Comment.nvim)

| Key | Action |
|---|---|
| `gcc` | Toggle comment on current line |
| `gc` (visual) | Toggle comment on selection |

### Split/join (mini.splitjoin)

| Key | Action |
|---|---|
| `sj` | Split arguments onto multiple lines |
| `sk` | Join arguments onto one line |

### Other

| Key | Action |
|---|---|
| `leader + s` | Replace word under cursor globally in file |
| `leader + Y` | Yank to system clipboard |
| `leader + u` | Undotree — visual undo history |
| `leader + fp` | Copy current file path to clipboard |

---

## Splits

| Key | Action |
|---|---|
| `leader + sv` | Vertical split |
| `leader + sh` | Horizontal split |
| `leader + se` | Equalize split sizes |
| `leader + sx` | Close current split |
| `leader + sm` | Maximize / restore split (vim-maximizer) |

---

## Tabs

| Key | Action |
|---|---|
| `leader + to` | New tab |
| `leader + tx` | Close tab |
| `leader + tn` | Next tab |
| `leader + tp` | Previous tab |
| `leader + tf` | Move buffer to new tab |

---

## Git (Gitsigns + Fugitive + LazyGit)

| Key | Action |
|---|---|
| `leader + lg` | LazyGit (full TUI) |
| `leader + gs` | Stage hunk under cursor |
| `leader + gr` | Reset hunk under cursor |
| `leader + gbl` | Git blame for current line |
| `leader + gd` | Diff view |
| `]h` | Jump to next hunk |
| `[h` | Jump to previous hunk |

In Fugitive (`:G`):

| Key | Action |
|---|---|
| `s` | Stage file/hunk |
| `u` | Unstage file/hunk |
| `cc` | Commit |
| `dv` | Open diff |

---

## Folds (nvim-ufo)

| Key | Action |
|---|---|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `za` | Toggle fold under cursor |
| `zo` | Open fold |
| `zc` | Close fold |

---

## Trouble

Diagnostics panel — shows errors and warnings across files.

| Key | Action |
|---|---|
| `leader + xw` | Workspace diagnostics |
| `leader + xd` | Document diagnostics |
| `leader + xq` | Quickfix list |
| `leader + xl` | Location list |
| `leader + xt` | TODO list |

---

## Sessions (auto-session)

| Key | Action |
|---|---|
| `leader + ws` | Save session |
| `leader + wr` | Restore session |

Sessions save open buffers, splits, and tabs per working directory. Restores automatically when you open nvim in the same folder.

---

## Git worktrees

| Key | Action |
|---|---|
| `leader + wl` | List worktrees |
| `leader + wc` | Create worktree |

---

## Markdown

| Key | Action |
|---|---|
| `leader + md` | Toggle markdown preview in browser |

nvim-cmp in markdown files includes spell checking as a completion source.

---

## Linting

| Key | Action |
|---|---|
| `leader + l` | Run linter on current file |

---

## Plugin list

| Plugin | Purpose |
|---|---|
| lazy.nvim | Plugin manager |
| telescope | Fuzzy finder |
| harpoon2 | File bookmarks |
| oil.nvim | Directory editing |
| mini.files | Floating file tree |
| mini.surround | Surround operations |
| mini.splitjoin | Split/join arguments |
| nvim-cmp | Autocompletion |
| LuaSnip | Snippets |
| gopls | Go LSP |
| mason | LSP installer |
| treesitter | Syntax highlighting |
| Comment.nvim | Commenting |
| undotree | Visual undo history |
| auto-session | Session management |
| trouble | Diagnostics panel |
| vim-maximizer | Maximize splits |
| auto-pairs | Auto close brackets |
| snacks.nvim | UI utilities |
| conform.nvim | Formatter |
| lualine | Status line |
| nvim-ufo | Folds |
| todo-comments | Highlight TODOs |
| gitsigns | Git hunk signs |
| fugitive | Git integration |
| lazygit | LazyGit TUI |
| git-worktree | Worktree management |
| render-markdown | Rendered markdown in buffer |
| markdown-preview | Preview in browser |
| nvim-lint | Linting |
| fff.nvim | File finder |
| gruvbox | Colorscheme |
