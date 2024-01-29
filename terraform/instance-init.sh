#!/bin/bash
sudo su -c "printf '\nTypes: deb deb-src\nURIs: mirror+file:///etc/apt/mirrors/debian.list\nSuites: bullseye\nComponents: main\n' >> /etc/apt/sources.list.d/debian.sources"
sudo UCF_FORCE_CONFFOLD=1 apt update -yq
sudo UCF_FORCE_CONFFOLD=1 apt upgrade -yq
sudo UCF_FORCE_CONFFOLD=1 apt install -yq build-essential libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin uuid-dev libossp-uuid-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libwebsockets-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev tomcat9 tomcat9-admin tomcat9-common tomcat9-user
# TODO: Check if we can add the old debien repo with a single command
echo "✅ Package installed"


export GUACAMOLE_VERSION="1.5.4"

# Install the Guacamole server
cd /tmp
curl -LO https://apache.org/dyn/closer.lua/guacamole/$GUACAMOLE_VERSION/source/guacamole-server-$GUACAMOLE_VERSION.tar.gz?action=download
tar -xzf guacamole-server-$GUACAMOLE_VERSION.tar.gz
cd guacamole-server-$GUACAMOLE_VERSION/
# Build and start the Guacd deamon
sudo ./configure --with-init-dir=/etc/init.d --disable-guacenc
sudo make
sudo make install
sudo ldconfig
echo "✅ Guacamole builded"

sudo systemctl daemon-reload
sudo systemctl start guacd
sudo systemctl enable guacd
systemctl status guacd

# Comment out the IPv6 remote localhost listening
# sed -i '/^::1/s/^/#/g' /etc/hosts
sudo systemctl restart guacd

# Install the GUI Client
sudo curl -L -o /etc/guacamole/guacamole.war  https://downloads.apache.org/guacamole/$GUACAMOLE_VERSION/binary/guacamole-$GUACAMOLE_VERSION.war
echo "✅ Guacamole GUI installed"
# Configure Tomcat from the previous package sources and enable it
sudo ln -s /etc/guacamole/guacamole.war /var/lib/tomcat9/webapps/
echo "✅ Links created"
sudo mkdir -p /etc/guacamole/{extensions,lib}
echo "✅ Folders created"
sudo su -c "echo 'GUACAMOLE_HOME=/etc/guacamole' >> /etc/default/tomcat9"
sudo su -c "printf 'guacd-hostname: 127.0.0.1\nguacd-port: 4822\nuser-mapping:   /etc/guacamole/user-mapping.xml\nauth-provider:  net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider\n' >> /etc/guacamole/guacamole.properties"
sudo ln -s /etc/guacamole /usr/share/tomcat9/.guacamole
echo "✅ Links 2 created"
# Download a snippet for a user mapping
cd /tmp
curl -LO https://gist.githubusercontent.com/GridexX/ee38770e619a3b41bb0de132666bd16a/raw/4110820ae1891b67bbecf585476d38ba7f4282c4/user-mapping.xml
sudo mv /tmp/user-mapping.xml /etc/guacamole
sudo systemctl restart tomcat9 guacd
# TODO: Check how to retrieve user from the Edugain Federation
