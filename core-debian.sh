#!/bin/bash
# wget -O - https://raw.githubusercontent.com/JanRK/vms/master/core-debian.sh | bash

# Skip translations
sh -c "echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations"
rm -r /var/lib/apt/lists


# Switch to https repos
apt-get update
apt-get -y install apt-transport-https ca-certificates
sed -i 's|http://ftp.acc.umu.se|https://ftp.acc.umu.se|g' /etc/apt/sources.list
apt-get update


# Default packages
apt-get update
apt-get upgrade -y
apt-get -y install openssh-server sudo curl wget nano software-properties-common unzip p7zip ca-certificates dirmngr gnupg


# Setup SSH
adduser jan sudo
mkdir -p /home/jan/.ssh
chmod 700 /home/jan/.ssh
wget -O /home/jan/.ssh/authorized_keys https://github.com/janrk.keys
chmod 644 /home/jan/.ssh/authorized_keys
chown -R jan:jan /home/jan/.ssh
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
