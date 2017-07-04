#!/bin/bash
INSTALL_DIR=/usr/local/bin
EIBD_bin=$INSTALL_DIR/knxd
TEMP_DIR=`mktemp -d /tmp/eibd.XXXXXX`
cd $TEMP_DIR
touch /tmp/compilation_eibd_in_progress
echo 0 > /tmp/compilation_eibd_in_progress
sudo pkill eibd  
sudo pkill knxd  
if [ -f "/etc/eibd/pthsem_VERSION" ]
then
  echo "*****************************************************************************************************"
  echo "*                              Remove PTHSEM V2.0.8 libraries                                       *"
  echo "*****************************************************************************************************"
  sudo rm /etc/eibd/pthsem_VERSION
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
  sudo rm bcusdk-0.0.5 
  sudo rm /etc/eibd/bcusdk_VERSION
fi
echo 10 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                                         Remove eibd                                               *"
echo "*****************************************************************************************************"
sudo rm -r /usr/local/bin/{eibd,knxtool,group*} /usr/local/lib/lib{eib,pthsem}*.so* /usr/local/include/pth*
if [ -f "/etc/logrotate.d/eibd" ]
then
  sudo rm /etc/logrotate.d/eibd
fi
if [ -f "/etc/default/eibd" ]
then
  sudo rm /etc/default/eibd
fi
if [ -f "/etc/log/eibd.log" ]
then
  sudo rm /etc/log/eibd.log
fi
if [ -d "/etc/eibd" ]
then
 sudo  rm -R /etc/eibd
fi
if [ -f "/usr/local/lib/libeibclient.so" ]
then
  sudo rm -rf /usr/local/lib/libeibclient.so
fi
if [ -f "/usr/local/lib/libeibclient.so.0" ]
then
  sudo rm -rf /usr/local/lib/libeibclient.so.0
fi
if [ -f "/usr/local/lib/libeibclient.a" ]
then
  sudo rm -rf /usr/local/lib/libeibclient.a
fi
if [ -f "/usr/local/lib/libeibclient.la" ]
then
  sudo rm -rf /usr/local/lib/libeibclient.la
fi
if [ -f "/usr/local/lib/libeibclient.so.0.0.0" ]
then
  sudo rm -rf /usr/local/lib/libeibclient.so.0.0.0
fi
echo 15 > /tmp/compilation_eibd_in_progress
#if [ -d "/usr/local/src/Knx/" ] then 
  echo "*****************************************************************************************************"
  echo "*                                         Remove knxd                                               *"
  echo "*****************************************************************************************************"
  apt-get autoremove --yes -y -qq knxd
  sudo rm -R /usr/local/src/Knx/
#fi
echo 20 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                                Installation des dependances                                       *"
echo "*****************************************************************************************************"
sudo apt-get -qy update
sudo apt-get -qy install build-essential 
sudo apt-get -qy install libev-dev
sudo apt-get -qy install git-core
sudo apt-get -qy install dpkg-buildpackage
sudo apt-get -qy install cdb
sudo apt-get -qy install git-core
sudo apt-get -qy install debhelper
sudo apt-get -qy install autoconf
sudo apt-get -qy install automake
sudo apt-get -qy install libtool
sudo apt-get -qy install libusb-1.0-0-dev
sudo apt-get -qy install libsystemd-daemon-dev
sudo apt-get -qy install libsystemd-dev
sudo apt-get -qy install dh-systemd
sudo apt-get -qy install cmake
echo 30 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                                      Installation de KnxD                                         *"
echo "*****************************************************************************************************"
sudo pkill eibd  
sudo pkill knxd  
sudo echo " " > /var/log/knxd.log
sudo chmod 777 /var/log/knxd.log
sudo git clone https://github.com/knxd/knxd.git
cd knxd
git checkout stable
sudo dpkg-buildpackage -b -uc -d
cd ..
sudo dpkg -i knxd_*.deb knxd-tools_*.deb
sudo usermod -a -G dialout knxd
sudo pkill knxd 
sudo rm /etc/init.d/
echo 90 > /tmp/compilation_eibd_in_progress
sudo systemctl stop knxd.service                                                                                   
sudosystemctl disable knxd.service  
sudo rm /lib/systemd/system/knxd.service
echo 95 > /tmp/compilation_eibd_in_progress
sudo systemctl stop knxd.socket                                                                                              
sudo systemctl disable knxd.socket 
sudo rm /lib/systemd/system/knxd.socket
echo 97 > /tmp/compilation_eibd_in_progress
sudo systemctl daemon-reload
sudo systemctl reset-failed
echo 99 > /tmp/compilation_eibd_in_progress
sudo mkdir /etc/eibd/
sudo chmod 777 /etc/eibd/
echo "v0.10" > /etc/eibd/knxd_VERSION
sudo rm /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                                       Installation terminé                                        *"
echo "*****************************************************************************************************"
