if [ -n "${ZSH_VERSION-}" ]; then
	typeset -gA _comps _services _patcomps _postpatcomps
	eval "$("${HOME}/.local/bin/mise" activate zsh)"
else
	eval "$("${HOME}/.local/bin/mise" activate bash)"
fi
