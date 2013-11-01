#!/bin/bash
# By Wiesław Magusiak, 2013-10-27
# Version 0.91, 2013-10-30, modification of shutdown-time email subject
# Sends the local and external IP.
# Dependencies:  See sendopen.sh.

shift $((OPTIND - 1))
RECIPIENT=${1-$USER}
# If $RECIPIENT is not a qualified domain address, look for the address in /etc/aliases.
if [[ $RECIPIENT == ${RECIPIENT%@*.*} ]]; then
	if [[ -e /etc/aliases ]]; then
		RECIPIENT=$(cat /etc/aliases |grep -v ^\# |grep $RECIPIENT|cut -d" " -f2)
		RECIPIENT=${RECIPIENT%%,*}
		[[ -z $RECIPIENT ]] && exit 4 				# E-mail address not found.
	else
		exit 6 										# /etc/aliases does not exist.
	fi
else
	[[ $RECIPIENT == ${RECIPIENT%@.*} ]] || exit 5 	# Wrong e-mail address.
fi

echo "Shutdown." | mail -s "S-time msg from $HOSTNAME" $RECIPIENT
/usr/bin/sleep 10 			# So that the internet interface is up
