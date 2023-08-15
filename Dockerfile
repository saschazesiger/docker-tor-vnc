FROM j4n11s/base-vnc

LABEL org.opencontainers.image.authors="janis@js0.ch"
LABEL org.opencontainers.image.source="https://github.com/saschazesiger/"

ENV URL=https://browser.lol/redirect-url-to

COPY /scripts /opt/scripts

RUN apt-get update && \
	apt-get -y install --no-install-recommends xz-utils fonts-takao fonts-arphic-uming libgtk-3-0 libgconf-2-4 libnss3 fonts-liberation libasound2 libcurl3-gnutls libcurl3-nss libcurl4 libgbm1 libnspr4 libnss3 libu2f-udev xdg-utils jq




RUN download_link=$(curl -s "https://aus1.torproject.org/torbrowser/update_3/release/downloads.json" | jq -r '.downloads.linux64.ALL.binary')
RUN wget -q -nc --show-progress --progress=bar:force:noscroll -O /tor.tar.xz "$download_link"
RUN tar -C / --strip-components=2 -xf /tor.tar.xz
RUN rm -f /tor.tar.xz

#Server Start
CMD ["bash", "/opt/scripts/start.sh"]
