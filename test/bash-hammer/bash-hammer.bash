#!/usr/bin/env bash-hammer

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

result: the program writes its :version <<-'end'
	stdout: "^bash-hammer version ${__NAILS_VERSION}$"
end

result: the program detects an :invalid option <<-'end'
	status: 1
	stderr: "^bash-hammer: .+: invalid option$"
end


# ----------------------------------------------------------------------------
# Run tests
#
require version
readonly subject=bash-hammer

expect :usage from:
- $subject
- $subject ''
- $subject -h
- $subject --help

expect :version from:
- $subject -v
- $subject -V
- $subject --version

expect :invalid from $subject -?
