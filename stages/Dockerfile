ARG ARCH=amd64
FROM ${ARCH}/ubuntu:focal-20220426

ARG ARCH
ENV ARCH=${ARCH}
ARG APT_MIRROR

COPY files/etc/apt /etc/apt

RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	/etc/apt/apt.mirror/mirror.install.sh; \
	apt-get update; \
	apt-get install -y --no-install-recommends apt-utils locales ca-certificates; \
	apt-get clean all; \
	ln -snf /usr/share/zoneinfo/Asia/Almaty /etc/localtime; \
	echo "Asia/Almaty" > /etc/timezone; \
	locale-gen en_US en_US.UTF-8 ru_RU.UTF-8; \
	update-locale LANG=en_US.utf8 LANGUAGE=en_US:en; \
	echo "LANG="en_US.utf8" \n\
LANGUAGE="en_US:en" \n\
export LANG \n\
export LANGUAGE\n" >> /etc/bash.bashrc; \
	echo 'Ok'

RUN cd ~; \
	apt-get install -y --no-install-recommends tzdata debconf-utils mc less nano wget pv zip \
		unzip supervisor net-tools iputils-ping sudo curl gnupg; \
	/etc/apt/apt.mirror/mirror.restore.sh; \
	apt-get clean all; \
	echo 'Ok'

COPY files/etc /etc
COPY files/root /root
RUN cd ~; \
	chmod +x /root/run.sh; \
	echo "Ok"
	
CMD ["/root/run.sh"]