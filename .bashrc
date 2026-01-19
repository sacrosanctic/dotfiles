eval "$(pnpm completion bash)"
eval "$(direnv hook bash)"
eval "$(gh completion -s bash)"
eval "$(fzf --bash)"

# https://ianthehenry.com/posts/how-to-learn-nix/nix-direnv/#fnref:1
_direnv_hook() {
  eval "$(direnv export bash 2> >(egrep -v -e '^....direnv: export' >&2))"
};

# pnpm start
# created by `pnpm setup`
export PNPM_HOME="/home/sw/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Silence the warning if NixOS appends stuff later
export _ZO_DOCTOR=0
# must be last
eval "$(zoxide init --cmd cd bash)"
