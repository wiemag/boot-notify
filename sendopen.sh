#!/bin/bash
# By Wiesław Magusiak, 2013-10-27
# Version 0.91, 2013-10-30, modification of boot-time email subject
# Sends sender's external and local IP's and the active network interface.
# If sent by root, sudo -u $USER /path/to/user's/directory/.../sendmyip.sh.

# DEPENDENCIES
# Command whereis:  util-linux
# Command curl:     curl
# Command wget:     wget (optional)
# Command ip:       iproute2
# Command mail:     s-nail (or heirloom-mailx) 
#                   and msmtp + sm-c
#                       or mstp-mta
# Command grep:     grep
# Command cut:      coreutils

function myip () { 
	if [ -f `whereis curl | cut -d" " -f2` ] ; then 
		IP=$(curl -s ifconfig.me)
		#IP=${IP#*: }; IP=${IP%%<*}
	else
		if [ -f `whereis wget | cut -d" " -f2` ] ; then 
			IP=$(wget -q -O - checkip.dyndns.org)
			IP=${IP#*: }; IP=${IP%%<*}
		else
			exit 1
		fi
	fi
	IFACE=$(echo $(ip route)|cut -d" " -f5)
	IP=$IP" "$(ip a show dev $IFACE | awk '$1 == "inet" { split($2, a, "/"); print a[1]; }')
	echo $IP" "$IFACE
}

while getopts  "s:" flag
do
	[[ "$flag" == "s" ]] && SUBJECT="$OPTARG" 			# E-mail subject
done

shift $((OPTIND - 1))
RECIPIENT=${1-$USER}
SUBJECT=${SUBJECT-"B-time msg from $HOSTNAME"}
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

sleep 1 	# One extra second to give systemd more time to start the network
echo $(myip) | mail -s "$SUBJECT" $RECIPIENT
