# ── Pokemon + Fastfetch (must be before instant prompt) ───
pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# ── Powerlevel10k instant prompt ──────────────────────────
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Zinit bootstrap ────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ── History ────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# ── Options ────────────────────────────────────────────────
setopt CORRECT

# ── Editor ─────────────────────────────────────────────────
export VISUAL=nvim
export EDITOR=nvim

# ── PATH & ENV ─────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export MANROFFOPT="-c"
export CM_DIR="$HOME/.cache"
export YSU_MODE=ALL
export ATUIN_KITTY_KEYBOARD_PROTOCOL=0

# ── Prompt: Powerlevel10k ──────────────────────────────────
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ── Completions ────────────────────────────────────────────
zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit

# ── Plugins ────────────────────────────────────────────────
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use
zinit light hlissner/zsh-autopair
zinit light zsh-users/zsh-syntax-highlighting  # must be last

# ── Gruvbox syntax highlight colors ───────────────────────
ZSH_HIGHLIGHT_STYLES[command]='fg=#b8bb26,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#b8bb26'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[function]='fg=#83a598'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#8ec07c'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#fb4934,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=#ebdbb2,underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#665c54,italic'
ZSH_HIGHLIGHT_STYLES[option]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#8ec07c'

# ── Autosuggest style ──────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a89984"

# ── Vi mode ────────────────────────────────────────────────
bindkey -v
KEYTIMEOUT=1

bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

function zle-keymap-select zle-line-init {
  case $KEYMAP in
    vicmd)      print -n '\e[1 q' ;;
    viins|main) print -n '\e[5 q' ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

# ── Keybinds ───────────────────────────────────────────────
bindkey -M viins '^K' _atuin_search_widget
bindkey -M viins '^J' _atuin_search_widget
bindkey -M viins '^[[A' _atuin_search_widget
bindkey -M viins '^[[B' _atuin_search_widget
bindkey -M vicmd '^K' _atuin_search_widget
bindkey -M vicmd '^J' _atuin_search_widget
bindkey -M vicmd '^[[A' _atuin_search_widget
bindkey -M vicmd '^[[B' _atuin_search_widget
bindkey -M viins '^F' autosuggest-accept

# ── Tools ──────────────────────────────────────────────────
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
source <(fzf --zsh)

# ── fzf config ─────────────────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--preview "bat --theme=gruvbox-dark --color=always {} 2>/dev/null || ls {}" --height 60% --reverse --border'

# ── Aliases ────────────────────────────────────────────────
# eza
alias l='eza --icons --group-directories-first'
alias ls='l'
alias la='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --icons --level=2 --git'
alias lta='eza --tree --icons --level=2 -a --no-permissions --no-filesize --no-user --no-time --git --ignore-glob=".git"'
alias ll='eza -l --icons --git'

# bat
alias cat='bat --theme=gruvbox-dark --style=numbers,changes,header'
alias lsblk='lsblk | bat -l conf -p --theme=gruvbox-dark'
export MANPAGER="sh -c 'col -bx | bat --theme=gruvbox-dark -l man -p'"

# git
export GIT_PAGER="delta"

# general
alias v='nvim'
alias reload='source ~/.zshrc'
alias myip='curl ifconfig.me'
alias ping='ping -c 5'
alias h='history'
alias f='fastfetch'
alias zi='zoxide query -i'
alias xcp='xclip -selection clipboard'
alias nf='nvim $(fzf --preview "bat --theme=gruvbox-dark --color=always {}")'

# ── Functions ──────────────────────────────────────────────
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

fcd() {
  local dir=$(fd --type d --hidden --exclude .git | fzf --preview 'tree -C {} 2>/dev/null || ls -F {} | head -20')
  [[ -n $dir ]] && cd "$dir"
}

fkill() {
  local pid=$(ps aux | fzf --preview 'echo {}' --preview-window=down:3:wrap | awk '{print $2}')
  [[ -n $pid ]] && kill -9 $pid
}

fh() {
  print -z $(fc -l 1 | fzf --preview-window=hidden | sed 's/ *[0-9]* *//')
}

ff() {
  local file=$(fzf)
  [[ -n $file ]] && nvim "$file"
}

fpurge() {
  local pkg=$(pacman -Q | fzf --preview 'pacman -Qi {1}' | awk '{print $1}')
  [[ -n $pkg ]] && sudo pacman -Rns $pkg
}

fins() {
  local pkg=$(pacman -Ss | fzf --preview 'pacman -Si {1}' | awk '{print $1}')
  [[ -n $pkg ]] && sudo pacman -S $pkg
}

fgit() {
  local branch=$(git branch | fzf --preview-window=hidden | sed 's/^[ *]*//')
  [[ -n $branch ]] && git checkout "$branch"
}

fstop() {
  local service=$(systemctl list-units --type=service | fzf --preview-window=hidden | awk '{print $1}')
  [[ -n $service ]] && sudo systemctl stop "$service"
}

fcat() {
  local file=$(fzf)
  [[ -n $file ]] && bat "$file"
}

fcopy() {
  local file=$(fzf)
  [[ -n $file ]] && cat "$file" | xclip -selection clipboard
}

