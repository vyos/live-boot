#!/bin/sh

#set -e

Vyos ()
{
	# live-initramfs header
	. /scripts/functions
	. /lib/live/boot/9990-initramfs-tools.sh

	log_begin_msg "Configuring VyOS config path"

	# bind the vyatta config directory with the following precedence
	#	1) backing store if present
	#	2) create live/"overlay" which may or maynot be on a non-volatile device
	#	   but is certainly read-write

	VYOS_MOUNT_DIR="$(echo ${VYOS_MOUNT} | sed 's/live/mount/')"
	unioncfgpath="$(trim_path /root/lib/live/${VYOS_MOUNT_DIR}/${PERSISTENCE_PATH}/rw)"

	if [ -d /root/opt/vyatta/etc/config ]
	then
		if [ -d ${unioncfgpath}/config ]
		then
			mount -o bind ${unioncfgpath}/config /root/opt/vyatta/etc/config
		else
			cp -a /root/opt/vyatta/etc/config ${unioncfgpath} >/dev/null 2>&1
			mount -o bind ${unioncfgpath}/config /root/opt/vyatta/etc/config
		fi
	fi
	log_end_msg
}
