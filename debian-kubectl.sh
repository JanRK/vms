. /etc/os-release
wget -O /usr/share/keyrings/gcloud-key.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# echo "deb [signed-by=/usr/share/keyrings/gcloud-key.gpg] https://packages.cloud.google.com/apt cloud-sdk-$VERSION_CODENAME main" > /etc/apt/sources.list.d/gcloud.list
echo "deb [signed-by=/usr/share/keyrings/gcloud-key.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

apt-get update
# apt-get install -y --no-install-recommends kubectl google-cloud-sdk
apt-get install -y --no-install-recommends kubectl
