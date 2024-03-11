apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
wget --output-document=/usr/share/keyrings/docker https://download.docker.com/linux/debian/gpg
gpg --dearmor --yes /usr/share/keyrings/docker
. /etc/os-release
echo "deb [signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $VERSION_CODENAME stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io


# COMPOSE_VERSION=v2.24.0
# echo $COMPOSE_VERSION
# sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose