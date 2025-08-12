# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

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
# TAB COMPLETION
bind '"\t": menu-complete'
bind '"\e[Z": menu-complete-backward'

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
# GO
export GOPATH="$HOME/go/global"
PATH="$GOPATH/bin:$PATH"

export GOROOT="$HOME/go/go1.24.4"
PATH="$GOROOT/bin:$PATH"

export PATH

########################################################################
# HELPER FUNCTIONS

# cheat.sh
function cheat() {
  curl "https://cheat.sh/$1"
}

# use lf (Go file manager) with cd on exit
lfcd () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
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

# fzf history search - type 'his' instead of Ctrl+R
function his() {
  local selected_command
  selected_command=$(history | fzf --tac --no-sort --height=40% --reverse --query="$*" | sed 's/^[ ]*[0-9]*[ ]*//')
  if [[ -n "$selected_command" ]]; then
    # Add the command to the command line but don't execute it immediately
    # This allows the user to edit it before running
    READLINE_LINE="$selected_command"
    READLINE_POINT=${#READLINE_LINE}
  fi
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
# EDITOR
export EDITOR=hx

########################################################################
# ALIASES
# file explorers/management
alias ll='eza -laT --level 1'
alias rm='rm -rf'
alias 'cd..'='cd ..'
alias 'lf'='lfcd'
alias 'y'='yazi'
alias 'fcd'='zi'
# Notes
alias 'notes'='hx ~/Documents/notes'
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
alias "vimter"='vim -c ":terminal"'
# Go
alias "gocilint"="golangci-lint run --out-format \"colored-line-number:stdout\""
alias "gocover"="rm coverage.txt; go test -covermode=atomic -count 1 -coverpkg=./... -coverprofile=coverage.txt ./... ; go tool cover -html=coverage.txt -o coverage.html; /opt/microsoft/msedge/msedge coverage.html"
# AI
alias "ai"="ai-cli -e"
alias "aip"="ai-cli -p"
alias "aihc"="ai-cli -hc"
alias "aihp"="hx ~/.config/ai-cli/history_all_time"
alias "aie"="hx ~/bin/ai-cli" 
# alias "aimd"="ai-cli -hp | jq -r '.[-1].response' | glow"
# Kanata
alias "kan"="sudo /home/mclement/bin/kanata -q --cfg ~/.config/kanata/kanata_hjkl.kbd"

########################################################################
# NODEJS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# AUTO-SWITCH NVM
cdnvm() {
  command cd "$@" || return $?
  nvm_path="$(nvm_find_up .nvmrc | command tr -d '\n')"
  # If there are no .nvmrc file, use the default nvm version
  if [[ ! $nvm_path = *[^[:space:]]* ]]; then
    declare default_version
    default_version="$(nvm version default)"
    # If there is no default version, set it to `node`
    # This will use the latest version on your machine
    if [ $default_version = 'N/A' ]; then
      nvm alias default node
      default_version=$(nvm version default)
    fi
    # If the current version is not the default version, set it to use the default version
    if [ "$(nvm current)" != "${default_version}" ]; then
      nvm use default
    fi
  elif [[ -s "${nvm_path}/.nvmrc" && -r "${nvm_path}/.nvmrc" ]]; then
    declare nvm_version
    nvm_version=$(<"${nvm_path}"/.nvmrc)
    declare locally_resolved_nvm_version
    # `nvm ls` will check all locally-available versions
    # If there are multiple matching versions, take the latest one
    # Remove the `->` and `*` characters and spaces
    # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
    locally_resolved_nvm_version=$(nvm ls --no-colors "${nvm_version}" | command tail -1 | command tr -d '\->*' | command tr -d '[:space:]')
    # If it is not already installed, install it
    # `nvm install` will implicitly use the newly-installed version
    if [ "${locally_resolved_nvm_version}" = 'N/A' ]; then
      nvm install "${nvm_version}"
    elif [ "$(nvm current)" != "${locally_resolved_nvm_version}" ]; then
      nvm use "${nvm_version}"
    fi
  fi
}
cdnvm "$PWD" || exit

source $HOME/.bashrc_tadaweb
