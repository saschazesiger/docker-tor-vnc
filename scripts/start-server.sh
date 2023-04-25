#!/bin/bash
export DISPLAY=:99
export XAUTHORITY=/torbrowser/.Xauthority


screen -wipe 2&>/dev/null

echo "---Starting TurboVNC server---"
vncserver -geometry 1024x768 -depth ${CUSTOM_DEPTH} :99 -rfbport 5900 -noxstartup ${TURBOVNC_PARAMS} 2>/dev/null

echo "---Starting Fluxbox---"
/opt/scripts/start-fluxbox.sh &



echo "---Starting Tor-Browser---"
cd /torbrowser
/torbrowser/start-tor-browser --display=:99 --P torbrowser --setDefaultBrowser ${EXTRA_PARAMETERS}