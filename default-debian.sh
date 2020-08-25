#!/bin/bash
# wget -O - https://raw.githubusercontent.com/JanRK/vms/master/default-debian.sh | bash
# wget -O - https://bit.ly/398iwiM | bash

wget -O - https://raw.githubusercontent.com/JanRK/vms/master/core-debian.sh | bash


# Default packages
apt-get update
apt-get upgrade -y
apt-get -y install httpie


# unattended-upgrades
apt-get update
apt-get -y install unattended-upgrades
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


