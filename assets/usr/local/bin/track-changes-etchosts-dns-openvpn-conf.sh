#!/bin/bash

DNS="unbound"
CHECKFILE="/tmp/etchostscheck.tmp"

echo "Tracking changes in /etc/hosts for name: unbound"
while true
do
	CHECKSUM=`grep 'unbound' /etc/hosts | md5sum`
	if [ -e "$CHECKFILE" ]; then
		OLDCHECKSUM=`cat $CHECKFILE`
		if [ "$OLDCHECKSUM" != "$CHECKSUM" ]; then
			echo "Rebuilding localzone, /etc/host has changed"
			echo "Old checksum: $OLDCHECKSUM--"
			echo "Live checksum: $CHECKSUM--"
       		 	cat > $CHECKFILE <<< "$CHECKSUM"
			build-openvpn-config
			killall openvpn
		fi
	else
		echo "Create localzone from /etc/hosts for unbound."
		cat > $CHECKFILE <<< "$CHECKSUM"
		build-openvpn-config
		killall openvpn
	fi
	
	sleep 15
done
