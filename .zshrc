ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# zinit ice depth=1

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# add in snippets
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
zinit snippet OMZP::sudo

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q


bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias r='alacritty & disown && exit'

# Shell integrations
eval "$(pnpm completion zsh)"
eval "$(direnv hook zsh)"
eval "$(gh completion -s zsh)"
eval "$(fzf --zsh)"

# https://ianthehenry.com/posts/how-to-learn-nix/nix-direnv/#fnref:1
_direnv_hook() {
  eval "$(direnv export zsh 2> >(egrep -v -e '^....direnv: export' >&2))"
};

# pnpm
export PNPM_HOME="/home/sw/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Silence the warning if NixOS appends stuff later
export _ZO_DOCTOR=0
# must be last
eval "$(zoxide init --cmd cd zsh)"

echo "\
-- QUICK KEYS --
[1mCtrl-A / E[0m : Jump Start/End
[1mCtrl-B / F[0m : Move Back/Forward
[1mCtrl-R[0m     : FZF History
[1mCtrl-N / P[0m : Suggestion Next/Prev
"
