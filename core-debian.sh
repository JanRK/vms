#!/bin/bash
# wget -O - https://raw.githubusercontent.com/JanRK/vms/master/core-debian.sh | bash
# wget -O - https://bit.ly/core-debian | bash
# wget -L -O - https://s.janrk.org/debian | bash

# Ensure /usr/sbin is in PATH (Trixie no longer includes it by default)
export PATH="$PATH:/usr/sbin"

# Skip translations
sh -c "echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations"
rm -rf /var/lib/apt/lists/*


# Switch to https repos
apt-get update
apt-get -y install ca-certificates

aptlists=$(find /etc/apt -type f \( -name "*.list" -o -name "*.sources" \))
for filename in $aptlists; do
  sed -i 's|https\?://ftp.acc.umu.se|https://deb.debian.org|g' "$filename"
  sed -i 's|https\?://ftp.dk.debian.org|https://deb.debian.org|g' "$filename"
  sed -i 's|https\?://ftp.debian.org|https://deb.debian.org|g' "$filename"
  sed -i 's|http://deb.debian.org|https://deb.debian.org|g' "$filename"
  sed -i 's|http://storage.googleapis.com|https://storage.googleapis.com|g' "$filename"
  sed -i 's|http://packages.cloud.google.com|https://packages.cloud.google.com|g' "$filename"
  sed -i 's|http://apt.llvm.org|https://apt.llvm.org|g' "$filename"
  sed -i 's|http://repo.mysql.com|https://repo.mysql.com|g' "$filename"
  sed -i 's|http://apt.postgresql.org|https://apt.postgresql.org|g' "$filename"
  sed -i 's|https\?://raspbian.raspberrypi.org/raspbian/|https://mirrors.dotsrc.org/raspbian/raspbian/|g' "$filename"
  sed -i 's|https\?://archive.raspberrypi.org/debian/|https://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/|g' "$filename"
  sed -i 's|http://apt.armbian.com|https://apt.armbian.com|g' "$filename"
  sed -i 's|https\?://archive.raspberrypi.com/debian/|https://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/|g' "$filename"
  sed -i 's|http://security.debian.org/debian-security|https://deb.debian.org/debian-security|g' "$filename"
  sed -i 's|http://security.ubuntu.com/ubuntu|https://security.ubuntu.com/ubuntu|g' "$filename"
  sed -i 's|http://eu-stockholm-1-ad-1.clouds.archive.ubuntu.com/ubuntu|https://eu-stockholm-1-ad-1.clouds.archive.ubuntu.com/ubuntu|g' "$filename"
done
apt-get update


# Default packages
apt-get upgrade -y
apt-get -y install openssh-server sudo curl wget nano unzip 7zip ca-certificates dirmngr gnupg


# Setup SSH
createUser="jan"
if id $createUser &>/dev/null; then
    echo "user $createUser found"
else
    echo "user $createUser not found"
    useradd --create-home --shell /bin/bash $createUser
fi

usermod -aG sudo $createUser
mkdir -p /home/$createUser/.ssh
chmod 700 /home/$createUser/.ssh
wget -O /home/$createUser/.ssh/authorized_keys https://github.com/janrk.keys
chmod 644 /home/$createUser/.ssh/authorized_keys
chown -R $createUser:$createUser /home/$createUser/.ssh
systemctl restart sshd


# Install Hypervisor tools
apt-get -y install virt-what
virtwhat=$(virt-what)
if [[ $virtwhat = kvm ]]; then
  echo "Found Proxmox"
  apt-get -y install qemu-guest-agent
  systemctl start qemu-guest-agent

  # Enable serial port
  systemctl enable serial-getty@ttyS0.service
  systemctl start serial-getty@ttyS0.service
fi
if [[ $virtwhat = vmware ]]; then
  echo "Found VMware"
  apt-get -y install open-vm-tools
  systemctl start open-vm-tools
fi
if [[ $virtwhat = hyperv ]]; then
  echo "Found HyperV"
  # No tools needed.
fi
apt-get -y purge virt-what
