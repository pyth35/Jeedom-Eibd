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
sudo apt-get update --yes -y -qq
sudo apt-get install libev-dev --yes -y -qq
sudo apt-get install git-core --yes -y -qq
sudo apt-get install build-essential 
sudo apt-get install dpkg-buildpackage --yes -y -qq
sudo apt-get install cdbs --yes -y -qq
sudo apt-get install git-core  --yes -y -qq
sudo apt-get install debhelper  --yes -y -qq
sudo apt-get install autoconf  --yes -y -qq
sudo apt-get install automake  --yes -y -qq
sudo apt-get install libtool  --yes -y -qq
sudo apt-get install libusb-1.0-0-dev  --yes -y -qq
sudo apt-get install libsystemd-daemon-dev  --yes -y -qq
sudo apt-get install libsystemd-dev --yes -y -qq
sudo apt-get install dh-systemd --yes -y -qq
sudo apt-get install cmake --yes -y -qq
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
echo "*****************************************************************************************************"
echo "*                                       Installation terminé                                        *"
echo "*****************************************************************************************************"
