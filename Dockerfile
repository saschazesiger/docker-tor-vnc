FROM j4n11s/base-vnc

LABEL org.opencontainers.image.authors="janis@js0.ch"
LABEL org.opencontainers.image.source="https://github.com/saschazesiger/"

ENV URL=https://browser.lol/redirect-url-to

COPY /scripts /opt/scripts

RUN apt-get update && \
	apt-get -y install --no-install-recommends xz-utils fonts-takao fonts-arphic-uming libgtk-3-0 libgconf-2-4 libnss3 fonts-liberation libasound2 libcurl3-gnutls libcurl3-nss libcurl4 libgbm1 libnspr4 libnss3 libu2f-udev xdg-utils



RUN mkdir /tmp-profile && \
	mkdir /tor && \
	cd /tor && \
	wget -q -nc --show-progress --progress=bar:force:noscroll -O /tor/Tor-Browser.tar.xz "https://www.techspot.com/downloads/downloadnowfile/5183/?evp=6678ae95f7622630c557f0dc2e26eaa1&file=5616" && \
	tar -C /tor --strip-components=2 -xf /tor/Tor-Browser.tar.xz && \
	rm -f /tor/Tor-Browser.tar.xz && \
	cp -R /tmp-profile /tor/TorBrowser/Data/ && \
	rm -f /tor/Tor-Browser.tar.xz && \
	rm -rf /tmp-profile

#Server Start
CMD ["bash", "/opt/scripts/start.sh"]
