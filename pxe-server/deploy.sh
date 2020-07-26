#!/bin/bash

# wget -O - https://bit.ly/3eVi0WP | bash

wget -O - https://raw.githubusercontent.com/JanRK/vms/master/default-debian.sh | bash

apt-get update
apt-get -y install tftpd-hpa subversion nginx 


# Build iPXE
apt-get -y install git gcc binutils make perl liblzma-dev mtools

git clone git://git.ipxe.org/ipxe.git
ipxedir=$(pwd)/ipxe/src
cd $ipxedir
TAB=$'\t'
sed -i "s|#undef${TAB}DOWNLOAD_PROTO_HTTPS|#define${TAB}DOWNLOAD_PROTO_HTTPS|g" config/general.h
sed -i "s|#undef${TAB}DOWNLOAD_PROTO_NFS|#define${TAB}DOWNLOAD_PROTO_NFS|g" config/general.h
make bin/undionly.kpxe

rm -rf /srv
mkdir -p /srv
# svn ls https://github.com/JanRK/vms.git/trunk/pxe-server/tftp
svn export https://github.com/JanRK/vms.git/trunk/pxe-server /srv/pxe --force
sed -i 's|/srv/tftp|/srv/pxe/tftp|g' /etc/default/tftpd-hpa

# iPXE boot
mkdir -p /srv/pxe/tftp 
# wget -O /srv/pxe/tftp/undionly.kpxe http://boot.ipxe.org/undionly.kpxe
cp $ipxedir/bin/undionly.kpxe /srv/pxe/tftp/undionly.kpxe
# pxe boot debian
#wget http://ftp.nl.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/netboot.tar.gz
#tar xvzf /home/jan/netboot.tar.gz -C /srv/tftp/

chmod -R 644 /srv/pxe/tftp
chown -R tftp:tftp /srv/pxe/tftp
service tftpd-hpa restart




# nginx config
sed -i 's|/var/www/html|/srv/pxe/www|g' /etc/nginx/sites-enabled/default
sed -i '/First attempt to/iautoindex on;' /etc/nginx/sites-enabled/default
service nginx restart
# wget -O /srv/pxe/www/ipxe.lkrn http://boot.ipxe.org/ipxe.lkrn 
cp $ipxedir/bin/undionly.kpxe /srv/pxe/www/undionly.kpxe
