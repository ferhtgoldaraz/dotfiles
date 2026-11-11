if [[ -r ${HOME}/.config/environment.d/10-shared.conf ]]; then
	set -a
	. "${HOME}/.config/environment.d/10-shared.conf"
	set +a
fi

prepend_path() {
	if [[ -d $1 && :${PATH}: != *":$1:"* ]]; then
		PATH=$1:${PATH}
	fi
}
prepend_path "${GOPATH}/bin"
prepend_path "${HOME}/.grok/bin"
prepend_path "${HOME}/.local/share/mise/shims"
export PATH

. "${HOME}/.local/share/cargo/env"
prepend_path "${HOME}/.local/bin"
unset -f prepend_path
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
