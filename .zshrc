# basics
set -o vi

HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

autoload -Uz compinit
compinit

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

source /usr/share/zinit/zinit.zsh

# p10k
zinit ice depth=1
zinit light romkatv/powerlevel10k

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait"0" lucid blockf
zinit light zsh-users/zsh-completions

# keybinds

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# other
setopt promptsubst

source ~/.aliases

activate() { 
    if [ $# -eq 0 ]; then 
        . ".venv/bin/activate"
    else 
        . "$HOME/envs/$1/bin/activate"
    fi 
}

run() { "$@" & disown >/dev/null 2>&1 && exit }

workon() {
    if [ ! -d "$HOME/workspace/$1" ]; then mkdir "$HOME/workspace/$1"; fi
    cd "$HOME/workspace/$1"

    if activate "$2" >/dev/null 2>&1; then 
        if [ $# -ge 2 ]; then 
            if [ $# -ge 3 ]; then 
                run "${@:3}"
            else 
                run "${@:2}"
            fi
        fi
    else 
        if [ ! -d ".venv" ]; then 
            venv ".venv" >/dev/null 2>&1
        fi
        activate
        if [ $# -ge 2 ]; then 
            run "${@:2}"
        fi
    fi
}

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
