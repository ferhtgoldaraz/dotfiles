if [ -r "$HOME/.config/shell/env.sh" ]; then
  . "$HOME/.config/shell/env.sh"
fi
if [ -r "$HOME/.config/fer-tools/gh-token" ]; then
  export GH_TOKEN="$(cat "$HOME/.config/fer-tools/gh-token")"
  export GITHUB_TOKEN="${GITHUB_TOKEN:-$GH_TOKEN}"
fi
export GIT_TERMINAL_PROMPT=0

. "$HOME/.config/vite-plus/env"
