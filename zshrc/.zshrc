ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure
# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma-continuum/history-search-multi-word

# Two regular plugins loaded without investigating.
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light Aloxaf/fzf-tab

#zinit snippet OMZP::git
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

eval "$(fzf --zsh)"

autoload -Uz compinit && compinit

zinit cdreplay -g

export GPG_TTY=$(tty)
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export ASDF_DATA_DIR="$HOME/asdf_datadir"
# append completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
eval "$(direnv hook zsh)"


alias ls="ls --color"
alias cdl="cd ~/code/github.com/lablabs/"
alias cdt="cd ~/code/github.com/lablabs/tf-infra"
alias cdo="cd ~/code/github.com/lablabs/tf-org"

# TF
function tfplan () {
  TF_PLAN_DIR=$HOME/.terraform.d/tf_plan_viz
  terraform plan $@ -out $TF_PLAN_DIR/tfplan;
  terraform show -json $TF_PLAN_DIR/tfplan > $TF_PLAN_DIR/tfplan.json;
  tf-summarize $TF_PLAN_DIR/tfplan.json;
}

alias tf="terraform"
alias tfi="terraform init"
alias tfa="terraform apply"
alias tfap="terraform apply --auto-approve"

# Git
alias ga="git add"
alias gs="git status"
alias gpl="git pull origin"
alias gc="git commit -S -m"
alias gcam="git commit -S --amend"
alias gca="git commit -aSm"
alias gp="git push origin"
alias gbc="git checkout -b"
alias gb="git branch"

export AWS_CONFIG_FILE=~/.aws/config

# Argo
alias arglog="argocd login --sso --grpc-web"
alias argapp="argocd app list"
alias argget="argocd app get"
alias argappsyn="argocd app sync --prune"
[[ $commands[kubectl] ]] && source <(kubectl completion zsh) # add autocomplete permanently t


