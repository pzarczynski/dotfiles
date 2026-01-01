# basics
set -o vi

HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

autoload -Uz compinit
compinit

source /usr/share/zinit/zinit.zsh

if [[ -o interactive ]]; then
    fastfetch
fi

# p10k
zinit ice depth=1
zinit light romkatv/powerlevel10k

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait"0" lucid blockf
zinit light zsh-users/zsh-completions

# other
setopt promptsubst

source ~/.aliases
