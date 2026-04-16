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
# TAB COMPLETION
autoload -U compinit && compinit
setopt MENU_COMPLETE

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

########################################################################
# CUSTOM CONFIG
source $HOME/.zshrc_custom

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
