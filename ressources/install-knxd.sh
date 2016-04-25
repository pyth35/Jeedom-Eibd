#!/bin/bash
INSTALL_DIR=/usr/local/bin
TEMP_DIR=`mktemp -d /tmp/knxd.XXXXXX`
KNXD_bin=$INSTALL_DIR/knxd
echo "*****************************************************************************************************"
echo "*                                   Installation des dépendance                                     *"
echo "*****************************************************************************************************"
apt-get -qy install update
apt-get -qy install git-core
apt-get -qy install build-essential 
apt-get -qy install cdbs
apt-get -qy install autoconf
apt-get -qy install libtool
apt-get -qy install libusb-1.0-0-dev
apt-get -qy install pkg-config
apt-get -qy install libsystemd-deamon-dev 
apt-get -qy install dh-systemd
mkdir -p /etc/knxd
if [ "$(cat /etc/knxd/pthsem_VERSION)" != "v2.0.8" ]
then
echo "*****************************************************************************************************"
echo "*                                       Installation de pthsem                                      *"
echo "*****************************************************************************************************"
cd $TEMP_DIR
wget https://www.auto.tuwien.ac.at/~mkoegler/pth/pthsem_2.0.8.tar.gz
tar xzf pthsem_2.0.8.tar.gz
cd pthsem-2.0.8
dpkg-buildpackage -b -uc -d
cd ..
sudo dpkg -i libpthsem*.deb
echo "v2.0.8" > /etc/knxd/pthsem_VERSION
fi
if [ "$(cat /etc/knxd/KNXD_VERSION)" != "v0.10" ]
then
echo "*****************************************************************************************************"
echo "*                                       Installation de KNXD                                        *"
echo "*****************************************************************************************************"
cd $TEMP_DIR
git clone https://github.com/knxd/knxd.git
cd knxd
dpkg-buildpackage -b -uc -d
cd ..
sudo dpkg -i knxd_*.deb knxd-tools_*.deb
echo "v0.10" > /etc/knxd/KNXD_VERSION
fi
echo "*****************************************************************************************************"
echo "*                                       Configuration de KNXD                                       *"
echo "*****************************************************************************************************"+
tee /etc/knxd.conf <<- 'EOF'
KNXD_OPTS ="-D -T -R -S -b ipt:"
EOF
sudo chmod 777 /etc/knxd.conf
sudo systemctl enable knxd.service
sudo systemctl start knxd.service