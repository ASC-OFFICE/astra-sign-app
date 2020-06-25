FROM scratch AS astralinux-ce

ADD astralinux-ce-2.12.xz /

FROM astralinux-ce

ENV DEBIAN_FRONTEND=noninteractive \
	LANG=ru_RU.UTF-8 \
	LANGUAGE=ru_RU:ru \
	LC_LANG=ru_RU.UTF-8 \
	LC_ALL=ru_RU.UTF-8

RUN apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -y install bsign gnupg

COPY docker-entrypoint.sh /usr/local/bin/

VOLUME /root/keys /root/buildroot

ENTRYPOINT cd /root && docker-entrypoint.sh
