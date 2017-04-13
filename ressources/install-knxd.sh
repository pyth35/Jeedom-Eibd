#!/bin/bash
sudo su
INSTALL_DIR=/usr/local/bin
EIBD_bin=$INSTALL_DIR/knxd
TEMP_DIR=`mktemp -d /tmp/eibd.XXXXXX`
cd $TEMP_DIR
touch /tmp/compilation_eibd_in_progress
echo 0 > /tmp/compilation_eibd_in_progress
pkill eibd  
pkill knxd  
if [ -f "/etc/eibd/pthsem_VERSION" ]
then
  echo "*****************************************************************************************************"
  echo "*                              Remove PTHSEM V2.0.8 libraries                                       *"
  echo "*****************************************************************************************************"
  rm /etc/eibd/pthsem_VERSION
  echo $LD_LIBRARY_PATH
  export LD_LIBRARY_PATH="/usr/local/lib"
  ldconfig 
fi
echo 5 > /tmp/compilation_eibd_in_progress
if [ -f "/etc/eibd/bcusdk_VERSION" ]
then
  echo "*****************************************************************************************************"
  echo "*                              Remove BCUSDK V0.0.5 libraries                                       *"
  echo "*****************************************************************************************************"
  rm bcusdk-0.0.5 
  rm /etc/eibd/bcusdk_VERSION
fi
echo 10 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                                         Remove eibd                                               *"
echo "*****************************************************************************************************"
if [ -f "/etc/logrotate.d/eibd" ]
then
  rm /etc/logrotate.d/eibd
fi
if [ -f "/etc/default/eibd" ]
then
  rm /etc/default/eibd
fi
if [ -f "/etc/log/eibd.log" ]
then
  rm /etc/log/eibd.log
fi
if [ -d "/etc/eibd" ]
then
  rm -R /etc/eibd
fi
if [ -f "/usr/local/lib/libeibclient.so" ]
then
  rm -rf /usr/local/lib/libeibclient.so
fi
if [ -f "/usr/local/lib/libeibclient.so.0" ]
then
  rm -rf /usr/local/lib/libeibclient.so.0
fi
if [ -f "/usr/local/lib/libeibclient.a" ]
then
  rm -rf /usr/local/lib/libeibclient.a
fi
if [ -f "/usr/local/lib/libeibclient.la" ]
then
  rm -rf /usr/local/lib/libeibclient.la
fi
if [ -f "/usr/local/lib/libeibclient.so.0.0.0" ]
then
  rm -rf /usr/local/lib/libeibclient.so.0.0.0
fi
echo 15 > /tmp/compilation_eibd_in_progress
if [ -d "/usr/local/src/Knx/" ]; then 
  rm -R /usr/local/src/Knx/
fi
mkdir /usr/local/src/Knx/
cd /usr/local/src/Knx
echo "*****************************************************************************************************"
echo "*                                         Remove knxd                                               *"
echo "*****************************************************************************************************"
apt-get autoremove --yes -y -qq knxd
echo 20 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                                Installation des dependances                                       *"
echo "*****************************************************************************************************"
apt-get update --yes -y -qq
apt-get install debhelper --yes -y -qq
apt-get install cdbs --yes -y -qq
apt-get install automake --yes -y -qq
apt-get install libtool --yes -y -qq
apt-get install libusb-1.0-0-dev --yes -y -qq
apt-get install git-core --yes -y -qq
apt-get install build-essential --yes -y -qq
apt-get install libsystemd-daemon-dev --yes -y -qq
apt-get install dh-systemd --yes -y -qq
apt-get install libev-dev --yes -y -qq
apt-get install llibsystemd-dev --yes -y -qq
apt-get install lcmake --yes -y -qq

echo 30 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                                      Installation de KnxD                                         *"
echo "*****************************************************************************************************"
git clone https://github.com/knxd/knxd.git
echo 55 > /tmp/compilation_eibd_in_progress
cd knxd
git checkout stable
dpkg-buildpackage -b -uc -d
echo 70 > /tmp/compilation_eibd_in_progress
cd ..
dpkg -i knxd_*.deb knxd-tools_*.deb
echo 90 > /tmp/compilation_eibd_in_progress
systemctl stop knxd.service
echo 91 > /tmp/compilation_eibd_in_progress
systemctl stop knxd.socket     
echo 92 > /tmp/compilation_eibd_in_progress                                                                                      
systemctl disable knxd.service   
echo 94 > /tmp/compilation_eibd_in_progress                                                                                           
systemctl disable knxd.socket 
echo 95 > /tmp/compilation_eibd_in_progress
systemctl daemon-reload
echo 97 > /tmp/compilation_eibd_in_progress
systemctl reset-failed
echo 99 > /tmp/compilation_eibd_in_progress
rm /lib/systemd/system/knxd.service
mkdir /etc/eibd/
chmod 777 /etc/eibd/
echo "v0.10" > /etc/eibd/knxd_VERSION
rm /tmp/compilation_eibd_in_progress
