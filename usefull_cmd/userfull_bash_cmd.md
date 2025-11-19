# Usefull Bash command
    
## Sort vscode keybindings by the key named "key"
jq 'sort_by(.key)' "/home/mclement/.config/Code/User/keybindings.json" > "/tmp/sorted_keybindings.json" && mv "/tmp/sorted_keybindings.json" /home/mclement/.config/Code/User/keybindings.json ; cp ~/.config/Code/User/keybindings.json ~/git/dotfiles/vscode/

## Sort vscode settings
jq -S . "/home/mclement/.config/Code/User/settings.json" >"/tmp/sorted_settings.json" && mv "/tmp/sorted_settings.json" /home/mclement/git/dotfiles/vscode/settings.json