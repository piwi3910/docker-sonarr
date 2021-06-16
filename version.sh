echo "Finding latest Sabnzbd release and set it as a env.variable to use during docker build"
apt update -y
apt install curl grep -y
version=$(curl --silent "https://api.github.com/repos/sonarr/sonarr/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
echo "version=$version" >> vars.env

