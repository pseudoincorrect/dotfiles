########################################################################
# PATH (set before OMZ so plugins can use them)
PATH="$HOME/Programs/gitkraken:$PATH"
PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.docker/bin:$PATH"
export GOROOT="$HOME/go/sdk/go1.26.1"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
PATH="$GOROOT/bin:$GOBIN:$PATH"
PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# PATH="$PATH:$HOME/.local/share/mise/shims"

########################################################################
# HISTORY
HISTSIZE=10000
SAVEHIST=50000
export HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

########################################################################
# DOCKER CLI COMPLETIONS (fpath must be set before compinit/OMZ)
fpath=($HOME/.docker/completions $fpath)

########################################################################
# TAB COMPLETION
autoload -U compinit && compinit
setopt MENU_COMPLETE

########################################################################
# OH MY ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
DISABLE_AUTO_TITLE="true"
source $ZSH/oh-my-zsh.sh


export MISE_STATE_DIR="$HOME/.mise/state",
eval "$(mise activate zsh)"  # or bash

########################################################################
# CUSTOM CONFIG
source $HOME/.zshrc_base
