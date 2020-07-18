#!/bin/bash


# Default packages
apt-get update && apt-get upgrade -y
apt-get -y install openssh-server sudo curl wget httpie nano unattended-upgrades software-properties-common unzip p7zip apt-transport-https ca-certificates dirmngr gnupg


# Switch to https repos
sed -i 's|http://ftp.acc.umu.se|https://ftp.acc.umu.se|g' /etc/apt/sources.list


# Setup SSH
mkdir /home/jan/.ssh
chmod 700 /home/jan/.ssh
curl https://github.com/janrk.keys >> /home/jan/.ssh/authorized_keys
chmod 644 /home/jan/.ssh/authorized_keys


# Install Hypervisor tools
apt-get -y install virt-what
if [[ $(virt-what) = kvm ]]; then
  echo "Found Proxmox"
  apt-get -y install qemu-guest-agent
fi
apt-get -y purge virt-what


# Skip translations
sh -c "echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations"


# unattended-upgrades
cat > /etc/apt/apt.conf.d/20auto-upgrades << EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

timetid=$(shuf -i 3-5 -n 1)
minuttid=$(shuf -i 10-59 -n 1)

cat >>  /etc/apt/apt.conf.d/50unattended-upgrades << EOF
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "0$timetid:$minuttid";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
EOF


