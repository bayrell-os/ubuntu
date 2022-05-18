#!/bin/bash


file_name="/etc/apt/apt.mirror/sources-$ARCH.list"

if [ -f $file_name ]; then

	yes | cp -f $file_name /etc/apt/sources.list
	
fi