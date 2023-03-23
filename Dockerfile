FROM ich777/novnc-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-torbrowser"

RUN export TZ=Europe/Rome && \
	apt-get update && \
	apt-get -y install --no-install-recommends libgtk-3-0 libdbus-glib-1-2 fonts-takao fonts-arphic-uming fonts-noto-cjk libasound2 ffmpeg xz-utils jq wget fluxbox x11vnc xvfb websockify openssl screen && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
	echo "ko_KR.UTF-8 UTF-8" >> /etc/locale.gen && \ 
	echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen && \
	rm -rf /var/lib/apt/lists/* && \
	sed -i '/    document.title =/c\    document.title = "Tor Browser - noVNC";' /usr/share/novnc/app/ui.js && \
	rm /usr/share/novnc/app/images/icons/*

ENV DATA_DIR=/torbrowser
ENV CUSTOM_RES_W=1024
ENV CUSTOM_RES_H=768
ENV CUSTOM_DEPTH=16
ENV NOVNC_PORT=8080
ENV RFB_PORT=5900
ENV TURBOVNC_PARAMS="-securitytypes none"
ENV TOR_V="latest"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="torbrowser"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	mkdir -p /tmp/config && \
	ulimit -n 2048

RUN LAT_V="$(wget -qO- https://api.github.com/repos/TheTorProject/gettorbrowser/releases | jq -r '.[].tag_name' | grep "linux64-" | cut -d '-' -f2)" \
    && CUR_V="$(cat ${DATA_DIR}/application.ini 2>/dev/null | grep -E "^Version=[0-9].*" | cut -d '=' -f2)" \
    && if [ -z "$CUR_V" ]; then \
            if [ "${TOR_V}" != "latest" ]; then \
                LAT_V="$TOR_V"; \
            fi; \
        else \
            if [ "${TOR_V}" == "latest" ]; then \
                LAT_V="$CUR_V"; \
                if [ -z "$LAT_V" ]; then \
                    echo "Something went horribly wrong with version detection, putting container into sleep mode..."; \
                    sleep infinity; \
                fi; \
            else \
                LAT_V="$TOR_V"; \
            fi; \
        fi; \
    rm ${DATA_DIR}/Tor-Browser-*.tar.xz 2>/dev/null \
    && if [ -z "$CUR_V" ]; then \
            echo "---Tor-Browser not installed, installing---" \
            && cd ${DATA_DIR} \
            && if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Tor-Browser-${LAT_V}.tar.xz "https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-${LAT_V}/tor-browser-linux64-${LAT_V}_ALL.tar.xz" ; then \
                    echo "---Successfully downloaded Tor-Browser---" \
                else \
                    echo "---Something went wrong, can't download Tor-Browser, putting container in sleep mode---" \
                    && rm -f ${DATA_DIR}/Tor-Browser-${LAT_V}.tar.xz \
                    && sleep infinity; \
                fi \
            && tar -C ${DATA_DIR} --strip-components=2 -xf ${DATA_DIR}/Tor-Browser-${LAT_V}.tar.xz \
            && rm -f ${DATA_DIR}/Tor-Browser-${LAT_V}.tar.xz \
        fi

ADD /scripts/ /opt/scripts/
COPY /icons/* /usr/share/novnc/app/images/icons/
COPY /conf/ /etc/.fluxbox/
RUN chmod -R 770 /opt/scripts/

EXPOSE 8080

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]