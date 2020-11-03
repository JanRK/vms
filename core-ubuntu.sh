#!/bin/bash
# wget -O - https://raw.githubusercontent.com/JanRK/vms/master/core-ubuntu.sh | bash

# Skip translations
sh -c "echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations"
rm -r /var/lib/apt/lists


# Switch to https repos
apt-get update
apt-get -y install apt-transport-https ca-certificates
sed -i 's|http://se.archive.ubuntu.com|https://ftp.acc.umu.se|g' /etc/apt/sources.list
apt-get update


# Default packages
apt-get update
apt-get upgrade -y
apt-get -y install openssh-server sudo curl wget nano software-properties-common unzip p7zip ca-certificates dirmngr gnupg


# Install Hypervisor tools
apt-get -y install virt-what
virtwhat=$(virt-what)
if [[ $virtwhat = kvm ]]; then
  echo "Found Proxmox"
  apt-get -y purge open-vm-tools
  apt-get -y autoremove
  apt-get -y install qemu-guest-agent
  service qemu-guest-agent start
  
  # Enable serial port
  systemctl enable serial-getty@ttyS0.service
  systemctl start serial-getty@ttyS0.service
fi
if [[ $virtwhat = vmware ]]; then
  echo "Found VMware, tools already installed on Ubuntu."
  # apt-get -y install open-vm-tools
  # service open-vm-tools start
fi
apt-get -y purge virt-what
