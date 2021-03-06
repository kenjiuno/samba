#!/bin/bash

test_info()
{
    cat <<EOF
Verify CTDB's debugging of timed out eventscripts

Prerequisites:

* An active CTDB cluster with monitoring enabled

Expected results:

* When an eventscript times out the correct debugging is executed.
EOF
}

. "${TEST_SCRIPTS_DIR}/integration.bash"

set -e

ctdb_test_init "$@"

cluster_is_healthy

if [ -z "$TEST_LOCAL_DAEMONS" ] ; then
	echo "SKIPPING this test - only runs against local daemons"
	exit 0
fi

# Reset configuration
ctdb_restart_when_done

# This is overkill but it at least provides a valid test node
select_test_node_and_ips

####################

echo "Setting monitor events to time out..."
try_command_on_node $test_node 'echo $CTDB_BASE'
ctdb_base="$out"
script_options="${ctdb_base}/script.options"
ctdb_test_exit_hook_add "onnode $test_node rm -f $script_options"

debug_output="${ctdb_base}/debug-hung-script.log"
ctdb_test_exit_hook_add "onnode $test_node rm -f $debug_output"

try_command_on_node -i $test_node tee "$script_options" <<<"\
CTDB_RUN_TIMEOUT_MONITOR=yes
CTDB_DEBUG_HUNG_SCRIPT_LOGFILE=\"$debug_output\"
CTDB_DEBUG_HUNG_SCRIPT_STACKPAT='exportfs|rpcinfo|sleep'
CTDB_SCRIPT_VARDIR=\"$CTDB_BASE\""

####################

wait_for_monitor_event $test_node

echo "Waiting for debugging output to appear..."
# Use test -s because the file is created above using mktemp
wait_until 60 onnode $test_node test -s "$debug_output"

echo "Checking output of hung script debugging..."
try_command_on_node -v $test_node cat "$debug_output"

while IFS="" read pattern ; do
    if grep -- "^${pattern}\$" <<<"$out" >/dev/null ; then
	printf 'GOOD: output contains "%s"\n' "$pattern"
    else
	printf 'BAD: output does not contain "%s"\n' "$pattern"
	exit 1
    fi
done <<EOF
===== Start of hung script debug for PID=".*", event="monitor" =====
===== End of hung script debug for PID=".*", event="monitor" =====
pstree -p -a .*:
00\\\\.test\\\\.script,.* ${ctdb_base}/events/legacy/00\\\\.test\\\\.script monitor
 *\`-sleep,.*
---- Stack trace of interesting process [0-9]*\\\\[sleep\\\\] ----
[<[0-9a-f]*>] .*sleep+.*
---- ctdb scriptstatus monitor: ----
00\\.test *TIMEDOUT.*
 *OUTPUT: Sleeping for [0-9]* seconds\\\\.\\\\.\\\\.
EOF
