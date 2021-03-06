#!/bin/sh

set -e

CACHE_FILE=/etc/zabbix/speedtest/speedtest.log
ERROR_FILE=/etc/zabbix/speedtest/speedtest.error
LOCK_FILE=/etc/zabbix/speedtest/speedtest.lock

run_speedtest() {
	# Lock
	if [ -e "$LOCK_FILE" ]
	then
		echo "A speedtest is already running" >&2
		exit 2
	fi
	touch "$LOCK_FILE"

	#Invoke rm LOCK_FILE on exit
	trap "rm -rf $LOCK_FILE" EXIT HUP INT QUIT PIPE TERM

	#Variable declaration
	local output server_id server_sponsor country location ping download upload

	#output=$(/usr/local/bin/SpeedTest --test-server speedtest.iwbtelekom.net:8080 --output text 2>&1)
    /usr/local/bin/SpeedTest --test-server $SPEEDTEST_SERVER --output text > $CACHE_FILE
	
	#Debug
	#echo "Output: $output"

	#Extract and convert with only two decimal
	#ping=$(echo "$output" | grep -n 'Ping: ' | awk '{ printf("%.2f\n", $1) }')
	#Extract and convert to Mbit/s with only two decimal
	#download=$(echo "$output" | grep -n 'Download: ' | awk '{ printf("%.2f\n", $1) }')
	#upload=$(echo "$output" | grep -n 'Upload:' | awk '{ printf("%.2f\n", $1) }')

	#Send value to CACHE_FILE
	#{
	#	echo "$output"
	#	
	#} > "$CACHE_FILE"
	
	# CACHE_FILE=/etc/zabbix/script/speedtest.log

	# Make sure to remove the lock file (may be redundant)
	rm -rf "$LOCK_FILE"
}

display_help() {
	echo "Usage with this parameters"
	echo
	echo "                          Run the speedtest collector with default setting (best server)"
	echo "   -u, --upload           Get the upload speed for the last speedtest with default setting"
	echo "   -d, --download         Get the download speed for the last speedtest with default setting"
	echo "   -f, --force            Force delete of lock and run the speedtest collector"
	echo "   -h, --help             View this help"
	echo
}

check_cache_exist() {
	if [ ! -e "$1" ]
	then
		echo "NO DATA" >&2
		exit 2
	fi
}

if [ $# -eq 0 ] || [ $# -eq 1 ]
then
	case "$1" in
		-u|--upload)
			check_cache_exist "$CACHE_FILE"
			sed -n 's/^UPLOAD_SPEED=//p' "$CACHE_FILE"
			;;
		-d|--download)
			check_cache_exist "$CACHE_FILE"
			sed -n 's/^DOWNLOAD_SPEED=//p' "$CACHE_FILE"
			;;
		-f|--force)
			rm -rf "$LOCK_FILE"
			run_speedtest
			;;
		-h|--help)
			display_help
			;;
		*)
			run_speedtest
			;;
	esac
fi
