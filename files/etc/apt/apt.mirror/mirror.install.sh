#!/bin/bash

file_name="/etc/apt/apt.mirror/sources-$APT_MIRROR-$ARCH.list"

if [ -f $file_name ]; then
	
	yes | cp -f $file_name /etc/apt/sources.list
	
else

	/etc/apt/apt.mirror/mirror.restore.sh
	
fi
