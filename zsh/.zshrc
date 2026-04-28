########################################################################
# PATH (set before OMZ so plugins can use them)
PATH="$HOME/Programs/gitkraken:$PATH"
PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.docker/bin:$PATH"
export GOROOT="$HOME/go/sdk/go1.26.2"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
PATH="$GOROOT/bin:$GOBIN:$PATH"
PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

########################################################################
# DOCKER CLI COMPLETIONS (fpath must be set before compinit/OMZ)
fpath=($HOME/.docker/completions $fpath)

########################################################################
# TAB COMPLETION (compinit is run by oh-my-zsh; menu options set after OMZ)

########################################################################
# ZSH COMPLETION CACHE LOCATION
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump"

########################################################################
# OH MY ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
DISABLE_AUTO_TITLE="true"
source $ZSH/oh-my-zsh.sh

# OMZ unsets MENU_COMPLETE in lib/completion.zsh; re-enable it here.
# First tab shows the menu AND highlights the first match — arrows to navigate.
setopt MENU_COMPLETE
unsetopt AUTO_MENU
zstyle ':completion:*' menu select

# Put the command on a new line below the prompt
PROMPT+=$'\n'"%{$fg_bold[green]%}➜  %{$reset_color%}"

########################################################################
# CUSTOM CONFIG
source $HOME/.zshrc_custom
