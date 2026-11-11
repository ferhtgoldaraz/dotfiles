if test -r "${HOME}/.config/environment.d/10-shared.conf"; then
	set -a
	. "${HOME}/.config/environment.d/10-shared.conf"
	set +a
fi

user_path=
for dir in \
	"${HOME}/.local/share/vite-plus/bin" \
	"${HOME}/.local/share/mise/shims" \
	"${HOME}/.local/bin" \
	"${HOME}/.grok/bin" \
	"${CARGO_HOME:-${HOME}/.cargo}/bin" \
	"${GOPATH:-${HOME}/go}/bin"; do
	case ":${PATH}:" in
	*":${dir}:"*) ;;
	*) user_path="${user_path}${dir}:" ;;
	esac
done
PATH="${user_path}${PATH}"
unset user_path dir
export PATH
