#!/syntax/bash

require utest/assert
require utest/dsl

# Honestly, I do not have much experience in unit testing, so this code is
# probably quite below mature testing frameworks. Although, it does what
# I want from it so let it grow with my needs.

# ----------------------------------------------------------------------------
# Run the command and capture its status and streams
#
function Nails::UTest.inspect {
	__NAILS_UTEST_INSPECT=( "$@" )
	__NAILS_UTEST[stdout]=$("$@" 2>&${__NAILS_UTEST_FIFO})
	__NAILS_UTEST[status]="$?"

	local buf=''
	while read -t 0 -u ${__NAILS_UTEST_FIFO}; do
		read -N 1 -u ${__NAILS_UTEST_FIFO}
		buf+="$REPLY"
	done

	__NAILS_UTEST[stderr]="${buf%%$'\n'}"
	__NAILS_UTEST_CHECKS=( [status]='' [stdout]='' [stderr]='' )
}

# ----------------------------------------------------------------------------
# Run the test and analyze its results
#
function Nails::UTest.check {
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME id assert arg..." >&2; return 2; }
	local id="$1"
	local assert="$2"
	local fptr="Nails::UTest::Assert.$assert"
	local buf
	shift 2

	declare -F "$fptr" >/dev/null || { echo "$FUNCNAME: assertion not found: $assert" >&2; return 2; }
	if "$fptr" "$@"; then
		(( __NAILS_UTEST[current_pass] += 1 ))
		(( __NAILS_UTEST[total_pass] += 1 ))
		return 0
	fi

	(( __NAILS_UTEST[current_fail] += 1 ))
	(( __NAILS_UTEST[total_fail] += 1 ))
	printf -v buf '%q ' "$@"
	__NAILS_UTEST[assert_msgs]+="    $id $assert $buf"$'\n'
	return 1
}

# ----------------------------------------------------------------------------
# Make fifo and declare globals
#
function Nails::UTest.init {
	local tmpname=`mktemp -u`
	mkfifo "$tmpname"
	exec {__NAILS_UTEST_FIFO}<>$tmpname
	rm "$tmpname"

	declare -gA __NAILS_UTEST
#	declare -g  __NAILS_UTEST_FIFO implicitely initialized earlier
	declare -gA __NAILS_UTEST_DESC
	declare -gA __NAILS_UTEST_CHECKS
	declare -ga __NAILS_UTEST_INSPECT
}

Nails::UTest.init
