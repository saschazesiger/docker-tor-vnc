#!/bin/bash
export DISPLAY=:99
export XAUTHORITY=/torbrowser/.Xauthority


echo "---Starting TurboVNC server---"
vncserver -geometry ${CUSTOM_RES_W}x${CUSTOM_RES_H} -depth ${CUSTOM_DEPTH} :99 -rfbport ${RFB_PORT} -noxstartup ${TURBOVNC_PARAMS} 2>/dev/null

echo "---Starting Fluxbox---"
/opt/scripts/start-fluxbox.sh &


echo "---Starting Tor-Browser---"
cd /torbrowser
/torbrowser/start-tor-browser --display=:99 --P ${USER} --setDefaultBrowser ${EXTRA_PARAMETERS}