#!/syntax/bash

# ----------------------------------------------------------------------------
# Strings
#
function Nails::UTest::Assert.empty? {
	[[ $# -lt 1 ]] && { echo "usage: $FUNCNAME string" >&2; return 2; }
	[[ -z "$1" ]]
}

function Nails::UTest::Assert.equal? {
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME string1 string2" >&2; return 2; }
	[[ "$1" = "$2" ]]
}

function Nails::UTest::Assert.before? {
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME string1 string2" >&2; return 2; }
	[[ "$1" < "$2" ]]
}

function Nails::UTest::Assert.after? {
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME string1 string2" >&2; return 2; }
	[[ "$1" > "$2" ]]
}

function Nails::UTest::Assert.match? {
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME string regexp" >&2; return 2; }
	[[ "$1" =~ $2 ]]
}

# ----------------------------------------------------------------------------
# Integers
#
function Nails::UTest::Assert.eq? { # a == b
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME integer integer" >&2; return 2; }
	[[ "$1" -eq "$2" ]]
}

function Nails::UTest::Assert.lt? { # a < b
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME integer integer" >&2; return 2; }
	[[ "$1" -lt "$2" ]]
}

function Nails::UTest::Assert.le? { # a <= b
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME integer integer" >&2; return 2; }
	[[ "$1" -le "$2" ]]
}

function Nails::UTest::Assert.gt? { # a > b
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME integer integer" >&2; return 2; }
	[[ "$1" -gt "$2" ]]
}

function Nails::UTest::Assert.ge? { # a >= b
	[[ $# -lt 2 ]] && { echo "usage: $FUNCNAME integer integer" >&2; return 2; }
	[[ "$1" -ge "$2" ]]
}
