#!/syntax/bash

require utest

# ----------------------------------------------------------------------------
# Define expectations
#
result: the program writes its :usage <<-'end'
	stdout: <<-'EOF'
		^Usage: bash-hammer filename \[arguments\]
		       This program is not intended to be run directly\.
		       Please look inside to find out more\.$
	EOF
end

result: the program detects an :invalid option <<-'end'
	status: 1
	stderr: "^bash-hammer: .+: invalid option$"
end


# ----------------------------------------------------------------------------
# Run tests
#
function subject { "${__NAILS_CURRENT[:path]}/bin/bash-hammer" "$@"; }

expect :usage from:
- subject
- subject ''
- subject -h
- subject --help

expect :invalid from subject -?
