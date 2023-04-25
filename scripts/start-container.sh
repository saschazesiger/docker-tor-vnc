cd /torbrowser
wget -q -nc --show-progress --progress=bar:force:noscroll -O /torbrowser/Tor-Browser.tar.xz "https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.0.5/tor-browser-linux64-12.0.5_ALL.tar.xz"
tar -C /torbrowser --strip-components=2 -xf /torbrowser/Tor-Browser.tar.xz
rm -f /torbrowser/Tor-Browser.tar.xz
cp -R /tmp/profile/Browser /torbrowser/TorBrowser/Data/
rm -f /torbrowser/Tor-Browser.tar.xz
rm -rf /tmp/profile


