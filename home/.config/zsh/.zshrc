typeset -gU cdpath fpath mailpath

path=(
    "$HOME/.local/bin"
    "$HOME/.grok/bin"
    "$CARGO_HOME/bin"
    "$GOPATH/bin"
    $path
)

/usr/bin/mkdir -p "${HISTFILE:h}" "${GNUPGHOME}"

setopt HIST_IGNORE_ALL_DUPS

bindkey -e

WORDCHARS=${WORDCHARS//[\/]}

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zstyle ':zim:completion' dumpfile "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
fpath=(~/.grok/completions/zsh $fpath)

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
source ${ZIM_HOME}/init.zsh

eval "$("$HOME/.local/bin/mise" activate zsh)"

if [[ -o interactive && -t 0 && -t 1 ]] && (( $+commands[carapace] )); then
  export CARAPACE_BRIDGES='zsh,fish,bash'
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  unalias run-help 2>/dev/null || true
  eval "$(carapace _carapace zsh 2>/dev/null)"
fi

[[ ! -f ${ZDOTDIR:-$HOME}/.p10k.zsh ]] || source ${ZDOTDIR:-$HOME}/.p10k.zsh

. "$HOME/.config/vite-plus/env"
