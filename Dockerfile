FROM ich777/novnc-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-torbrowser"



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

ADD /scripts/ /opt/scripts/
COPY /conf/ /etc/.fluxbox/
RUN chmod -R 770 /opt/scripts/
RUN /opt/scripts/start-container.sh

EXPOSE 8080

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]