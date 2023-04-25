#!/bin/bash
export DISPLAY=:99
export XAUTHORITY=/torbrowser/.Xauthority


echo "---Starting TurboVNC server---"
vncserver -geometry 1024x768 -depth 16 :99 -rfbport 5900 -noxstartup "-securitytypes none" 2>/dev/null

echo "---Starting Fluxbox---"
/opt/scripts/start-fluxbox.sh &


echo "---Starting Tor-Browser---"
cd /torbrowser
/torbrowser/start-tor-browser --display=:99 --P torbrowser --setDefaultBrowser ${EXTRA_PARAMETERS}