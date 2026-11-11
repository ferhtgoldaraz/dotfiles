typeset -gU PATH path

shared_env_file="${HOME}/.config/environment.d/10-shared.conf"
if [[ -r "${shared_env_file}" ]]; then
	set -a
	source "${shared_env_file}"
	set +a
fi
unset shared_env_file

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export HISTFILE="${XDG_STATE_HOME}/zsh_history"
export ZCOMPDUMP="${XDG_CACHE_HOME}/zcompdump"

export PAGER="bat"
export BAT_PAGER="less -RiFX"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
. "/home/fer/.local/share/cargo/env"

if [[ -d "${HOME}/.local/share/mise/shims" \
   && ":${PATH}:" != *":${HOME}/.local/share/mise/shims:"* ]]; then
	export PATH="${HOME}/.local/share/mise/shims:${PATH}"
fi

. "$HOME/.config/vite-plus/env"
