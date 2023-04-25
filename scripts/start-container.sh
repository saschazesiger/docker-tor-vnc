#!/bin/bash
echo "---Ensuring UID: ${UID} matches user---"
usermod -u ${UID} ${USER}
echo "---Ensuring GID: ${GID} matches user---"
groupmod -g ${GID} ${USER} > /dev/null 2>&1 ||:
usermod -g ${GID} ${USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}


echo "---Checking configuration for noVNC---"
novnccheck

echo "---Taking ownership of data...---"
chown -R root:${GID} /opt/scripts
chmod -R 750 /opt/scripts
chown -R ${UID}:${GID} ${DATA_DIR}

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

echo "---Installing Tor Browser...---"
cd /torbrowser
wget -q -nc --show-progress --progress=bar:force:noscroll -O /torbrowser/Tor-Browser.tar.xz "https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.0.5/tor-browser-linux64-12.0.5_ALL.tar.xz"
tar -C /torbrowser --strip-components=2 -xf /torbrowser/Tor-Browser.tar.xz
rm -f /torbrowser/Tor-Browser.tar.xz

cp -R /tmp/profile/Browser /torbrowser/TorBrowser/Data/
rm -f /torbrowser/Tor-Browser.tar.xz
rm -rf /tmp/profile


