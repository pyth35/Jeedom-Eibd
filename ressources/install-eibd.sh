#!/bin/bash
PWDRESSOURCE=$(cd ${0%/*}; pwd)
INSTALL_DIR=/usr/local/bin
TEMP_DIR=`mktemp -d /tmp/eibd.XXXXXX`
EIBD_bin=$INSTALL_DIR/eibd
touch /tmp/compilation_eibd_in_progress
echo 0 > /tmp/compilation_eibd_in_progress
check_run()  {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1" >&2
   exit
    fi
    return $status
}

# Check for root priviledges
if [ $(id -u) != 0 ]
then
   echo "Superuser (root) priviledges are required to install eibd"
   echo "Please do 'sudo -s' first"
   exit 1
fi

echo "*****************************************************************************************************"
echo "*                                Installing additional libraries                                    *"
echo "*****************************************************************************************************"
apt-get -qy install build-essential 
echo 5 > /tmp/compilation_eibd_in_progress

if [ "$(cat /etc/eibd/pthsem_VERSION)" != "v2.0.8.1" ]
then

echo "*****************************************************************************************************"
echo "*                              Installing PTHSEM V2.0.8 libraries                                   *"
echo "*****************************************************************************************************"
echo "Getting pthsem..."
cd $TEMP_DIR
tar zxvf "$PWDRESSOURCE/pthsem_2.0.8.1.tar.gz"
echo 10 > /tmp/compilation_eibd_in_progress

cd pthsem-2.0.8

echo "Compiliing pthsem..." 
check_run ./configure --with-mctx-mth=sjlj --with-mctx-dsp=ssjlj --with-mctx-stk=sas --disable-shared

echo 20 > /tmp/compilation_eibd_in_progress

check_run make
echo 40 > /tmp/compilation_eibd_in_progress
check_run sudo make install
echo 45 > /tmp/compilation_eibd_in_progress
export LD_LIBRARY_PATH="/usr/local/lib"
sudo ldconfig 
mkdir -p /etc/eibd
echo "v2.0.8.1" > /etc/eibd/pthsem_VERSION
fi
echo 50 > /tmp/compilation_eibd_in_progress
if [ "$(cat /etc/eibd/bcusdk_VERSION)" != "v0.0.5.1" ] 
then
echo "*****************************************************************************************************"
echo "*                              Installing BCUSDK V0.0.5 libraries                                   *"
echo "*****************************************************************************************************"
echo "Getting bcusdk..."
cd $TEMP_DIR
tar zxvf "$PWDRESSOURCE/bcusdk_0.0.5.tar.gz"
echo 60 > /tmp/compilation_eibd_in_progress
cd bcusdk-0.0.5 

echo "Compiliing bcusdk..."
check_run ./configure --without-pth-test --enable-onlyeibd --enable-eibnetip --enable-eibnetiptunnel --enable-eibnetipserver --enable-groupcache --enable-usb --enable-ft12 --enable-tpuarts

echo 70 > /tmp/compilation_eibd_in_progress
check_run make
echo 85 > /tmp/compilation_eibd_in_progress
check_run sudo make install
echo 90 > /tmp/compilation_eibd_in_progress

echo "v0.0.5.1" > /etc/eibd/bcusdk_VERSION
fi

# Add eibd.log to logrotate
echo '/var/log/eibd.log {
        daily
        size=10M
        rotate 4
        compress
        nodelaycompress
        missingok
        notifempty
}' > /etc/logrotate.d/eibd

echo 100 > /tmp/compilation_eibd_in_progress
echo "*****************************************************************************************************"
echo "*                              Installing terminé avec succes                                  *"
echo "*****************************************************************************************************"
rm /tmp/compilation_eibd_in_progress