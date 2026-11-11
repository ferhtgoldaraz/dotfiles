. "/home/fer/.local/share/cargo/env"
if [ -r "$HOME/.config/fer-tools/gh-token" ]; then
  export GH_TOKEN="$(cat "$HOME/.config/fer-tools/gh-token")"
  export GITHUB_TOKEN="${GITHUB_TOKEN:-$GH_TOKEN}"
fi
export GIT_TERMINAL_PROMPT=0
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

. "$HOME/.config/vite-plus/env"
