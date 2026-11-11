typeset -gU PATH path

. "${HOME}/.config/shell/env.sh"

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export HISTFILE="${XDG_STATE_HOME}/zsh_history"
export ZCOMPDUMP="${XDG_CACHE_HOME}/zcompdump"

export PAGER="bat"
export BAT_PAGER="less -RiFX"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

. "$HOME/.config/vite-plus/env"
