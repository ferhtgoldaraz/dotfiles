. "${HOME}/.config/shell/env.sh"
. "${HOME}/.config/vite-plus/env"

[[ $- == *i* ]] || return 0

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
mise_init=$("${HOME}/.local/bin/mise" activate bash) && eval "${mise_init}"
unset mise_init

if [[ -r ${HOME}/.config/fer-tools/gh-token ]]; then
	GH_TOKEN=$(<"${HOME}/.config/fer-tools/gh-token")
	export GH_TOKEN
	export GITHUB_TOKEN=${GITHUB_TOKEN:-${GH_TOKEN}}
fi
export GIT_TERMINAL_PROMPT=0
