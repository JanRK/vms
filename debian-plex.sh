echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list


wget --output-document=/usr/share/keyrings/plex.key https://downloads.plex.tv/plex-keys/PlexSign.key
gpg --dearmor --yes /usr/share/keyrings/plex.key
echo "deb [signed-by=/usr/share/keyrings/plex.key.gpg] https://downloads.plex.tv/repo/deb public main" > /etc/apt/sources.list.d/plex.list

apt-get install -y plexmediaserver beignet-opencl-icd ocl-icd-libopencl1