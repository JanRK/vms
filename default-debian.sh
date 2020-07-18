#!/bin/bash
# wget -O - https://raw.githubusercontent.com/JanRK/vms/master/default-debain.sh | bash


# Skip translations
sh -c "echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations"
rm /var/lib/apt/lists/*


# Default packages
apt-get update && apt-get upgrade -y
apt-get -y install openssh-server sudo curl wget httpie nano unattended-upgrades software-properties-common unzip p7zip apt-transport-https ca-certificates dirmngr gnupg


# Switch to https repos
sed -i 's|http://ftp.acc.umu.se|https://ftp.acc.umu.se|g' /etc/apt/sources.list
apt-get update


# Setup SSH
mkdir -p /home/jan/.ssh
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


