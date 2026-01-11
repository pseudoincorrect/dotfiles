# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=50000
export HISTFILE=~/.bash_history

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

########################################################################
# Custom prompt
PS1=' \[\033[01;36m\]\W\[\033[00m\] $ '

########################################################################
# TITLE AS CURRENT DIRECTORY
# Function to set the terminal title
set_window_title_cwd() {
  # Extract the last folder name of the current working directory
  local dir_name="${PWD##*/}"
  # Use escape sequences to set the terminal title
  echo -ne "\033]0;${dir_name}\007"
}
PROMPT_COMMAND="set_window_title_cwd"

########################################################################
# SET TERMINAL TITLE MANUALLY
function st() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}

########################################################################
# TAB COMPLETION
# Only set up key bindings in interactive shells
if [[ $- == *i* ]]; then
  # Enable system bash completion if available
  if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
      . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
      . /etc/bash_completion
    fi
  fi

  # Enhanced completion settings
  bind 'set completion-ignore-case on'
  bind 'set completion-map-case on'
  bind 'set show-all-if-ambiguous off'
  bind 'set show-all-if-unmodified off'
  bind 'set menu-complete-display-prefix on'
  bind 'set colored-completion-prefix on'
  bind 'set colored-stats on'
  bind 'set visible-stats on'
  bind 'set mark-symlinked-directories on'
  bind 'set match-hidden-files off'
  # Key bindings for menu completion
  bind '"\t": menu-complete'
  bind '"\e[Z": menu-complete-backward'
  # History search with arrows
  bind '"\e[A": history-search-backward'
  bind '"\e[B": history-search-forward'
  # Normal history navigation with ctrl+arrows
  bind '"\e[1;5A": previous-history'
  bind '"\e[1;5B": next-history'
  # Ctrl+Backspace to delete previous word
  bind '"\C-h": backward-kill-word'
fi

########################################################################
# HOMEBREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

########################################################################
# PATH and other export
PATH="$HOME/Programs/gitkraken:$PATH"
PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"

########################################################################
# RUST
. "$HOME/.cargo/env"

########################################################################
# GO (managed by goenv)
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

# Install and use Go version from go.mod
gouse() {
  local go_mod="${1:-go.mod}"
  if [[ ! -f "$go_mod" ]]; then
    echo "Error: $go_mod not found"
    return 1
  fi
  local version
  version=$(grep -E '^go [0-9]+\.[0-9]+' "$go_mod" | awk '{print $2}')
  if [[ -z "$version" ]]; then
    echo "Error: Could not parse Go version from $go_mod"
    return 1
  fi
  echo "Installing and using Go $version..."
  goenv install "$version" --skip-existing
  goenv local "$version"
}

########################################################################
# HELPER FUNCTIONS

# cheat.sh
function cheat() {
  curl "https://cheat.sh/$1"
}

# use Yazi and exit on cd
function ycd() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# fzf history search - type 'his' instead of Ctrl+R (same as CTRL+R but with edit prompt)
function his() {
  local selected_command
  selected_command=$(fc -ln 1 | fzf --scheme=history --no-sort --height=40% --reverse --query="$*" --tiebreak=index --tac)
  if [[ -n "$selected_command" ]]; then
    read -e -i "$selected_command" -p "› " cmd
    if [[ -n "$cmd" ]]; then
      eval "$cmd"
      history -s "$cmd"
    fi
  fi
}

# fcd - fuzzy find directory and cd into it (like fzf alt-c)
function fcd() {
  local dir
  dir=$(fd --type d --strip-cwd-prefix --hidden --follow --exclude .git . | fzf --height=40% --reverse)
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

# deduplicate bash history file
function history_deduplicate() {
  local before=$(wc -l <~/.bash_history)
  tac ~/.bash_history | awk '!seen[$0]++' | tac >~/.bash_history.tmp && mv ~/.bash_history.tmp ~/.bash_history
  local after=$(wc -l <~/.bash_history)
  echo "History deduplication: from $before --> $after lines."
}

########################################################################
# ZOXIDE (FILE EXPLORER)
eval "$(zoxide init bash)"

########################################################################
# BROOT (FILE EXPLORER)
source $HOME/.config/broot/launcher/bash/br

########################################################################
# FUZZY SEARCH FZF
eval "$(fzf --bash)"
export FZF_DEFAULT_COMMAND='fd --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'

# Use fd for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

#######################################################################
# THEFUCK
eval $(thefuck --alias)

#######################################################################
# EDITOR
export EDITOR=nvim

########################################################################
# ALIASES
# file explorers/management
alias ll='eza -laT --level 1'
alias rm='rm -rf'
alias 'cd..'='cd ..'
alias 'lf'='lfcd'
alias 'y'='yazi'
# Notes
alias 'notes'='$EDITOR ~/Documents/notes'
# Clear the swap storage
alias 'clearswap'='sudo swapoff -a; sudo swapon -a'
# make python3 as default
alias 'python'='python3'
alias 'sourcevenv'='source .venv/bin/activate'
# edit .bashrc
alias "editrc"="$EDITOR ~/.bashrc"
alias "sourcerc"="source ~/.bashrc"
alias "catrc"="cat ~/.bashrc"
# docker compose
alias 'dc'='docker compose'
# solaar logitech
alias "solaarnohup"="nohup ~/.local/bin/solaar --window=hide &"
# bluetooth battery level
alias "bluetoothbattery"="bluetoothctl info | grep Battery"
# Vim
alias "vim"="nvim"
alias "neovide-nohup"="nohup neovide . >/dev/null 2>&1 &"
# Go
alias "gocilint"="golangci-lint run --out-format \"colored-line-number:stdout\""
alias "gocover"="rm coverage.txt; go test -covermode=atomic -count 1 -coverpkg=./... -coverprofile=coverage.txt ./... ; go tool cover -html=coverage.txt -o coverage.html; /opt/microsoft/msedge/msedge coverage.html"
# AI
alias "danger"="claude --dangerously-skip-permissions"
alias "plan"="claude --permission-mode plan"
# Kanata
alias "kan"="sudo /home/mclement/bin/kanata -q --cfg ~/git/dotfiles/kanata/kanata_hjkl.kbd"

########################################################################
# NODEJS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

source $HOME/.bashrc_tadaweb

########################################################################
# STARSHIP PROMPT
eval "$(starship init bash)"
