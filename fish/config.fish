if status is-interactive
    # Commands to run in interactive sessions can go here
end
########################################################################
# HOMEBREW
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

########################################################################
# PATH and other export
set -x PATH $HOME/Programs/gitkraken $PATH
set -x PATH $HOME/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH

########################################################################
# GO (managed by goenv)
set -x GOENV_ROOT $HOME/.goenv
set -x PATH $GOENV_ROOT/bin $PATH
status --is-interactive; and source (goenv init - | psub)

# Install and use Go version from go.mod
function goenv-use
    set -l go_mod (test -n "$argv[1]"; and echo $argv[1]; or echo "go.mod")
    if not test -f "$go_mod"
        echo "Error: $go_mod not found"
        return 1
    end
    set -l version (grep -E '^go [0-9]+\.[0-9]+' "$go_mod" | awk '{print $2}')
    if test -z "$version"
        echo "Error: Could not parse Go version from $go_mod"
        return 1
    end
    echo "Installing and using Go $version..."
    goenv install "$version" --skip-existing
    goenv local "$version"
end

########################################################################
# HELPER FUNCTIONS

# fzf history search - type 'his' instead of Ctrl+R
function his
    set -l cmd (history | fzf --no-sort --height=40% --reverse --query="$argv")
    if test -n "$cmd"
        read -P "› " -c "$cmd" edited_cmd
        if test -n "$edited_cmd"
            eval $edited_cmd
        end
    end
end

# cheat.sh
function cheat
    curl "https://cheat.sh/$argv"
end

# use Yazi and exit on cd
function ycd
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file=$tmp
    set cwd (cat $tmp)
    if test -n "$cwd" -a "$cwd" != "$PWD"
        cd $cwd
    end
    rm -f $tmp
end

########################################################################
# ZOXIDE (FILE EXPLORER)
zoxide init fish | source

########################################################################
# FUZZY SEARCH FZF
fzf --fish | source
set -x FZF_DEFAULT_COMMAND 'fd --strip-cwd-prefix --hidden --follow --exclude .git'
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_ALT_C_COMMAND 'fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'

########################################################################
# EDITOR
set -x EDITOR nvim

########################################################################
# ALIASES
# file explorers/management
alias ll "eza -laT --level 1"
alias rm "rm -rf"
alias "cd.." "cd .."
alias y yazi
alias cd z
alias fcd zi
# Notes
alias notes "$EDITOR ~/Documents/notes"
# Clear the swap storage
alias clearswap "sudo swapoff -a; sudo swapon -a"
# make python3 as default
alias python python3
alias sourcevenv "source .venv/bin/activate.fish"
# edit config files
alias editrc "$EDITOR ~/.config/fish/config.fish"
alias sourcerc "source ~/.config/fish/config.fish"
alias catrc "cat ~/.config/fish/config.fish"
# docker compose
alias dc "docker compose"
# solaar logitech
alias solaarnohup "nohup ~/.local/bin/solaar --window=hide &"
# bluetooth battery level
alias bluetoothbattery "bluetoothctl info | grep Battery"
# Vim
alias vim nvim
# Go
alias gocilint "golangci-lint run --out-format 'colored-line-number:stdout'"
alias gocover "rm coverage.txt; go test -covermode=atomic -count 1 -coverpkg=./... -coverprofile=coverage.txt ./... ; go tool cover -html=coverage.txt -o coverage.html; /opt/microsoft/msedge/msedge coverage.html"
# AI
alias danger "claude --dangerously-skip-permissions"
alias plan "claude --permission-mode plan"
# Kanata
alias kan "sudo /home/mclement/bin/kanata -q --cfg ~/git/dotfiles/kanata/kanata_hjkl.kbd"

########################################################################
# TADAWEB CONFIG
source $HOME/.config/fish/config_tadaweb.fish

########################################################################
# THEFUCK
thefuck --alias | source

########################################################################
# NVM (managed by fisher - auto-initialized via conf.d/nvm.fish)

########################################################################
# STARSHIP PROMPT
starship init fish | source
