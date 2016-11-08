#!/bin/bash
INSTALL_DIR=/usr/local/bin
TEMP_DIR=`mktemp -d /tmp/eibd.XXXXXX`
if [ -f "/etc/eibd/pthsem_VERSION" ]
then
  echo "*****************************************************************************************************"
  echo "*                              Remove PTHSEM V2.0.8 libraries                                       *"
  echo "*****************************************************************************************************"
  sudo rm /etc/eibd/pthsem_VERSION
  echo $LD_LIBRARY_PATH
  export LD_LIBRARY_PATH="/usr/local/lib"
  sudo ldconfig 
  rm $TEMP_DIR/pthsem-2.0.8
fi
if [ -f "/etc/eibd/bcusdk_VERSION" ]
then
  echo "*****************************************************************************************************"
  echo "*                              Remove BCUSDK V0.0.5 libraries                                       *"
  echo "*****************************************************************************************************"
  rm $TEMP_DIR/bcusdk-0.0.5 
  rm /etc/eibd/bcusdk_VERSION
fi
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
rm -R /etc/eibd
rm -rf /usr/local/lib/libeibclient.so
rm -rf /usr/local/lib/libeibclient.so.0
rm -rf /usr/local/lib/libeibclient.a
rm -rf /usr/local/lib/libeibclient.la
rm -rf /usr/local/lib/libeibclient.so.0.0.0
TEMP_DIR=`mktemp -d /tmp/knxd.XXXXXX`
KNXD_bin=$INSTALL_DIR/knxd
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
echo "*****************************************************************************************************"
echo "*                        Installation de PTHSEM V2.0.8 libraries                                    *"
echo "*****************************************************************************************************"
sudo apt-get install cdbs --yes -y -qq
wget https://sourceforge.net/projects/bcusdk/files/pthsem/pthsem_2.0.8.tar.gz/download
tar xzf pthsem_2.0.8.tar.gz
cd pthsem-2.0.8
sudo dpkg-buildpackage -b -uc
cd ..
sudo dpkg -i libpthsem*.deb
echo "v2.0.8" > /etc/eibd/pthsem_VERSION
echo "*****************************************************************************************************"
echo "*                                      Installation de KnxD                                         *"
echo "*****************************************************************************************************"
git clone https://github.com/knxd/knxd.git

sudo mv knxd-master knxd
cd knxd

sudo dpkg-buildpackage -b -uc
cd ..
sudo dpkg -i knxd_*.deb knxd-tools_*.deb

echo " " > /var/log/knxd.log
sudo chmod 777 /var/log/knxd.log
echo "v0.10"" > /etc/eibd/knxd_VERSION
