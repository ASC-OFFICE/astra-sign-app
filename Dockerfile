FROM adragunov/astralinux_se:17 AS astra-sign-app

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'ru_RU.UTF-8 UTF-8' >> /etc/locale.gen \
  && locale-gen ru_RU.UTF-8 \
	&& update-locale \
	&& apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -y install binutils bsign file gnupg

COPY docker-entrypoint.sh /usr/local/bin/

VOLUME /root/keys /root/buildroot

ENTRYPOINT cd /root && docker-entrypoint.sh
