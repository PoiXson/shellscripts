##===============================================================================
## Copyright (c) 2013-2014 PoiXson, Mattsoft
## <http://poixson.com> <http://mattsoft.net>
##
## Description: Common methods and utilities for pxn shell scripts.
##
## Install to location: /usr/local/bin/pxn
##
## Download the original from:
##   http://dl.poixson.com/scripts/
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
##===============================================================================
# common.sh



# export PXN_DATA="/files"
# export PXN_BACKUPS="/backups"
# export PXN_WORKSPACE="/zwork"
# source ${PXN_SCRIPTS}/aliases.sh

export YES=1
export NO=0



trap ctrl_c INT
function ctrl_c() {
	newline
	echo "*** Trapped CTRL-C ***"
	newline
	exit 1
}



# debug mode
if [ -e /usr/local/bin/pxn/debug ] || [ -e debug ]; then
	DEBUG=true
fi
if [ "$DEBUG" = true ]; then
	echo "[ DEBUG Mode ]"
	# Print commands when executed
	set -x
	# Variables that are not set are errors
	set -u
fi



function newline() {
	echo -ne "\n"
}
function echoerr() {
	echo "$@" 1>&2
}
function warning() {
	echo "[WARNING] $@"
}
#function ask() {
#	echo -n "$@" '[Y/n] '; read -n 1 reply
#	newline
#	case "$reply" in
#		n*|N*) return 1 ;;
#		*) return 0 ;;
#	esac
#}
function title() {
	local i=$((${#1}+8))
	local j=$((${#1}+4))
	local c=${#}
	newline
	echo -n " "; eval "printf '*'%.0s {1..$i}"; echo
	echo -n " "; eval "printf '*'%.0s {1..$i}"; echo
	echo -n " **"; eval "printf ' '%.0s {1..$j}"; echo "**"
	for line in "${@}"; do
		echo " **  ${line}  **"
	done
	echo -n " **"; eval "printf ' '%.0s {1..$j}"; echo "**"
	echo -n " "; eval "printf '*'%.0s {1..$i}"; echo
	echo -n " "; eval "printf '*'%.0s {1..$i}"; echo
	newline
	newline
}



# sleep
function sleepdot() {
        sleep 1;echo -n "."
        sleep 1;echo -n "."
        sleep 1;echo ""
}
function sleepdotdot() {
        sleep 2;echo -n " ."
        sleep 2;echo -n " ."
        sleep 2;echo -n " ."
        sleep 2;echo -n " ."
        sleep 2;echo ""
}



function create_lock {
	LOCK_NAME=${1}
	if [ -z "$LOCK_NAME" ]; then
		LOCK_NAME="lock"
	fi
	while true; do
		if [[ -e "$LOCK_NAME" ]]; then
			OLDPID=`cat $LOCK_NAME`
#			if [ "ps p $OLDPID" > /dev/null ]; then
#				return 1
#			fi
#			rm -v $LOCK_NAME
			echo -n "Script is already running."; sleepdotdot
		else
			# got lock
			echo $$ > $LOCK_NAME
			break
		fi
	done
	return 0
}
function remove_lock {
        LOCK_NAME=${1}
	if [ ! -z "$LOCK_NAME" ]; then
	        rm -vf $LOCK_NAME
	fi
}

