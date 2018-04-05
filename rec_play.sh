# Recording a session with script
# 2018-02-06 uwe: rec - record session with script and timestamps
rec () {
    local now=$(/bin/date +%Y-%m-%d_%H:%M:%S);
    local fn=$(basename "$1");
    fn="$HOME/tmp/${fn%\.*}.$now";
    script --timing="${fn}.tm" -f >(
	set -f
	while read -r; do
	    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S) ${REPLY%$'\x0d'}"
	done >> "${fn}.txt"
	)
}

# The timestamps int the txt log interfere with the timing information.
# There are two ways to get the timings right.
# 1. Remove timestamps from txt log
# 2. Adjust timing charcount by timestamp offset
#    This is not possible because we don't know if there was a timestamp
#    (timestamp is written each line, timings are done for characters)

# 2018-02-15 uwe: play - replay recorded session, removing timestamps
play () {
    (
    local tmpdir=$(mktemp -t -d play.XXXXXXXX)
    local cut_pid
    local fn=${1%.txt};
    # use cut to remove timestamps and feed it to scriptreplay via fifo
    mkfifo $tmpdir/log
    cut -d' ' -f2- "${fn}.txt" > $tmpdir/log 2>/dev/null & cut_pid=$!
    trap "rm -rf $tmpdir" INT
    scriptreplay -m 0.5 -t "${fn}.tm" $tmpdir/log
    )
}
