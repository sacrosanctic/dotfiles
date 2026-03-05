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

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# edit line in an editor
export EDITOR='vim'
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
# set this to v on vi mode
# bindkey -M vicmd 'v' edit-command-line

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
alias keep-wake='systemd-inhibit sleep infinity'
alias rg='rg -S'
alias fman='print -l ${commands:t} | fzf | xargs man'
pkg-update() {
  # 1. Get the selections and store them in a variable
  local selected_pkgs=$(pnpm outdated --format json --silent | \
    jq -r 'to_entries[] | "\(.key) \(.value.current) -> \(.value.latest)"' | \
    column -t | \
    fzf -m --bind 'ctrl-a:select-all' --header "Tab: Select | Ctrl-A: All | Enter: Install" | \
    awk '{print $1 "@" $4}')

  # 2. Check if the selection is empty (user hit ESC or didn't select)
  if [ -n "$selected_pkgs" ]; then
    # 3. Join the packages into a single line for the log
    local install_cmd="pnpm add $(echo $selected_pkgs | xargs)"

    echo -e "\n\033[1;32mRunning:\033[0m $install_cmd\n"

    # 4. Execute the command
    eval "$install_cmd"
  else
    echo "No packages selected."
  fi
}

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
