#!/bin/bash
remove_eibd(){

echo "*****************************************************************************************************"
echo "*                              Del PTHSEM V2.0.8 libraries                                   *"
echo "*****************************************************************************************************"
sudo rm /etc/eibd/pthsem_VERSION
echo $LD_LIBRARY_PATH
export LD_LIBRARY_PATH="/usr/local/lib"
sudo ldconfig 
rm $TEMP_DIR/pthsem-2.0.8

echo "*****************************************************************************************************"
echo "*                              del BCUSDK V0.0.5 libraries                                   *"
echo "*****************************************************************************************************"

rm $TEMP_DIR/bcusdk-0.0.5 
rm /etc/eibd/bcusdk_VERSION

echo "*****************************************************************************************************"
echo "*                                 Del eibd startup script                                      *"
echo "*****************************************************************************************************"
rm /etc/logrotate.d/eibd
rm /etc/default/eibd
rm /var/log/eibd.log
rm -R /etc/eibd
rm -rf /usr/local/lib/libeibclient.so
rm -rf /usr/local/lib/libeibclient.so.0
rm -rf /usr/local/lib/libeibclient.a
rm -rf /usr/local/lib/libeibclient.la
rm -rf /usr/local/lib/libeibclient.so.0.0.0
}
install_dependances ()
{
  echo "-------------------------------------------------------------------"
  echo "Installation des dependances                    "
  echo "-------------------------------------------------------------------"
  #sudo apt-get install gcc g++ make locales --yes -y -qq

  sudo apt-get update --yes -y -qq
  sudo apt-get upgrade --yes -y -qq


  PAQUAGES=${PAQUAGES}" gcc g++ make"
  echo "-------------------------------------------------------------------"
  echo "Liste des paquets installés 1/3 : "
  echo ${PAQUAGES}
  echo "-------------------------------------------------------------------"
  sudo apt-get install ${PAQUAGES} --yes -y -qq
  PAQUAGES=" ";

  PAQUAGES=${PAQUAGES}" liblog4cpp5-dev libesmtp-dev liblua5.1-0-dev libxml2 dpkg"
  echo "-------------------------------------------------------------------"
  echo "Liste des paquets installés 2/3 : "
  echo ${PAQUAGES}
  echo "-------------------------------------------------------------------"
  sudo apt-get install ${PAQUAGES} --yes -y -qq
  PAQUAGES=" ";
  PAQUAGES=${PAQUAGES}" libcurl4-openssl-dev openssl libssl-dev build-essential file autoconf dh-make debhelper devscripts fakeroot gnupg"
  echo "-------------------------------------------------------------------"
  echo "Liste des paquets installés 3/3 : "
  echo ${PAQUAGES}
  echo "-------------------------------------------------------------------"
  sudo apt-get install ${PAQUAGES} --yes -y -qq
  PAQUAGES=" ";
  echo "-------------------------------------------------------------------"
  echo " Fin de l'install des paquets nécessaires : "
  echo "-------------------------------------------------------------------"
  sudo apt-get install -f -y -qq --yes
  PAQUAGES=" ";
}
install_knxd ()
{
echo "-------------------------------------------------------------------"
echo "----======  knxd 0.10  ======----"
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

# sudo nano /etc/knxd.conf
# KNXD_OPTS=="-u /tmp/eib -u /var/run/knx -i -b ipt:192.168.188.XX"
# KNXD_OPTS=="-u /tmp/eib -u /var/run/knx -i -b ipt:$knxd_ipport"
# sudo nano /etc/default/knxd
# START_KNXD=YES

  # KNXD_OPTS="-u /tmp/eib -b ip:"
  # try KNXnet/IP Routing with default Multicast 224.0.23.12
  echo "\t *** Autodetecting Interface IP/KNX."
  EIBNETTMP=`mktemp`
  eibnetsearch - > $EIBNETTMP
  # Take only first :
  EIBD_NET_MCAST=`grep Multicast $EIBNETTMP | cut -d' ' -f2 | sed -n '1p'`
  # Take only first :
  EIBD_NET_HOST=`grep Answer $EIBNETTMP | cut -d' ' -f3 | sed -n '1p'`
  EIBD_NET_PORT=`grep Answer $EIBNETTMP | cut -d' ' -f6 | sed -n '1p'`
  # Take only first :
  EIBD_NET_NAME=`grep Name $EIBNETTMP | cut -d' ' -f2 | sed -n '1p'`

  EIBD_MY_IP=`ifconfig eth0 | grep 'inet addr' | sed -e 's/:/ /' | awk '{print $3}'`
  rm $EIBNETTMP
  if [ "$EIBD_NET_MCAST" != "" -a "$EIBD_NET_HOST" != "$EIBD_MY_IP" ]; then
    echo "Found KNXnet/IP Router $EIBD_NET_NAME on $EIBD_NET_HOST with $EIBD_NET_MCAST"
    #sudo echo "KNXD_OPTS=\"--daemon=/var/log/knxd.log -D -T -R -S ip:$EIBD_NET_HOST\"" >> /etc/knxd.conf
    sudo echo "KNXD_OPTS=\"-u /tmp/eib -b ip:$EIBD_NET_HOST\"" >> /etc/knxd.conf
  fi

else
  KNXD_VERSION=`$KNXD_PATH -V`
  echo "KNXD deja installe : $KNXD_VERSION "
fi
echo "-------------------------------------------------------------------"
echo "v0.10" > /etc/eibd/knxd_VERSION
}

remove_eibd
install_dependances
install_knxd
