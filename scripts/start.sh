#!/bin/bash
echo "---Ensuring UID: 99 matches user---"
usermod -u 99 torbrowser
groupmod -g 100 torbrowser > /dev/null 2>&1 ||:
usermod -g 100 torbrowser
umask ${UMASK}


echo "---Taking ownership of data...---"
chown -R root:100 /opt/scripts
chmod -R 750 /opt/scripts
chown -R 99:100 ${DATA_DIR}

echo "---Starting...---"
term_handler() {
	kill -SIGTERM "$killpid"
	wait "$killpid" -f 2>/dev/null
	exit 143;
}

trap 'kill ${!}; term_handler' SIGTERM
su torbrowser -c "/opt/scripts/start-server.sh" &
killpid="$!"
while true
do
	wait $killpid
	exit 0;
done