if [ -n "$BASH_VERSION" ]; then
    shopt -s expand_aliases
fi

if [[ $OSTYPE == darwin* ]]; then
    alias vim="mvim -v"
    alias vi="mvim -v"
    alias ls="ls -F"
    alias c="pbcopy"
else
    alias ls="ls -F --color=auto"
    alias vi="vim"
    alias rmdir="rmdir -v"
    alias python='python3'
fi
alias pip='pip3'

alias -- -="cd -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias .........="cd ../../../../../../../.."
alias l="ls"
alias la="ls -a"
alias ll="ls -lh"
alias lsd="ls -lF | grep '^d'"
alias grep="grep --color=auto"
alias mkdir="mkdir -p -v"
alias path='echo -e ${PATH//:/\\n}'
alias du='du -kh'
alias du1='du -d1 -kh'
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias df='df -H'
alias pst='ps -t `tty` $@'
alias Dc='docker-compose'
alias pstty='ps -t $(tty)'
alias setcpath='export PATH=$PATH:`pwd`'
alias a='activate'
alias py=ipython3
alias crontab="EDITOR=vim crontab"
alias yt=yt-dlp

# git aliases
alias gcl='git clone'
alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias gp='git pull -p'
alias gu='git push'
alias gb='git branch'
alias cb='git branch --show-current'
alias branch_name='git rev-parse --abbrev-ref HEAD'
alias git_root='basename $(git rev-parse --show-toplevel)'
alias gsa='git stash'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gss='git stash show -p'
alias gsw='git switch'
alias gsc='git switch -c'
alias gdt='git difftool'
alias glp='git log -p'
alias gl1='git log -1'
alias gl1p='git log -1p'
alias glf='git log -p --follow'
alias gwa='git worktree add'
alias gwrm='git worktree remove'
alias gwl='git worktree list'

[ -f ~/.local_aliases  ] && source ~/.local_aliases
