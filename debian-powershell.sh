#!/bin/bash
# wget -O - https://raw.githubusercontent.com/JanRK/vms/master/debian-powershell.sh | bash

# Install powershell
apt-get update
apt-get install -y --no-install-recommends gnupg wget ca-certificates
wget --directory-prefix=/usr/share/keyrings https://packages.microsoft.com/keys/microsoft.asc
gpg --dearmor --yes /usr/share/keyrings/microsoft.asc
. /etc/os-release
echo "deb [signed-by=/usr/share/keyrings/microsoft.asc.gpg] https://packages.microsoft.com/debian/$VERSION_ID/prod $VERSION_CODENAME main" > /etc/apt/sources.list.d/microsoft.list
apt-get update
apt-get install -y --no-install-recommends powershell
