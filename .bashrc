#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ============================================================================
# BASH CONFIGURATION
# ============================================================================

# ----------------------------------------------------------------------------
# Prompt Configuration
# ----------------------------------------------------------------------------

_build_prompt() {
    local branch staged unstaged git_part
    local nl=$'\001' nr=$'\002' esc=$'\033'
    local rst="${nl}${esc}[0m${nr}"

    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        git diff --cached --quiet 2>/dev/null || staged=' ● '
        git diff --quiet 2>/dev/null || unstaged='  '
        git_part=" ${nl}${esc}[37m${nr}${rst} ${nl}${esc}[34m${nr}${branch}${rst}${nl}${esc}[33m${nr}${unstaged}${rst}${nl}${esc}[32m${nr}${staged}${rst}"
    fi

    PS1=" ${nl}${esc}[35m${nr}\w${rst} ${nl}${esc}[37m${nr}\t${rst}${git_part} ~ "
}
PROMPT_COMMAND='_build_prompt'

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
export PATH="$PATH:/home/joonas/.turso"

# ----------------------------------------------------------------------------
# Shell Options
# ----------------------------------------------------------------------------
shopt -s autocd          # cd by just typing directory name
shopt -s histappend      # append to history file instead of overwriting
shopt -s checkwinsize    # update LINES/COLUMNS after each command
shopt -s extglob         # extended globbing

# Share history across sessions
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }history -a; history -c; history -r"

# ----------------------------------------------------------------------------
# History
# ----------------------------------------------------------------------------
HISTFILE=~/.bash_history
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth   # ignoredups + ignorespace
HISTIGNORE="ls:cd:pwd:exit:cd*"

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
alias src='source ~/.bashrc'
alias visrc='nvim ~/.bashrc'
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
# Additional Configurations
# ----------------------------------------------------------------------------

# fzf integration (if installed)
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
