#!/bin/bash
INSTALL_DIR=/usr/local/bin
TEMP_DIR=`mktemp -d /tmp/knxd.XXXXXX`
KNXD_bin=$INSTALL_DIR/knxd
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
echo "*****************************************************************************************************"
echo "*                                Installation des dependances                                       *"
echo "*****************************************************************************************************"
sudo apt-get update --yes -y -qq
sudo apt-get upgrade --yes -y -qq

PAQUAGES=${PAQUAGES}" gcc g++ make"
echo "-------------------------------------------------------------------"
echo "Liste des paquets installés 1/2 : "
echo ${PAQUAGES}
echo "-------------------------------------------------------------------"
sudo apt-get install ${PAQUAGES} --yes -y -qq
PAQUAGES=" ";

PAQUAGES=${PAQUAGES}" libcurl4-openssl-dev openssl libssl-dev build-essential file autoconf dh-make debhelper devscripts fakeroot gnupg"
echo "-------------------------------------------------------------------"
echo "Liste des paquets installés 2/2 : "
echo ${PAQUAGES}
echo "-------------------------------------------------------------------"
sudo apt-get install ${PAQUAGES} --yes -y -qq
PAQUAGES=" ";
  
echo "-------------------------------------------------------------------"
echo " Fin de l'install des paquets nécessaires : "
echo "-------------------------------------------------------------------"
sudo apt-get install -f -y -qq --yes
PAQUAGES=" ";

echo "*****************************************************************************************************"
echo "*                                      Installation de KnxD                                         *"
echo "*****************************************************************************************************"

KNXD_PATH=`which knxd`
if test x$KNXD_PATH = x; then :
  echo "Installation de knxd 0.10                    "

  sudo apt-get install cdbs --yes -y -qq

  wget https://www.auto.tuwien.ac.at/~mkoegler/pth/pthsem_2.0.8.tar.gz
  tar xzf pthsem_2.0.8.tar.gz
  cd pthsem-2.0.8
  sudo dpkg-buildpackage -b -uc
  cd ..
  sudo dpkg -i libpthsem*.deb

  echo "Installation de pthsem terminée "

  #echo " executer sudo VISUDO et ajouter: www-data ALL=(ALL) NOPASSWD: ALL "
  #sudo wget -O knxd.zip https://github.com/knxd/knxd/archive/master.zip

  sudo apt-get install git-core build-essential debhelper cdbs autoconf automake libtool libusb-1.0-0-dev libsystemd-daemon-dev dh-systemd --yes -y -qq
  git clone https://github.com/knxd/knxd.git

  sudo mv knxd-master knxd
  cd knxd

  sudo dpkg-buildpackage -b -uc
  cd ..
  sudo dpkg -i knxd_*.deb knxd-tools_*.deb

  echo " " > /var/log/knxd.log
  sudo chmod 777 /var/log/knxd.log
else
  KNXD_VERSION=`$KNXD_PATH -V`
  echo "KNXD deja installe : $KNXD_VERSION "
fi
echo "-------------------------------------------------------------------"
