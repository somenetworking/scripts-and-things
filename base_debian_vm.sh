$USER_ID=""
$NTP_SERVER=""
su -c "apt-get update -y && apt-get full-upgrade -y && apt-get install sudo -y && usermod -aG $USER_ID && newgrp sudo"
su -c "  sed -i 's/#NTP=/$NTP_SERVER/' /etc/systemd/timesyncd.conf"
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker ${SUDO_USER:-$USER}
sudo newgrp docker
mkdir /home/$USER/docker-container-data && mkdir /home/$USER/docker-container-compose
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
sudo echo "{"log-driver":"loki","log-opts":{"loki-url":"http://mgmt-bntnkyaaloki01.andrew-shea.net:3100/loki/api/v1/push","loki-batch-size":"400"}}" > /etc/docker/daemon.json

