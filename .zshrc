# ============================================================================
# ZSH CONFIGURATION
# ============================================================================

# ----------------------------------------------------------------------------
# Prompt Configuration
# ----------------------------------------------------------------------------
setopt PROMPT_SUBST
autoload -Uz vcs_info

precmd() { 
    vcs_info
}

# Git configuration
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%F{blue}%b%f%F{yellow}%u%f%F{green}%c%f'
zstyle ':vcs_info:git:*' actionformats '%F{blue}%b%f|%F{red}%a%f %F{yellow}%u%f%F{green}%c%f'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '●'
zstyle ':vcs_info:git:*' unstagedstr '✗'

# Prompts
PROMPT='%f %F{magenta}%~%f %: '
RPROMPT='%F{white}%T%f${vcs_info_msg_0_:+ %F{white} %f ${vcs_info_msg_0_}'

# ----------------------------------------------------------------------------
# Environment
# ----------------------------------------------------------------------------
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export BROWSER='firefox'

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# ----------------------------------------------------------------------------
# Shell Options
# ----------------------------------------------------------------------------
setopt AUTO_CD                 # cd by just typing directory name
setopt CORRECT                 # command correction
setopt INTERACTIVE_COMMENTS    # allow comments in interactive mode
setopt APPEND_HISTORY          # append to history file
setopt SHARE_HISTORY           # share history across sessions
setopt HIST_IGNORE_DUPS        # don't record duplicate entries
setopt HIST_IGNORE_SPACE       # don't record commands starting with space
setopt HIST_REDUCE_BLANKS      # remove superfluous blanks
setopt EXTENDED_GLOB           # extended globbing
setopt NO_BEEP                 # no beeping

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"

# ----------------------------------------------------------------------------
# Completion
# ----------------------------------------------------------------------------
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Menu-style completion
zstyle ':completion:*' menu select

# Auto-description for options
zstyle ':completion:*:options' description 'yes'

# ----------------------------------------------------------------------------
# Aliases - Navigation
# ----------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# ----------------------------------------------------------------------------
# Aliases - Eza (ls replacement)
# ----------------------------------------------------------------------------
alias ls='eza --icons --group-directories-first'
alias l='eza -l --icons --git --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first'
alias ld='eza -D --icons'
alias lf='eza -f --icons'
alias lt='eza -la --tree --icons --level=2'
alias lt3='eza --tree --icons --level=3'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'

# ----------------------------------------------------------------------------
# Aliases - Utilities
# ----------------------------------------------------------------------------
alias cls='clear'
alias c='clear'
alias h='history'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias mkdir='mkdir -pv'
alias df='df -h'
alias free='free -h'

# ----------------------------------------------------------------------------
# Aliases - Pacman & Yay
# ----------------------------------------------------------------------------
alias pacup='sudo pacman -Syu'
alias yayup='yay -Syu'
alias p='sudo pacman'
alias pup='sudo pacman -Syu'
alias pupp='sudo pacman -Syyuu'
alias pins='sudo pacman -S'
alias prem='sudo pacman -Rns'
alias pss='pacman -Ss'
alias pls='pacman -Q'
alias pqs='pacman -Qs'
alias pinfo='pacman -Qi'
alias punlock='sudo rm /var/lib/pacman/db.lck'
alias pclean='sudo pacman -Rns $(pacman -Qdtq) 2>/dev/null || echo "No orphaned packages"'

alias y='yay'
alias yup='yay -Syu'
alias yins='yay -S'
alias yss='yay -Ss'
alias yrem='yay -Rns'
alias yclean='yay -Sc && yay -Yc'

# ----------------------------------------------------------------------------
# Aliases - Git
# ----------------------------------------------------------------------------
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gl='git log --oneline --graph --decorate'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# ----------------------------------------------------------------------------
# Aliases - Config
# ----------------------------------------------------------------------------
alias dotfiles='git --git-dir="$HOME/Repository/arch-profile/.git" --work-tree="$HOME"'
alias src='source ~/.zshrc'
alias visrc='nvim ~/.zshrc'
alias vinit='nvim ~/.config/nvim/init.lua'

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1"      ;;
            *.tar.xz)    tar xf "$1"    ;;
            *.tar.zst)   tar --zstd -xf "$1" ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Make and cd into directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick find
qf() {
    find . -name "*$1*"
}

# Better history search
hg() {
    history | grep "$1"
}

# Quick backup
bak() {
    cp "$1" "$1.bak_$(date +%Y%m%d_%H%M%S)"
}

# Get current IP
myip() {
    curl -s https://api.ipify.org && echo
}

# ----------------------------------------------------------------------------
# Zinit Plugin Manager
# ----------------------------------------------------------------------------
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load plugins
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    lukechilds/zsh-nvm

# Additional useful plugins (uncomment to enable):
# zinit light zdharma-continuum/fast-syntax-highlighting  # faster syntax highlighting
# zinit light zsh-users/zsh-history-substring-search      # fish-like history search
# zinit light agkozak/zsh-z                               # jump to frequent directories

# ----------------------------------------------------------------------------
# Key Bindings
# ----------------------------------------------------------------------------
# Use emacs keybindings (or 'bindkey -v' for vim mode)
bindkey -e

# Ctrl+Arrow to move by word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ----------------------------------------------------------------------------
# Additional Configurations
# ----------------------------------------------------------------------------

# fzf integration (if installed)
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Turso
export PATH="$PATH:/home/joonas/.turso"

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
