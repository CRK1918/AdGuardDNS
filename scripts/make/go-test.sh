#!/bin/sh

# _SCRIPT_VERSION is used to simplify checking local copies of the script.  Bump
# this number every time a significant change is made to this script.
_SCRIPT_VERSION='1'
readonly _SCRIPT_VERSION

verbose="${VERBOSE:-0}"
readonly verbose

# Verbosity levels:
#   0 = Don't print anything except for errors.
#   1 = Print commands, but not nested commands.
#   2 = Print everything.
if [ "$verbose" -gt '1' ]
then
	set -x
	v_flags='-v=1'
	x_flags='-x=1'
elif [ "$verbose" -gt '0' ]
then
	set -x
	v_flags='-v=1'
	x_flags='-x=0'
else
	set +x
	v_flags='-v=0'
	x_flags='-x=0'
fi
readonly v_flags x_flags

set -e -f -u

if [ "${RACE:-1}" -eq '0' ]
then
	race_flags='--race=0'
else
	race_flags='--race=1'
fi
readonly race_flags

go="${GO:-go}"
count_flags='--count=1'
shuffle_flags='--shuffle=on'
# TODO(ameshkov): Find out, why QUIC tests are so slow, and return to 30s.
timeout_flags="${TIMEOUT_FLAGS:---timeout=60s}"
readonly go count_flags shuffle_flags timeout_flags

# TODO(a.garipov): Remove the dnsserver stuff once it is separated.
"$go" test\
	"$count_flags"\
	"$shuffle_flags"\
	"$race_flags"\
	"$timeout_flags"\
	"$x_flags"\
	"$v_flags"\
	./... github.com/AdguardTeam/AdGuardDNS/internal/dnsserver/...
