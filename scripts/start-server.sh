#!/bin/bash
export DISPLAY=:99
export XAUTHORITY=/torbrowser/.Xauthority


echo "---Tor-Browser not installed, installing---"
sudo apt install xz-utils -y
cd /torbrowser
wget -q -nc --show-progress --progress=bar:force:noscroll -O /torbrowser/Tor-Browser.tar.xz "https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.0.5/tor-browser-linux64-12.0.5_ALL.tar.xz"
tar -C /torbrowser --strip-components=2 -xf /torbrowser/Tor-Browser.tar.xz
rm -f /torbrowser/Tor-Browser.tar.xz
ls


echo "---Preparing Server---"

echo "---Resolution check---"
if [ -z "${CUSTOM_RES_W} ]; then
	CUSTOM_RES_W=1024
fi
if [ -z "${CUSTOM_RES_H} ]; then
	CUSTOM_RES_H=768
fi

if [ "${CUSTOM_RES_W}" -le 1023 ]; then
	echo "---Width to low must be a minimal of 1024 pixels, correcting to 1024...---"
    CUSTOM_RES_W=1024
fi
if [ "${CUSTOM_RES_H}" -le 767 ]; then
	echo "---Height to low must be a minimal of 768 pixels, correcting to 768...---"
    CUSTOM_RES_H=768
fi
echo "---Checking for old logfiles---"
find $DATA_DIR -name "XvfbLog.*" -exec rm -f {} \;
find $DATA_DIR -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old display lock files---"
rm -rf /tmp/.X99*
rm -rf /tmp/.X11*
rm -rf /torbrowser/.vnc/*.log /torbrowser/.vnc/*.pid
chmod -R ${DATA_PERM} /torbrowser
if [ -f /torbrowser/.vnc/passwd ]; then
	chmod 600 /torbrowser/.vnc/passwd
fi
screen -wipe 2&>/dev/null

echo "---Starting TurboVNC server---"
vncserver -geometry ${CUSTOM_RES_W}x${CUSTOM_RES_H} -depth ${CUSTOM_DEPTH} :99 -rfbport ${RFB_PORT} -noxstartup ${TURBOVNC_PARAMS} 2>/dev/null
sleep 2
echo "---Starting Fluxbox---"
/opt/scripts/start-fluxbox.sh &
sleep 2
echo "---Starting noVNC server---"
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem ${NOVNC_PORT} localhost:${RFB_PORT}
sleep 2

echo "---Starting Tor-Browser---"
cd /torbrowser
/torbrowser/start-tor-browser --display=:99 --P ${USER} --setDefaultBrowser ${EXTRA_PARAMETERS}