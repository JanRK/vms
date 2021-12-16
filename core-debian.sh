#!/bin/bash
# wget -O - https://raw.githubusercontent.com/JanRK/vms/master/core-debian.sh | bash

# Skip translations
sh -c "echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations"
rm -r /var/lib/apt/lists


# Switch to https repos
apt-get update
apt-get -y install apt-transport-https ca-certificates

aptlists=$(find /etc/apt -type f -name "*.list")
for filename in $aptlists; do
  sed -i 's|http://ftp.acc.umu.se|https://deb.debian.org|g' $filename
  sed -i 's|https://ftp.acc.umu.se|https://deb.debian.org|g' $filename
  sed -i 's|http://ftp.debian.org|https://deb.debian.org|g' $filename
  sed -i 's|http://deb.debian.org|https://deb.debian.org|g' $filename
  sed -i 's|http://storage.googleapis.com|https://storage.googleapis.com|g' $filename
  sed -i 's|http://packages.cloud.google.com|https://packages.cloud.google.com|g' $filename
  sed -i 's|http://apt.llvm.org|https://apt.llvm.org|g' $filename
  sed -i 's|http://repo.mysql.com|https://repo.mysql.com|g' $filename
  sed -i 's|http://apt.postgresql.org|https://apt.postgresql.org|g' $filename
  sed -i 's|http://raspbian.raspberrypi.org/raspbian/|https://ftp.acc.umu.se/mirror/raspbian/raspbian/|g' $filename
done
apt-get update


# Default packages
apt-get update
apt-get upgrade -y
apt-get -y install openssh-server sudo curl wget nano software-properties-common unzip p7zip ca-certificates dirmngr gnupg


# Setup SSH
createUser="jan"
if id $createUser &>/dev/null; then
    # user found
else
    # echo 'user not found'
    useradd --create-home --shell /bin/bash $createUser
fi

adduser $createUser sudo
mkdir -p /home/$createUser/.ssh
chmod 700 /home/$createUser/.ssh
wget -O /home/$createUser/.ssh/authorized_keys https://github.com/janrk.keys
chmod 644 /home/$createUser/.ssh/authorized_keys
chown -R $createUser:$createUser /home/$createUser/.ssh
service sshd restart


# Install Hypervisor tools
apt-get -y install virt-what
virtwhat=$(virt-what)
if [[ $virtwhat = kvm ]]; then
  echo "Found Proxmox"
  apt-get -y install qemu-guest-agent
  service qemu-guest-agent start

  # Enable serial port
  systemctl enable serial-getty@ttyS0.service
  systemctl start serial-getty@ttyS0.service
fi
if [[ $virtwhat = vmware ]]; then
  echo "Found VMware"
  apt-get -y install open-vm-tools
  service open-vm-tools start
fi
apt-get -y purge virt-what
