#!/usr/bin/env bash
set -u

preamble_file=${1:-${HOME}/.claude/shell-env.sh}
vite_plus_bin="${HOME}/.local/share/vite-plus/bin"
work=$(mktemp -d)
trap 'rm -rf "${work}"' EXIT
mkdir -p "${work}/in/sub" "${work}/out"
cat > "${work}/in/mise.toml" << 'TOML'
[env]
SHELL_ENV_TEST = "on"

[tasks.check]
run = 'eval "$CHECK_DEF"; check mise-run@in'
TOML

export CHECK_DEF='check() {
	case "${PATH}" in "'"${vite_plus_bin}"':"*) order=first ;; *) order=LOST ;; esac
	case "$(command -v node)" in "'"${vite_plus_bin}"'/node") node=vite ;; *) node=OTHER ;; esac
	echo "row $1 order=${order} node=${node} env=${SHELL_ENV_TEST-unset}"
}'
export IN="${work}/in" OUT="${work}/out" MISE="${HOME}/.local/bin/mise"
export MISE_TRUSTED_CONFIG_PATHS="${work}"

cases=(
	'start|check start@in'
	'cd out and back|cd "$OUT"; check out@out; cd "$IN/sub"; check back@in'
	'pushd and popd|pushd "$OUT" >/dev/null; check pushd@out; popd >/dev/null; check popd@in'
	'cd dash|cd "$OUT"; cd - >/dev/null; check dash@in'
	'strict mode|set -eu; cd "$OUT"; check strict@out; cd "$IN"; check strict-back@in'
	'subshell|(cd "$OUT"; check subshell@out); check after-subshell@in'
	'command substitution|x=$(cd "$OUT" && check subst@out); echo "$x"; check after-subst@in'
	'cd inside a function|f() { cd "$OUT"; }; f; check function@out'
	'IFS set to colon|IFS=:; cd "$OUT"; check ifs@out'
	'failed cd|cd /nonexistent 2>/dev/null; check failed-cd@in'
	'many cds|for i in 1 2 3 4 5; do cd "$OUT"; cd "$IN"; done; check many@in'
	'child bash|cd "$OUT"; bash -c "eval \"\$CHECK_DEF\"; cd \"\$IN\"; check child-bash@any"'
	'child sh|cd "$OUT"; sh -c "eval \"\$CHECK_DEF\"; check child-sh@any"'
	'child zsh|cd "$OUT"; zsh -c "eval \"\$CHECK_DEF\"; cd \"\$IN\"; check child-zsh@any"'
	'child login bash|bash -lc "eval \"\$CHECK_DEF\"; check child-login-bash@any"'
	'child login zsh|zsh -lc "eval \"\$CHECK_DEF\"; check child-login-zsh@any"'
	'mise activated again|eval "$("$MISE" activate "$TEST_SHELL")"; check again@in; cd "$OUT"; check again-cd@out'
	'mise hook forced|eval "$("$MISE" hook-env -s "$TEST_SHELL" --force)"; check forced-hook@in'
	'mise exec|"$MISE" exec -- sh -c "eval \"\$CHECK_DEF\"; check mise-exec@any"'
	'mise run|"$MISE" run --quiet check'
)

failures=0
fail() {
	failures=$((failures + 1))
	echo "FAIL [$1] $2: $3"
}

run_as_bash_tool() {
	local shell=$1 command=$2 snapshot options line
	snapshot=$(ls -t "${HOME}"/.claude/shell-snapshots/snapshot-"${shell}"-*.sh 2>/dev/null | head -1)
	options='shopt -u extglob 2>/dev/null || true'
	[ "${shell}" = zsh ] && options='setopt NO_EXTENDED_GLOB 2>/dev/null || true'
	line="source ${snapshot:-/nonexistent} 2>/dev/null || true && $(cat "${preamble_file}")
: && ${options} && eval $(printf '%q' "eval \"\$CHECK_DEF\"; ${command}")"
	(cd "${IN}" && TEST_SHELL="${shell}" "${shell}" -c "${line}")
}

expect() {
	local shell=$1 name=$2 output=$3 row
	case "${output}" in "row "*) ;; *) fail "${shell}" "${name}" "no rows: ${output}" ;; esac
	while IFS= read -r row; do
		case "${row}" in
			"") continue ;;
			"row "*order=first*node=vite*) ;;
			*) fail "${shell}" "${name}" "${row}"; continue ;;
		esac
		case "${row}" in
			*@in\ *env=on | *@out\ *env=unset | *@any\ *) ;;
			*) fail "${shell}" "${name}" "${row}" ;;
		esac
	done <<< "${output}"
}

for shell in bash zsh; do
	command -v "${shell}" > /dev/null || { echo "skip ${shell}: not installed"; continue; }
	for entry in "${cases[@]}"; do
		expect "${shell}" "${entry%%|*}" "$(run_as_bash_tool "${shell}" "${entry#*|}" 2>&1)"
	done

	output=$(run_as_bash_tool "${shell}" 'true' 2>&1)
	[ -z "${output}" ] || fail "${shell}" "silent preamble" "${output}"
	run_as_bash_tool "${shell}" '(exit 3)' > /dev/null 2>&1
	[ $? -eq 3 ] || fail "${shell}" "exit status" "expected 3"
	echo "agent ${shell}: ${#cases[@]} cases and 2 checks run"

	interactive='eval "$CHECK_DEF"; cd "$OUT"; check interactive-out@out; cd "$IN"; check interactive-back@in'
	expect "interactive ${shell}" "cd out and back" \
		"$(cd "${IN}" && "${shell}" -i -c "${interactive}" 2> /dev/null < /dev/null | grep '^row ')"
	echo "interactive ${shell}: 1 case run"
done

if [ "${failures}" -eq 0 ]; then echo "PASS"; else echo "FAILED: ${failures}"; exit 1; fi
