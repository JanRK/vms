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
  sed -i 's|https\?://ftp.acc.umu.se|https://deb.debian.org|g' $filename
  sed -i 's|https\?://ftp.dk.debian.org|https://deb.debian.org|g' $filename
  sed -i 's|https\?://ftp.debian.org|https://deb.debian.org|g' $filename
  sed -i 's|https\?://deb.debian.org|https://deb.debian.org|g' $filename
  sed -i 's|https\?://storage.googleapis.com|https://storage.googleapis.com|g' $filename
  sed -i 's|https\?://packages.cloud.google.com|https://packages.cloud.google.com|g' $filename
  sed -i 's|https\?://apt.llvm.org|https://apt.llvm.org|g' $filename
  sed -i 's|https\?://repo.mysql.com|https://repo.mysql.com|g' $filename
  sed -i 's|https\?://apt.postgresql.org|https://apt.postgresql.org|g' $filename
  sed -i 's|https\?://raspbian.raspberrypi.org/raspbian/|https://mirrors.dotsrc.org/raspbian/raspbian/|g' $filename
  sed -i 's|https\?://archive.raspberrypi.org/debian/|https://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/|g' $filename
  sed -i 's|https\?://apt.armbian.com|https://apt.armbian.com|g' $filename
done
apt-get update


# Default packages
apt-get update
apt-get upgrade -y
apt-get -y install openssh-server sudo curl wget nano software-properties-common unzip p7zip ca-certificates dirmngr gnupg


# Setup SSH
createUser="jan"
if id $createUser &>/dev/null; then
    echo "user $createUser found"
else
    echo "user $createUser not found"
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
if [[ $virtwhat = hyperv ]]; then
  echo "Found HyperV"
  # No tools needed.
fi
apt-get -y purge virt-what
