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

# fzf history search - type 'his' instead of Ctrl+R (same as CTRL+R but with edit prompt)
function his
    set -l cmd (history -z | fzf --read0 --scheme=history --no-sort --height=40% --reverse --query="$argv" --tiebreak=index)
    if test -n "$cmd"
        read -P "› " -c "$cmd" edited_cmd
        if test -n "$edited_cmd"
            # Add command to history
            printf '- cmd: %s\n  when: %d\n' "$edited_cmd" (date +%s) >> ~/.local/share/fish/fish_history
            history merge
            eval $edited_cmd
        end
    end
end

# fcd - fuzzy find directory and cd into it (like fzf alt-c)
function fcd
    set -l dir (fd --type d --strip-cwd-prefix --hidden --follow --exclude .git . | fzf --height=40% --reverse)
    if test -n "$dir"
        cd "$dir"
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

# set terminal/tab title (use `st` alias)
function set_title --description "Set the terminal/tab title"
    if test (count $argv) -eq 0
        set -e __custom_terminal_title
        echo "Title reset to default"
    else
        set -g __custom_terminal_title "$argv"
        printf '\033]0;%s\007' "$argv"
    end
end

# fish_title is called on each prompt to set terminal title
# without it, starship would override our custom title
function fish_title
    if set -q __custom_terminal_title
        echo $__custom_terminal_title
    else
        echo (status current-command) (__fish_pwd)
    end
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
alias neovide-nohup "setsid -f neovide . >/dev/null 2>&1"
# Go
alias gocilint "golangci-lint run --out-format 'colored-line-number:stdout'"
alias gocover "rm coverage.txt; go test -covermode=atomic -count 1 -coverpkg=./... -coverprofile=coverage.txt ./... ; go tool cover -html=coverage.txt -o coverage.html; /opt/microsoft/msedge/msedge coverage.html"
# AI
alias danger "claude --dangerously-skip-permissions"
alias plan "claude --permission-mode plan"
# Kanata
alias kan "sudo /home/mclement/bin/kanata -q --cfg ~/git/dotfiles/kanata/kanata_hjkl.kbd"
# Terminal title
alias st set_title

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
