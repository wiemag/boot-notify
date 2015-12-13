#!/bin/bash
# By Wiesław Magusiak, 2013-10-27, 2015-12-13 wersion 0.93
# Sends sender's external and local IP's and the active network interface.

# DEPENDENCIES
# bind-tools (dig), iproute2 (ip), s-nail (mail)

function myIPs () {
echo $(dig +short myip.opendns.com @resolver1.opendns.com) $(ip route|awk '/defau/ {print $7" "$5}')
}

while getopts  "s:" flag; do		# Read e-mail Subject, if any.
	[[ "$flag" == "s" ]] && SUBJECT="$OPTARG" 	# E-mail subject
done
shift $((OPTIND - 1))
SUBJECT=${SUBJECT-"Boot notification from $HOSTNAME"} 	# Default Subject
RECIPIENT=${1-$USER} 	# If $RECIPIENT is not a qualified domain address,
						# look for the address in /etc/aliases.
if [[ $RECIPIENT == ${RECIPIENT%@*} ]]; then # No '@' in the recipient name.
	if [[ -e /etc/aliases ]]; then
		RECIPIENT=$(awk '!/^#/ && /^'${RECIPIENT}':/ {print $2;exit}' /etc/aliases)
		RECIPIENT=${RECIPIENT%%,*}
		[[ -z $RECIPIENT ]] && exit 4 		# E-mail address not found.
	else
		exit 6 								# /etc/aliases does not exist.
	fi
else
	[[ $RECIPIENT == ${RECIPIENT%@*.*} ]] && exit 5 	# Wrong e-mail address.
fi
#sleep 1
echo $(myIPs) | mail -s "$SUBJECT" $RECIPIENT
