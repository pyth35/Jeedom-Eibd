#!/bin/bash
INSTALL_DIR=/usr/local/bin
EIBD_bin=$INSTALL_DIR/knxd
TEMP_DIR=`mktemp -d /tmp/eibd.XXXXXX`
cd $TEMP_DIR
touch /tmp/compilation_eibd_in_progress
echo 0 > /tmp/compilation_eibd_in_progress
if [ -f "/etc/eibd/pthsem_VERSION" ]
then
  echo "*****************************************************************************************************"
  echo "*                              Remove PTHSEM V2.0.8 libraries                                       *"
  echo "*****************************************************************************************************"
  sudo rm /etc/eibd/pthsem_VERSION
  echo $LD_LIBRARY_PATH
  export LD_LIBRARY_PATH="/usr/local/lib"
  sudo ldconfig 
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
TEMP_DIR=`mktemp -d /tmp/knxd.XXXXXX`
cd $TEMP_DI
echo "*****************************************************************************************************"
echo "*                                         Remove knxd                                               *"
echo "*****************************************************************************************************"
sudo apt-get autoremove --yes -y -qq knxd
sudo rm /var/log/knxd.log
echo 20 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                                Installation des dependances                                       *"
echo "*****************************************************************************************************"
#sudo apt-get update --yes -y -qq
#sudo apt-get upgrade --yes -y -qq
sudo apt-get install --yes -y -qq git-core 
sudo apt-get install --yes -y -qq build-essential 
sudo apt-get install --yes -y -qq debhelper 
sudo apt-get install --yes -y -qq cdbs 
sudo apt-get install --yes -y -qq autoconf 
sudo apt-get install --yes -y -qq automake 
sudo apt-get install --yes -y -qq libtool 
sudo apt-get install --yes -y -qq libusb-1.0-0-dev 
sudo apt-get install --yes -y -qq libsystemd-daemon-dev 
sudo apt-get install --yes -y -qq dh-systemd
echo 30 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                        Installation de PTHSEM V2.0.8 libraries                                    *"
echo "*****************************************************************************************************"
sudo apt-get install cdbs --yes -y -qq
wget https://sourceforge.net/projects/bcusdk/files/pthsem/pthsem_2.0.8.tar.gz/download -O pthsem_2.0.8.tar.gz
tar xzf pthsem_2.0.8.tar.gz
echo 35 > /tmp/compilation_eibd_in_progress
cd pthsem-2.0.8
sudo dpkg-buildpackage -b -uc
echo 40 > /tmp/compilation_eibd_in_progress
cd ..
sudo dpkg -i libpthsem*.deb
mkdir -p /etc/eibd
chmod 777 /etc/eibd
echo "v2.0.8" > /etc/eibd/pthsem_VERSION
echo 50 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                                      Installation de KnxD                                         *"
echo "*****************************************************************************************************"
git clone https://github.com/knxd/knxd.git
echo 55 > /tmp/compilation_eibd_in_progress
sudo mv knxd-master knxd
cd knxd
sudo dpkg-buildpackage -b -uc
echo 70 > /tmp/compilation_eibd_in_progress
cd ..
sudo dpkg -i knxd_*.deb knxd-tools_*.deb
echo 90 > /tmp/compilation_eibd_in_progress
echo " " > /var/log/knxd.log
sudo chmod 777 /var/log/knxd.log
echo "v0.10" > /etc/eibd/knxd_VERSION
rm /tmp/compilation_eibd_in_progress
