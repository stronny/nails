#!/syntax/bash

# ----------------------------------------------------------------------------
# Sugar for common cases
#
function status: {
	Nails::UTest.check status eq? "${__NAILS_UTEST[status]}" "$1"
	__NAILS_UTEST_CHECKS[status]=$?
}

function stdout: {
	local regexp="$1"
	[[ -z "$regexp" && -s /dev/stdin ]] && regexp="$(cat)"
	Nails::UTest.check stdout match? "${__NAILS_UTEST[stdout]}" "$regexp"
	__NAILS_UTEST_CHECKS[stdout]=$?
}

function stderr: {
	local regexp="$1"
	[[ -z "$regexp" && -s /dev/stdin ]] && regexp="$(cat)"
	Nails::UTest.check stderr match? "${__NAILS_UTEST[stderr]}" "$regexp"
	__NAILS_UTEST_CHECKS[stderr]=$?
}

# ----------------------------------------------------------------------------
# Run standard checks that were not already run
#
function Nails::UTest::DSL.standard_checks {
	local check
	for check in "${!__NAILS_UTEST_CHECKS[@]}"; do
		[[ "${__NAILS_UTEST_CHECKS[$check]}" ]] && continue
		case "$check" in
			status) status: 0;;
			stdout) stdout: '';;
			stderr) stderr: '';;
		esac
	done
}

# ----------------------------------------------------------------------------
# Test functions factory
#
function result: {
	[[ -s /dev/stdin ]] || return
	local arg name
	for arg in $*; do
		if [[ "${arg:0:1}" == ':' ]]; then
			[[ "$name" ]] && { echo "$FUNCNAME: ambigous result name: $@" >&2; return 2; }
			name="${arg#:}"
		fi
	done
	[[ "$name" ]] || { echo "$FUNCNAME: failed to determine a result name: $@" >&2; return 2; }
	declare -F "__nails_utest_result_$name" >/dev/null && echo "$FUNCNAME: WARNING: result overloading: $name" >&2
	__NAILS_UTEST_DESC[$name]="$*"
	eval "function __nails_utest_result_$name {
		$(cat)
	}"
}

# ----------------------------------------------------------------------------
# Current test management
#
function expect {
	local result="${1#:}"
	local testfunc="__nails_utest_result_$result"
	shift 2

	declare -F "$testfunc" >/dev/null || { echo "$FUNCNAME: undefined result: $result" >&2; return 2; }

	Nails::UTest::DSL.close_current

	echo -n "Checking whether ${__NAILS_UTEST_DESC[$result]}: "
	__NAILS_UTEST[testfunc]="$testfunc"
	__NAILS_UTEST[current_pass]=0
	__NAILS_UTEST[current_fail]=0
	__NAILS_UTEST[current_msgs]=''
	[[ $# -gt 0 ]] && - "$@" # if there are any args, then run the test on them
}

function Nails::UTest::DSL.close_current {
	[[ "${__NAILS_UTEST[testfunc]}" ]] || return
	echo "${__NAILS_UTEST[current_pass]} pass, ${__NAILS_UTEST[current_fail]} fail"
	echo -n "${__NAILS_UTEST[current_msgs]}"
}

# ----------------------------------------------------------------------------
# Test runner
#
function - {
	[[ "${__NAILS_UTEST[testfunc]}" ]] || { echo "$FUNCNAME: no result currently expected"; return 2; }
	local saved_fail="${__NAILS_UTEST[current_fail]}"
	Nails::UTest.inspect "$@"
	__NAILS_UTEST[assert_msgs]=''
	"${__NAILS_UTEST[testfunc]}"
	Nails::UTest::DSL.standard_checks
	if (( __NAILS_UTEST[current_fail] > saved_fail )); then
		__NAILS_UTEST[current_msgs]+="  FAILED COMMAND: $@"$'\n'
		__NAILS_UTEST[current_msgs]+="${__NAILS_UTEST[assert_msgs]}"
	fi
}

# ----------------------------------------------------------------------------
# Cleanup and totals
#
function Nails::UTest::DSL.total {
	Nails::UTest::DSL.close_current
	echo "TOTAL: ${__NAILS_UTEST[total_pass]:-0} pass, ${__NAILS_UTEST[total_fail]:-0} fail"
}

trap Nails::UTest::DSL.total EXIT
