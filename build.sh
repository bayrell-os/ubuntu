#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
IMAGE="ubuntu"
VERSION="jammy"
SUBVERSION=1
TAG=`date '+%Y%m%d_%H%M%S'`

if [ "$APT_MIRROR" = "" ]; then
	APT_MIRROR=""
fi

case "$1" in
	
	test-amd64)
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-amd64 \
			--file Dockerfile --build-arg ARCH=amd64 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	test-arm64v8)
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-arm64v8 \
			--file Dockerfile --build-arg ARCH=arm64v8 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	test-arm32v7)
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-arm32v7 \
			--file Dockerfile --build-arg ARCH=arm32v7 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	stage0-amd64)
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-amd64 \
			--file stages/Dockerfile0 --build-arg ARCH=amd64 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	stage0-arm64v8)
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-arm64v8 \
			--file stages/Dockerfile0 --build-arg ARCH=arm64v8 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	stage0-arm32v7)
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-arm32v7 \
			--file stages/Dockerfile0 --build-arg ARCH=arm32v7 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	amd64)
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			--file Dockerfile --build-arg ARCH=amd64 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	arm64v8)
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8 \
			--file Dockerfile --build-arg ARCH=arm64v8 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	arm32v7)
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-arm32v7 \
			--file Dockerfile --build-arg ARCH=arm32v7 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	manifest)
		rm -rf ~/.docker/manifests/docker.io_bayrell_$IMAGE-*
		
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 bayrell/$IMAGE:$VERSION-amd64
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8 bayrell/$IMAGE:$VERSION-arm64v8
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-arm32v7 bayrell/$IMAGE:$VERSION-arm32v7
		
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-arm32v7
		
		docker push bayrell/$IMAGE:$VERSION-amd64
		docker push bayrell/$IMAGE:$VERSION-arm64v8
		docker push bayrell/$IMAGE:$VERSION-arm32v7
		
		docker manifest create bayrell/$IMAGE:$VERSION-$SUBVERSION \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8 \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-arm32v7
		docker manifest push bayrell/$IMAGE:$VERSION-$SUBVERSION
		
		docker manifest create bayrell/$IMAGE:$VERSION \
			--amend bayrell/$IMAGE:$VERSION-amd64 \
			--amend bayrell/$IMAGE:$VERSION-arm64v8 \
			--amend bayrell/$IMAGE:$VERSION-arm32v7
		docker manifest push bayrell/$IMAGE:$VERSION
	;;
	
	all)
		$0 amd64
		$0 arm64v8
		$0 arm32v7
		$0 manifest
	;;
	
	*)
		echo "Usage: $0 {all|amd64|arm64v8|arm32v7|test-amd64|test-arm64v8|test-arm32v7|stage0-amd64|stage0-arm64v8|stage0-arm32v7}"
		RETVAL=1

esac

exit $RETVAL
