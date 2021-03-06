#!/bin/bash
##===============================================================================
## Copyright (c) 2013-2015 PoiXson, Mattsoft
## <http://poixson.com> <http://mattsoft.net>
##
## Description: Updates meta data for yum repos on this system.
##
## Install to location: /usr/bin/shellscripts
##
## Download the original from:
##   http://dl.poixson.com/shellscripts/
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
# repo_update.sh
clear
echo



PWD=`pwd`
if [[ "${PWD}" == "/usr/"* ]]; then
	echo "Cannot run repo_update.sh script from this location." >&2
	exit 1
fi
# load common utils script
if [ -e "${PWD}/common.sh" ]; then
	source "${PWD}/common.sh"
elif [ -e "/usr/bin/shellscripts/common.sh" ]; then
	source "/usr/bin/shellscripts/common.sh"
else
	wget -O "${PWD}/common.sh" "https://raw.githubusercontent.com/PoiXson/shellscripts/master/pxn/common.sh" \
		|| exit 1
	source "${PWD}/common.sh"
fi



# load xbuild-deploy.conf
if  searchConfig "xbuild-deploy.conf" 4  ; then
	# single instance
	get_lock
	# workers / cpu cores
	if [ -z $WORKERS ] || [ $WORKERS == 0 ]; then
		WORKERS=$((`nproc`+1))
	fi

	# stable repo
	if [ ! -z $XBUILD_PATH_YUM_STABLE ]; then
		title "Refreshing stable repo.."
		(
			cd "${XBUILD_PATH_YUM_STABLE}/" && \
			createrepo --workers=${WORKERS} .
		) || { errcho "Failed to update repo!"; exit 1; }
		CHOWNED=`chown -Rcf pxn. "${XBUILD_PATH_YUM_STABLE}" | wc -l`
		if [ "$CHOWN" > 0 ]; then
			echo "Updated owner of ${CHOWNED} files"
		fi
		newline
		newline
		newline
	fi

	# testing repo
	if [ ! -z $XBUILD_PATH_YUM_TESTING ]; then
		title "Refreshing testing repo.."
		(
			cd "${XBUILD_PATH_YUM_TESTING}/" && \
			createrepo --workers=${WORKERS} .
		) || { errcho "Failed to update repo!"; exit 1; }
		CHOWNED=`chown -Rcf pxn. "${XBUILD_PATH_YUM_STABLE}" | wc -l`
		if [ $CHOWN > 0 ]; then
			echo "Updated owner of ${CHOWNED} files"
		fi
		newline
		newline
		newline
	fi

else
	exit 1
fi
newline
echo "Finished updating repos"
newline
newline

