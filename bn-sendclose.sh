#!/bin/bash
# By Wiesław Magusiak, 2013-10-27, 2015-12-13 version 0.93
# Sends the local and external IP.
# Dependencies:  See bn-sendopen.sh.

RECIPIENT=${1-$USER} 	# If $RECIPIENT is not a qualified domain address,
						# look for the address in /etc/aliases.
if [[ $RECIPIENT == ${RECIPIENT%@*} ]]; then # No '@' in the recipient name.
	if [[ -e /etc/aliases ]]; then
		RECIPIENT=$(awk '/^'${RECIPIENT}':/ {print $2;exit}' /etc/aliases)
		RECIPIENT=${RECIPIENT%%,*}
		[[ -z $RECIPIENT ]] && exit 4 		# E-mail address not found.
	else
		exit 6 								# /etc/aliases does not exist.
	fi
else
	[[ $RECIPIENT == ${RECIPIENT%@*.*} ]] && exit 5 	# Wrong e-mail address.
fi

echo "Shutdown." | mail -s "Shutdown notification from $HOSTNAME" $RECIPIENT
/usr/bin/sleep 7 		# So that the internet interface is up a bit longer.
